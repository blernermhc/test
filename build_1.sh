#!/bin/bash

function is_current {
  TO_REPO=$1
  BRANCH=$2
  
  echo TO_REPO = $TO_REPO
  echo BRANCH = $BRANCH
  
  # Make sure both repos are on master
  git checkout $BRANCH
  STATUS=$(git status | head -n 1)
  if [ ! "$STATUS" = "On branch $BRANCH" ]
    then
      echo "Can't switch to $BRANCH of test repo"
      exit 1
  fi
  cd ../$TO_REPO
  git checkout $BRANCH
  STATUS=$(git status | head -n 1)
  if [ ! "$STATUS" = "On branch $BRANCH" ]
    then
      echo "Can't switch to $BRANCH of $TO_REPO"
      exit 1
  fi
  cd ../test
  echo "Working directory = $(pwd)"

  # Get the latest commit number
  COMMIT=$(git show | head -n 1)
  echo COMMIT = $COMMIT

  # Compare to the commit # stored in $TO_REPO
  COMMIT_1=$(cat ../$TO_REPO/.commit)
  echo COMMIT_1 = $COMMIT_1

  # If they are the same we are done
  if [ "$COMMIT" == "$COMMIT_1" ] 
    then
      echo "$TO_REPO $BRANCH is current."
      exit 0
  fi
  
  exit 1
}

function copy_test1_files {
  # Copy the files we want to test_1
  cp -p file.txt ../test_1/
  cp -p file1.txt ../test_1/
}

function commit_repo {
  # Switch to $TO_REPO repo and commit changes
  cd ../$TO_REPO
  echo $COMMIT > .commit
  git add -A
  git commit -m "Commit"
  git push
  
  # Switch back to original directory
  cd ../test
}

# Should first clone test repo

if is_current "test_1" "master"
  then
    echo "test_1 master is current"
else 
    echo "Updating test_1"
    copy_test1_files
    commit_repo "test_1"
fi

if is_current "test_1" "development"
  then
    echo "test_1 development is current"
else 
    echo "Updating test_1"
    copy_test1_files
    commit_repo "test_1"
fi

# Delete test repo
