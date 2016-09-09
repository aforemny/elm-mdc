# Run elm package diff
# Input parameters:
#   First argument: The current branch (reported as $TRAVIS_BRANCH on Travis CI environment variables)
#   Second argument: string to verify as the major version branch
#   Third argument: Input should be Travis CI environment variable ($TRAVIS_PULL_REQUEST). The pull request number if the current job is a pull request, “false” if it’s not a pull request.

# Usage for local testing: check_pr_branch my_branch_name master false
# Usage for use in Travis CI: check_pr_branch $TRAVIS_BRANCH master $TRAVIS_PULL_REQUEST

current_branch=$1
major_version_branch=$2
travis_pull_request=$3


if [ $travis_pull_request == "false" ]; then
  # Not a pull request - Allowed. Don't need to run package diff
  echo "Verified that this is not a pull request. Will not check elm-package diff."
else
  # Is a pull request - need to check elm-package diff
  string=$(elm package diff)
  if [[ $? != 0 ]]; then
      echo "Command failed."
      exit -1
  elif [[ $string == *"This is a MINOR change."* ]]; then
      # Pull request and MINOR change - Allowed
      echo "Current_branch reported by Travis CI: "$current_branch
      echo "Branch set to master branch: "$major_version_branch
      echo "Allowed. Pull request, but MINOR change."
  else
      # Pull request and MAJOR change. Need to check if the branch reported by Travis is equal to the "official" master branch
      echo "Current_branch reported by Travis CI: "$current_branch
      echo "Branch set to master branch: "$major_version_branch
      # Check if current branch is other than master
      if [ $current_branch == $major_version_branch ]; then
        echo "Allowed. This is a Major change into the major versjon branch"
        exit 0
      else
        echo "Denied. This is a Major change into a minor versjon branch"
        exit 1
      fi
  fi
fi
