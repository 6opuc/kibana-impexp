#!/bin/bash

set -e

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

object_count=$(curl --silent \
	-X POST \
	"$base_url/api/saved_objects/_bulk_create?overwrite=true" \
	-H 'Expect:' \
	-H 'kbn-xsrf: true' \
	-H 'Content-Type: application/json' \
	-d @$input_file_path \
	| jq '.saved_objects | length')

echo $object_count objects were imported successfully from $input_file_path
