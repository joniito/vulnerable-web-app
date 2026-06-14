# Infraestructura fundacional (Terraform + Jinja2)

Este directorio contiene los módulos Terraform fundacionales y el mecanismo
para generar el `main.tf` de cada cuenta a partir de un template Jinja2 y
un archivo de datos por cuenta.

## Estructura

```
infra/
├── modules/
│   └── iam-role/        # módulo genérico para crear un rol IAM
│                         # (trust policy, managed policies, inline policies)
├── templates/
│   └── main.tf.j2        # template que compone provider + módulos por rol
├── accounts/
│   └── <account>.yaml    # datos de cada cuenta (account_id, región, roles...)
├── environments/
│   └── <account>/main.tf # archivo generado (no versionar)
└── scripts/
    ├── render.py          # genera environments/<account>/main.tf
    └── requirements.txt
```

## Uso

1. Copiar `accounts/foundational-example.yaml` a `accounts/<nombre-cuenta>.yaml`
   y completar los datos reales de la cuenta (account_id, región, roles a
   desplegar, principals/servicios que pueden asumirlos, políticas, tags).

2. Instalar dependencias:

   ```bash
   pip install -r infra/scripts/requirements.txt
   ```

3. Generar el `main.tf`:

   ```bash
   python infra/scripts/render.py <nombre-cuenta>
   ```

   Esto crea `infra/environments/<nombre-cuenta>/main.tf`.

4. Desplegar:

   ```bash
   cd infra/environments/<nombre-cuenta>
   terraform init
   terraform plan
   terraform apply
   ```

## Roles fundacionales

`accounts/foundational-example.yaml` incluye placeholders para los roles
fundacionales (auditoría cross-account, deploy de Terraform/CI-CD,
break-glass). Los nombres, permisos y principals exactos deben confirmarse
y ajustarse por cuenta antes de desplegar.

## Backend de estado

Por ahora el backend de Terraform queda sin definir (local). Se agregará un
backend remoto (S3 + DynamoDB) más adelante cuando se confirme la
configuración por cuenta.
