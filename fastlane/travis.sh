#!/bin/sh
if [[ "$TRAVIS_BRANCH" == "master" ]]; then
  # Travis fetches a shallow clone. We use commit count until HEAD for build number. In order to assure that the count is correct we have to `unshallow` Travis' clone.
  git fetch --unshallow

  fastlane beta
  exit $?
fi
