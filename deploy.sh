#!/usr/bin/env sh

# abort on errors
set -e

cd dist

git init
git add -A
git commit -m 'deploying...'

git push -f git@github.com:andrew-lyons/marigold-project.git main:gh-pages

cd -
