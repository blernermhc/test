#!/bin/bash

function copy_changes {
  TO_REPO=$1
  BRANCH=$2
  
  echo TO_REPO = $TO_REPO
  echo BRANCH = $BRANCH
  
  # Make sure both repos are on master
  git checkout $BRANCH
  cd ../$TO_REPO
  git checkout $BRANCH
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
      exit
  fi

  # Copy the files we want to test_1
  cp -p file.txt ../$TO_REPO/
  cp -p file1.txt ../$TO_REPO/
  echo $COMMIT > ../$TO_REPO/.commit

  # Switch to $TO_REPO repo and commit changes
  cd ../$TO_REPO
  git add -A
  git commit -m "Commit"
  git push
  
  # Switch back to original directory
  cd ../test
}

copy_changes "test_1" "master"
copy_changes "test_2" "master"
copy_changes "test_1" "development"
copy_changes "test_2" "development"


