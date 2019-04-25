#!/bin/bash

set -e

while getopts u: opts; do
    case ${opts} in
        u) base_url=${OPTARG} ;;
    esac
done

if [ "x" == "x$base_url" ]; then
	base_url=http://kibana:5601
fi

curl --silent \
	-X GET \
	"$base_url/api/saved_objects/_find?per_page=1000&type=config&type=index-pattern&type=dashboard&type=visualization&type=search&fields=id&fields=type" \
	| jq '[.saved_objects[] | {type: .type, id: .id}]'
