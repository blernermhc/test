#!/bin/bash

# Switch to master branch
git checkout master

# Get the latest commit number
COMMIT=$(git show | head -n 1)

# Compare to the commit # stored in test_1
COMMIT_1=$(cat ../test_1/.commit)

# If they are the same we are done
if [ $COMMIT == $COMMIT_1 ] 
  then
    echo "test_1 master is current."
    exit
fi


# Copy the files we want to test_1
cp -p file.txt ../test_1/
cp -p file1.txt ../test_1/
echo $COMMIT > ../test_1/commit

# Switch to test_1 repo and commit changes
git add -A
git commit -m "Commit"
git push
