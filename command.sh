#!/bin/bash
# REPO_URL https://github.com/Mattimatt7/my-app
#
# Commands used for steps 1-8.

# 1. Create the React app with create-react-app
npx create-react-app my-app
cd my-app

# 2. Commit the code
# create-react-app already initializes git and makes the first commit
# ("Initialize project using Create React App"), so the tree was clean.
git status

# 2. Create the GitHub repo (public)
# `gh repo create my-app --public --source=. --remote=origin --push` is blocked in
# this environment (it uses the GraphQL API), so the empty public repo
# "my-app" was created in the GitHub web UI instead, then connected and pushed:
git remote add origin https://github.com/Mattimatt7/my-app.git
git push -u origin master

# 3. Switch to a new branch "update_logo"
git checkout -b update_logo

# 4. Replace the existing logo with the Propeller footer-logo.svg
cp footer-logo.svg src/logo.svg

# 5. Replace the existing link
sed -i 's#href="https://reactjs.org"#href="https://www.propelleraero.com/dirtmate/"#' src/App.js

# 6. Commit, then push the code
git add -A
git commit -m "Replace logo and link"
git push -u origin update_logo

# 7. Create PR from "update_logo" to "master" with the GitHub CLI (REST API,
#    because `gh pr create` needs the blocked GraphQL API)
gh api repos/Mattimatt7/my-app/pulls -X POST \
  -f title="Update logo and link" -f head=update_logo -f base=master \
  -f body="Replace the default React logo with the Propeller logo and point the link to https://www.propelleraero.com/dirtmate/"

# 8. Merge the PR with the GitHub CLI (REST API, no approval step)
gh api repos/Mattimatt7/my-app/pulls/1/merge -X PUT -f merge_method=merge
