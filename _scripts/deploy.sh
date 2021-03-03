#!/bin/bash
# This script enables deploying to GitHub Pages from a compilation in CI to a specific branch rather than relying on GitHub's internal Jekyll compiler.
# This allows you to control dependencies more precisely and use all sorts of custom changes around compilation, such as non-“safe” plugins.
# This script assumes you have already compiled your website locally with `jekyll build`, and that you have manually created the initial `gh-pages` branch as an orphan branch.

COMPILED_SITE_PATH="_site"

set -e

git config user.name "${COMMITTER_NAME}"
git config user.email "${COMMITTER_EMAIL}"

git checkout -- Gemfile.lock

git checkout gh-pages
git pull origin gh-pages

find . -maxdepth 1 ! -name $COMPILED_SITE_PATH ! -name '.git' ! -name '.gitignore' -exec rm -rf {} \;
mv $COMPILED_SITE_PATH/* .
rm -R $COMPILED_SITE_PATH

git add -fA
git commit --allow-empty -m "$(git log master -1 --pretty=%B)"
git push "https://${COMMITTER_GITHUB_ID}@github.com/${USER_NAME}/${REPO_NAME}.git" gh-pages

echo "Deployed successfully"
