#!/bin/sh
if [[ "$TRAVIS_BRANCH" == "master" ]]; then
  # Travis fetches a shallow clone. We use commit count until HEAD for build number. In order to assure that the count is correct we have to `unshallow` Travis' clone.
  git fetch --unshallow
  echo "$FABRIC_API_TOKEN" >> fabric.apikey
  echo "$FABRIC_BUILD_SECRET" >> fabric.buildsecret
  fastlane beta
  exit $?
fi
