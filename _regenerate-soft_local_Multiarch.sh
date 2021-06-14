#!/bin/bash

scriptPath="$(realpath -s "${BASH_SOURCE[0]}")"
scriptDir="$(dirname "$scriptPath")"
cd "$scriptDir"

source "./_bash_config.sh"

run() {
	bash "./setup_$currentPlatform.sh"

	if [[ ! -d "$currentTarget/include/boost" ]]; then
		./generate-full-include-dir_Multiarch.sh
	else
		echo "Info: skipped ./generate-full-include-dir_Multiarch.sh because $currentTarget/include/boost already exists."
	fi

	if [[ "$currentPlatform" == "$platformWindows" ]]; then
		./copy-mingW-deps_Windows64.sh
	fi

	setSuccessToken
}

run_bash run $@

