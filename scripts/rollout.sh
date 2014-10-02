#!/bin/bash

set -eux

cd $(dirname $0)
cd ..

git fetch
git checkout ${1:-master}

bundle exec middleman build
