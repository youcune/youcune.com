#!/bin/bash

set -eux

cd $(dirname $0)
cd ..

BRANCH=${1:-master}

git fetch
git checkout $BRANCH
git merge --ff origin/$BRANCH

bundle exec middleman build
