#!/bin/bash

set -e

trap 'echo ERROR: objects clean failed' ERR

while getopts u:f: opts; do
    case ${opts} in
        u) base_url=${OPTARG} ;;
    esac
done

if [ "x" == "x$base_url" ]; then
	base_url=http://kibana:5601
fi

echo getting objects from $base_url
objects_json=$(./kget.sh -u $base_url)
object_count=$(echo $objects_json | jq 'length')
echo got $object_count objects

objects=$(echo $objects_json | jq -r '.[] | @base64')
for row in $objects
do
	object=$(echo $row | base64 -d)
	object_type=$(echo $object | jq -r '.type')
	object_id=$(echo $object | jq -r '.id')
	object_id_encoded=$(echo $object | jq -r '.id | @uri')
   	curl --silent \
		--fail \
		-X DELETE \
		"$base_url/api/saved_objects/$object_type/$object_id_encoded" \
		-H 'kbn-xsrf: true' \
		> /dev/null
	echo $object_type \"$object_id\" was successfully deleted
done
