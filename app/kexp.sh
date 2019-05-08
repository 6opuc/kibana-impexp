#!/bin/bash

set -e

trap 'echo ERROR: objects export failed' ERR

while getopts u:f: opts; do
    case ${opts} in
        u) base_url=${OPTARG} ;;
        f) output_file_path=${OPTARG} ;;
    esac
done

if [ "x" == "x$base_url" ]; then
	base_url=http://kibana:5601
fi

if [ "x" == "x$output_file_path" ]; then
	output_file_path=./export.json
fi

echo getting objects from $base_url
objects_json=$(./kget.sh -u $base_url)
object_count=$(echo $objects_json | jq 'length')
echo got $object_count objects

echo exporting $object_count objects from $base_url to $output_file_path
http_response=$(
	curl --silent \
		--fail \
		-X POST \
		"$base_url/api/saved_objects/_bulk_get" \
		-H 'Expect:' \
		-H 'kbn-xsrf: true' \
		-H 'Content-Type: application/json' \
		-d"$objects_json")
error_message=$(echo $http_response | jq -r '.error')
if [ "null" != "$error_message" ]; then
	echo ERROR: $error_message
	exit 1
fi

echo $http_response \
	| jq '[.saved_objects[] | {type: .type, id: .id, attributes: .attributes, version: .version}]' \
	> $output_file_path

object_count=$(cat $output_file_path | jq 'length')
echo $object_count objects were exported successfully to $output_file_path
