#!/bin/bash

scriptPath="$(realpath -s "${BASH_SOURCE[0]}")"
scriptDir="$(dirname "$scriptPath")"
cd "$scriptDir"

source "./_bash_config.sh"

run() {
	# Dependencies beforehand

	# We usually don't want to redownload boost.
	# Use ./clear_local_all.sh manually instead if necessary.
	if [[ ! -d "$noarchTmp/boost" ]]; then
		./_regenerate_local_Multiarch.sh
	else
		./_regenerate-soft_local_Multiarch.sh
	fi
}

run_bash run $@

