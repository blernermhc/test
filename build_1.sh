#!/bin/bash

function is_current {
  TO_REPO=$1
  BRANCH=$2
  
  echo TO_REPO = $TO_REPO
  echo BRANCH = $BRANCH
  
  # Make sure both repos are on master
  if [ ! $(git checkout $BRANCH) ]
    then
      echo "Can't switch to $BRANCH of test repo"
      exit 1
  fi
  cd ../$TO_REPO
  if [ ! $(git checkout $BRANCH) ]
    then
      echo "Can't switch to $BRANCH of $TO_REPO"
      exit 1
  fi
  cd ../test

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
  echo $COMMIT > ../$TO_REPO/.commit
}

function commit_repo {
  # Switch to $TO_REPO repo and commit changes
  cd ../$TO_REPO
  git add -A
  git commit -m "Commit"
  git push
  
  # Switch back to original directory
  cd ../test
}

if is_current "test_1" "master"
  then
    echo "test_1 master is current"
else 
    echo "test_1 master needs to update"
fi

#copy_changes "test_1" "master"
#copy_changes "test_2" "master"
#copy_changes "test_1" "development"
#copy_changes "test_2" "development"


