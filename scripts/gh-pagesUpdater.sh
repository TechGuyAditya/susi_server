#!/bin/bash

# Starting the script
echo "Starting gh-pagesUpdater authored by Abishek V Ashok with love for FOSSASIA"
echo "..."

# Create the new directory to work in, these will get cleaned by Travis so no worries
mkdir working_root
cd working_root

# Adding configurations for git
git config --global user.email "no-reply@travis-ci.org"
git config --global user.name "susi-gh-bot"

# Clone the git repository of susi_server project (the gh-pages branch only as we deploy it here only)
git clone -b gh-pages --single-branch https://susi-gh-bot:$SOURCE_UPDATER@github.com/fossasia/susi_server.git
cd susi_server

# Switching to the gh-pages branch that we recently cloned
git checkout gh-pages

# Copy the needed docs force replace them with the current
cp -rf ../../docs ./
cp -rf ../../README.md ./index.md

# Adding everything
git add .

# Checking for staged changes
git status --porcelain|grep "M"

# If there are changes
if [ "$?" = 0 ]; then
  git commit --message "Docs file source update for build:$TRAVIS_BUILD_NUMBER | Generated by Travis CI"
  git remote add origin-pages https://susi-gh-bot:$SOURCE_UPDATER@github.com/fossasia/susi_server.git
  git pull --rebase origin-pages gh-pages
  git push --quiet --set-upstream origin-pages gh-pages
  echo "Commit has been made, Happy coding :)"
else # NO changes then fall back...
  echo "No changes detected.... Not commiting... Happy coding :)"
fi
