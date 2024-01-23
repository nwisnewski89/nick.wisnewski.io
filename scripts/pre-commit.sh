#!/usr/bin/env bash

npm run format

working_dir=$(pwd)
for d in terraform/modules/*; do
  if terraform-docs md "${d}" > "${d}/README.md"; then
    git add "./${d}/README.md"
  fi
  cd ${d}
  terraform fmt
  cd ${working_dir}
done