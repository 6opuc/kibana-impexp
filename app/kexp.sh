#!/bin/bash

set -e

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

json=$(./kget.sh -u $base_url)

curl --silent \
	-X POST \
	"$base_url/api/saved_objects/_bulk_get" \
	-H 'Expect:' \
	-H 'kbn-xsrf: true' \
	-H 'Content-Type: application/json' \
	-d"$json" \
	| jq '[.saved_objects[] | {type: .type, id: .id, attributes: .attributes, version: .version}]' \
	> $output_file_path

object_count=$(cat $output_file_path | jq 'length')
echo $object_count objects were exported successfully to $output_file_path
