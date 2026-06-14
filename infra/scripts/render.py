#!/usr/bin/env python3
"""Render main.tf for an account from its YAML definition using Jinja2."""

import argparse
import pathlib
import sys

import yaml
from jinja2 import Environment, FileSystemLoader

BASE_DIR = pathlib.Path(__file__).resolve().parent.parent
TEMPLATES_DIR = BASE_DIR / "templates"
ACCOUNTS_DIR = BASE_DIR / "accounts"
ENVIRONMENTS_DIR = BASE_DIR / "environments"


def slugify(name: str) -> str:
    return "".join(c if c.isalnum() else "_" for c in name).lower()


def normalize_role(role: dict, account_tags: dict) -> dict:
    role = dict(role)
    role.setdefault("trusted_principals", [])
    role.setdefault("trusted_services", [])
    role.setdefault("managed_policy_arns", [])
    role.setdefault("inline_policies", {})
    role["tags"] = {**account_tags, **role.get("tags", {})}
    role["key"] = slugify(role["name"])
    return role


def load_account(account_file: pathlib.Path) -> dict:
    with open(account_file) as f:
        data = yaml.safe_load(f)

    account = data["account"]
    account.setdefault("tags", {})

    roles = [normalize_role(role, account["tags"]) for role in data.get("roles", [])]

    return {"account": account, "roles": roles}


def render(account_file: pathlib.Path) -> str:
    env = Environment(
        loader=FileSystemLoader(str(TEMPLATES_DIR)),
        trim_blocks=True,
        lstrip_blocks=True,
    )
    template = env.get_template("main.tf.j2")
    context = load_account(account_file)
    return template.render(**context)


def main():
    parser = argparse.ArgumentParser(
        description="Render main.tf from an account YAML file (infra/accounts/<name>.yaml)"
    )
    parser.add_argument("account", help="Account name, without the .yaml extension")
    args = parser.parse_args()

    account_file = ACCOUNTS_DIR / f"{args.account}.yaml"
    if not account_file.exists():
        sys.exit(f"Account file not found: {account_file}")

    output = render(account_file)

    out_dir = ENVIRONMENTS_DIR / args.account
    out_dir.mkdir(parents=True, exist_ok=True)
    out_file = out_dir / "main.tf"
    out_file.write_text(output)

    print(f"Generated {out_file}")


if __name__ == "__main__":
    main()
