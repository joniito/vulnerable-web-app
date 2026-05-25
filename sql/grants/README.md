# Redshift Grants — Guía de configuración

## Estructura

```
sql/grants/
  grants_dev.sql      # Grants para DEV
  grants_staging.sql  # Grants para STAGING
  grants_prod.sql     # Grants para PROD (requiere aprobación manual)
```

## Cómo funciona el workflow

### Triggers
| Evento | Ambiente | Aprobación |
|--------|----------|------------|
| Push a `master` con cambios en `sql/grants/` | `dev` automático | No |
| `workflow_dispatch` → dev / staging | Seleccionado | No |
| `workflow_dispatch` → prod | prod | **Sí** (revisor requerido) |

### Dry-run
Activar el toggle **Dry-run** en el `workflow_dispatch` imprime el SQL en el
Job Summary sin ejecutarlo en Redshift. Útil para validar antes de aplicar.

---

## Configuración AWS requerida

### 1. OIDC Provider en AWS

```bash
# Crear el OIDC provider de GitHub en tu cuenta AWS (solo una vez por cuenta)
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

### 2. Rol IAM por ambiente

Crear un rol por ambiente (`redshift-grants-dev`, `redshift-grants-staging`,
`redshift-grants-prod`) con el siguiente trust policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:<ORG>/<REPO>:*"
        }
      }
    }
  ]
}
```

Policy mínima adjunta al rol:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "redshift-data:ExecuteStatement",
        "redshift-data:DescribeStatement",
        "redshift:GetClusterCredentials"
      ],
      "Resource": "arn:aws:redshift:<REGION>:<ACCOUNT_ID>:cluster:<CLUSTER_ID>"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter"
      ],
      "Resource": "arn:aws:ssm:<REGION>:<ACCOUNT_ID>:parameter/redshift/<ENV>/*"
    }
  ]
}
```

### 3. Parámetros en SSM Parameter Store

```bash
# Por cada ambiente (dev / staging / prod):
aws ssm put-parameter --name /redshift/dev/cluster-identifier --value "my-cluster-dev" --type String
aws ssm put-parameter --name /redshift/dev/database           --value "analytics"       --type String
aws ssm put-parameter --name /redshift/dev/admin-user         --value "admin"           --type SecureString
```

### 4. GitHub Secrets

| Secret | Valor |
|--------|-------|
| `AWS_ROLE_ARN_DEV` | `arn:aws:iam::<ID>:role/redshift-grants-dev` |
| `AWS_ROLE_ARN_STAGING` | `arn:aws:iam::<ID>:role/redshift-grants-staging` |
| `AWS_ROLE_ARN_PROD` | `arn:aws:iam::<ID>:role/redshift-grants-prod` |

### 5. GitHub Environments (protection rule para prod)

En **Settings → Environments → prod**:
- Activar **Required reviewers** y agregar al equipo de DBA/infraestructura.
- Esto bloquea el job `apply-grants` para prod hasta que un revisor apruebe.
