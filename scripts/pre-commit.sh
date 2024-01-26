#!/usr/bin/env bash

npm run format
DIFF=$(git diff --cached --name-only)

if [[ "${DIFF}" == *"terraform"* ]]; then
    working_dir=$(pwd)
    for d in terraform/modules/*; do
        terraform-docs md "${d}" > "${d}/README.md"
        cd ${d}
        terraform fmt
        cd ${working_dir}
    done
fi

git add .