#!/bin/bash

scriptPath="$(realpath -s "${BASH_SOURCE[0]}")"
scriptDir="$(dirname "$scriptPath")"
cd "$scriptDir"

source "./_bash_config.sh"

run() {
	if [[ ! -d "$noarchTmp/boost" ]]; then
		# Dependencies here

		./_regenerate_local_Multiarch.sh

	elif [[ "$(isSuccessTokenSet)" == "false" ]]; then
		./_regenerate-soft_local_Multiarch.sh
	fi
}

run_bash run $@

