#!/bin/sh

#  swiftlint.sh

GIT_ROOT_DIRECTORY=$(git rev-parse --show-toplevel)

cd "${GIT_ROOT_DIRECTORY}/"

if [ "${LINTTYPE}" = "FAST" ]; then
    # run swiftlint with configuration file
    # only linting files that are checked out (both staged and unstaged)
    count=0
    # only lint files that are local (both staged and unstaged)
    git diff HEAD --name-only | ( while read filename; do
        # only lint if file ends with .swift
        if [[ "${filename##*.}" == "swift" ]] && [[ -f "$GIT_ROOT_DIRECTORY/$filename" ]]; then
            export SCRIPT_INPUT_FILE_$count="$GIT_ROOT_DIRECTORY/$filename"
            ((count++))
        fi
    done
    export SCRIPT_INPUT_FILE_COUNT=$count
    if [ $count -gt 0 ]; then
        ./Pods/SwiftLint/swiftlint lint --strict --use-script-input-files --config swiftlint.yml
    fi )
else
    # linting all files in the directory
    ./Pods/SwiftLint/swiftlint lint --strict --config swiftlint.yml
fi
