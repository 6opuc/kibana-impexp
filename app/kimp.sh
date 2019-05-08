#!/bin/bash

set -e

trap 'echo ERROR: objects import failed' ERR

while getopts u:f: opts; do
    case ${opts} in
        u) base_url=${OPTARG} ;;
        f) input_file_path=${OPTARG} ;;
    esac
done

if [ "x" == "x$base_url" ]; then
	base_url=http://kibana:5601
fi

if [ "x" == "x$input_file_path" ]; then
	input_file_path=./export.json
fi

./kwait.sh -u $base_url

echo importing objects from $input_file_path to $base_url
http_response=$(
	curl --silent \
		--fail \
		-X POST \
		"$base_url/api/saved_objects/_bulk_create?overwrite=true" \
		-H 'Expect:' \
		-H 'kbn-xsrf: true' \
		-H 'Content-Type: application/json' \
		-d @$input_file_path)

error_message=$(echo $http_response | jq -r '.error')
if [ "null" != "$error_message" ]; then
	echo ERROR: $error_message
	exit 1
fi

object_count=$(echo $http_response | jq '.saved_objects | length')
echo $object_count objects were imported successfully
