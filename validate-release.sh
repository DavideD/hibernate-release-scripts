#!/usr/bin/env bash

PROJECT=$1
RELEASE_VERSION=$2
WORKSPACE=${WORKSPACE:-'.'}
CHANGELOG=$WORKSPACE/changelog.txt
README=$WORKSPACE/README.md

pushd ${WORKSPACE}

if [ -z "$PROJECT" ]; then
	echo "ERROR: Project not supplied"
	exit 1
fi
if [ -z "$RELEASE_VERSION" ]; then
	echo "ERROR: Release version argument not supplied"
	exit 1
fi

git fetch --tags

if [ `git tag -l | grep $RELEASE_VERSION` ]
then
	echo "ERROR: tag '$RELEASE_VERSION' already exists, aborting. If you really want to release this version, delete the tag in the workspace first."
	exit 1
else
	echo "SUCCESS: tag '$RELEASE_VERSION' does not exist"
fi

# Only check README updates if it's actually possible that it contains things to update
if grep -Eq "^\*?Version: .*\*?$|<version>" $README
then
	if grep -q "$RELEASE_VERSION" $README
	then
		echo "SUCCESS: $README looks updated"
	else
		echo "ERROR: $README has not been updated"
		exit 1
	fi
fi

if grep -q "$RELEASE_VERSION" $CHANGELOG ;
then
	echo "SUCCESS: $CHANGELOG looks updated"
else
	echo "ERROR: $CHANGELOG has not been updated"
	exit 1
fi

popd
