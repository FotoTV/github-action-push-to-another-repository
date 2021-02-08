#!/bin/sh -l

echo "Starts"
FOLDER="$1"
GITHUB_USERNAME="$2"
GITHUB_REPO="$3"
USER_EMAIL="$4"
REPO_USERNAME="$5"
COMPOSER_DIRECTORY="$6"

if [ -z "$REPO_USERNAME" ]
then
  REPO_USERNAME=$GITHUB_USERNAME
fi

CLONE_DIR=$(mktemp -d)
BRANCH=$(git branch --show-current)

echo "Cloning destination git repository"
# Setup git
git config --global user.email "$USER_EMAIL"
git config --global user.name "$GITHUB_USERNAME"
git clone --single-branch --branch master "https://$API_TOKEN_GITHUB@github.com/$REPO_USERNAME/$GITHUB_REPO.git" "$CLONE_DIR"
cd $CLONE_DIR
git switch -c $BRANCH
git fetch -a
git pull -v
cd -
ls -la "$CLONE_DIR"

echo "Cleaning destination repository of old files"
# Copy files into the git and deletes all git
find "$CLONE_DIR" | grep -v "^$CLONE_DIR/\.git" | grep -v "^$CLONE_DIR$" | xargs rm -rf # delete all files (to handle deletions)
ls -la "$CLONE_DIR"
git status
git add .
git commit --message "Cleanup before https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
echo "running composer install"

ls -la
echo $COMPOSER_DIRECTORY
echo "/github/workspace//drupal/sites/all/modules/custom"
ls -la /github/workspace//drupal/sites/all/modules/custom
echo '/github/workspace/drupal/sites/all/themes'
ls -la /github/workspace/drupal/sites/all/themes
echo '/github/workspace/drupal/sites/all/themes/custom'
ls -la /github/workspace/drupal/sites/all/themes/custom
cd "$COMPOSER_DIRECTORY" && composer install && cd -
ls -la "$COMPOSER_DIRECTORY"/drupal/sites/all/modules/custom
ls -la "$COMPOSER_DIRECTORY"/drupal/sites/all/themes/custom
ls -la /github/workspace
ls -la /github/workspace/drupal
ls -la /github/workspace/drupal/sites/
ls -la /github/workspace/drupal/sites/all
ls -la /github/workspace/drupal/sites/all/themes

# rm .git repos in subdirectories
find . -name .git | grep -v  "\\$COMPOSER_DIRECTORY/.git" | xargs rm -rf

echo "running compass install"

echo "Copying contents to to git repo"
cp -r "$FOLDER"/* "$CLONE_DIR"
cd "$CLONE_DIR"
ls -la

echo "Adding git commit"
git add .
git status
git commit --message "Update from https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"

echo "Pushing git commit"
git fetch -a
git push origin $BRANCH -f
git status
