#!/usr/bin/env sh

# abort on errors
set -e

# build a fresh static site into dist/
# (webpack 4 needs the legacy OpenSSL provider on Node 17+)
NODE_OPTIONS=--openssl-legacy-provider npm run generate

cd dist

# start from a clean repo each time so there is always something to commit
rm -rf .git
git init -b main
git add -A
git commit -m 'deploying...'

git push -f https://github.com/andrew-lyons/marigold-project.git main:gh-pages

cd -
