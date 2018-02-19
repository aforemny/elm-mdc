#!/usr/bin/env bash

set -o errexit # Exit with nonzero exit code if anything fails
set -o xtrace # Print commands before running them

shopt -s extglob

SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"
CLONE_PATH="_gh-pages-repo"
WORKING_DIR="$(pwd)"

make demo

# Pull requests and commits to other branches shouldn't try to deploy
if [ "$TRAVIS_PULL_REQUEST" != "false" ] || [ "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo "Skipping deploy"
    exit 0
fi

REPO=$(git config remote.origin.url)
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=$(git rev-parse --verify HEAD)

# Clone the existing gh-pages for this repo into $CLONE_PATH/
# Create a new empty branch if gh-pages doesn't exist yet (should only happen on first deploy)
git clone "$REPO" "$CLONE_PATH"
cd "$CLONE_PATH"
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
cd "$WORKING_DIR"

# Clean out existing contents & configure cloned repo
mkdir -p "$CLONE_PATH/master"
cd "$CLONE_PATH/master"
rm -rf !(CNAME) || exit 0
git config user.name "Travis CI"
git config user.email '<>'

cp -r "$WORKING_DIR/build/." .
git add .

# git --no-pager diff --staged

# If there are no changes to the compiled out (e.g. this is a README update) then just bail.
if git diff --quiet --staged .; then
    echo "No changes to the output on this push; exiting."
    exit 0
fi

# Commit the "changes", i.e. the new version.
# The delta will show diffs between new and old versions.
git add --all .
git commit -m "Deploy to GitHub Pages: ${SHA}"

# Setup SSH keys
set +o xtrace
openssl aes-256-cbc \
    -K "$encrypted_f1516dd85f54_key" \
    -iv "$encrypted_f1516dd85f54_iv" \
    -in "$WORKING_DIR/deploy_key.enc" \
    -out deploy_key -d
set -o xtrace

chmod 600 deploy_key

# shellcheck disable=SC2046
eval $(ssh-agent -s)

ssh-add deploy_key

# Push our changes
git push "$SSH_REPO" "$TARGET_BRANCH"
