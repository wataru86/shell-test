#!/bin/bash

set -eux

if [ $# -ne 1 ]; then
  exit 1
fi

# develospなう?
branch=$(git symbolic-ref --short HEAD)
if [ $branch != "develop" ]; then
  echo "developブランチで実行してください"
  exit 1
fi

# package.yaml を更新する

hash=(`md5sum package.yaml`)
yq -y ".version |= \"$1\"" package.yaml > $hash
mv $hash package.yaml

git add package.yaml
git commit -m "Release Version $1"

git checkout master
git merge --no-ff --no-edit develop

git checkout develop
git rebase master
