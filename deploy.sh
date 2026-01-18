#!/bin/bash

# Exit on error
set -e

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project
hugo --gc --minify

# Define publish directory
PUBLISH_DIR="../heisantosh.github.io"

if [ ! -d "$PUBLISH_DIR" ]; then
  echo "Error: Directory $PUBLISH_DIR does not exist."
  exit 1
fi

# Sync files using rsync
# -a: archive mode
# -v: verbose
# --delete: remove files in dest that are not in src
# --exclude: protect the .git directory
rsync -av --delete --exclude '.git' public/ "$PUBLISH_DIR/"

# Navigate to publish directory
cd "$PUBLISH_DIR"

# Add changes to git
git add .

# Commit changes
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push to remote
# Check current branch name (usually master or main)
BRANCH=$(git rev-parse --abbrev-ref HEAD)
git push origin "$BRANCH"

echo -e "\033[0;32mSite deployed successfully!\033[0m"
