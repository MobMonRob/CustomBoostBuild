#!/bin/bash

scriptPath="$(realpath -s "${BASH_SOURCE[0]}")"
scriptDir="$(dirname "$scriptPath")"
cd "$scriptDir"

source "./_bash_config.sh"


run() {
	local -r boostRepoRoot="$currentTmp/boost"
	local -r targetIncludeDir="$currentTarget/include/boost"

	## Naive copying is not sufficient - unclear why some files are missing in that case.
	## Workaround:
	rm -rdf "$targetIncludeDir"
	mkdir -p "$targetIncludeDir"
	includes_rekursive "$boostRepoRoot/libs"
}


includes_rekursive()
{
	local folder="$1"

	if [[ ! -e  "$folder" ]]; then
		return
	fi

	local folderPath=$(find "$folder" -maxdepth 1 -mindepth 1 -type d)

	for subFolderPath in $folderPath; do
		local subFolderName=$(basename $subFolderPath)
		local oldIncludeDir="$subFolderPath/include/boost/"

		if [[ -e  "$oldIncludeDir" ]]; then
			echo "$oldIncludeDir"
			cp -r -L -l "$oldIncludeDir"/* "$targetIncludeDir"
			#echo "fi" &>/dev/null
		fi

		includes_rekursive "$subFolderPath"
	done
}

run_bash run $@

