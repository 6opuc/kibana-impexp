#!/bin/bash

while getopts u: opts; do
    case ${opts} in
        u) base_url=${OPTARG} ;;
    esac
done

if [ "x" == "x$base_url" ]; then
	base_url=http://kibana:5601
fi

while true
do
	http_response=$(
		curl \
	   		--silent \
			--fail \
			-X GET \
			"$base_url/api/status")

	if [ "0" == "$(echo $?)" ]; then
		status=$(echo $http_response | jq -r '.status.overall.state')
		if [ "green" == "$status" ]; then
			break
		fi
	fi
	
	echo waiting for kibana initialization...
	sleep 1s
done

exit 0
