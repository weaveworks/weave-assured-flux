#!/bin/bash
set -o errexit

# weave assured flux patches
# Version: v1.0.0
# Author: Soule BA <soule@weave.works>

function clone() {
    local repo=$1
    local dir=$2
    local tag=$3

    if [ ! -d "$dir" ]; then
        git clone -q --depth 1 -b "$tag" "$repo" "$dir"
    fi
}

function patch() {
    local file=$1

    # check that series file exists and has more than 2 lines
    lines=$(cat "$file" | wc -l)
    if [ "$lines" gt 2 ]; then
        stg init
        stg import -t --series file
        stg_version_output=$(stg --version | grep -i stacked | head -n 1)
        if [ "$stg_version_output" == "Stacked Git 2.2.2" ]; then
        	# for stg 2.2.2
        	SERIES=$(stg series --color never --all -P)
        	echo "$SERIES" | while read -r line; do
        	    cleaned_line=$(echo "$line" | sed -e 's/^[0-9]*-//')
        	    stg rename $line $cleaned_line
        	done
        fi
    fi
}

pushd . >/dev/null

git clone $1 $2 $3
cd $2
patch ../patches-flux/$2/series

popd >/dev/null