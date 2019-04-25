# kibana-impexp
Import and export scripts for Kibana

## Examples

### Export all saved objects from kibana to file
```bash
docker run \
	--rm \
	-it \
	-v /tmp:/tmp \
	--network=host \
	6opuc/kibana-impexp \
	./kexp.sh -u http://127.0.0.1:5601 -f /tmp/export.json
```

### Delete all saved objects from Kibana
```bash
docker run \
	--rm \
	-it \
	--network=host \
	6opuc/kibana-impexp \
	./kclean.sh -u http://127.0.0.1:5601
```

### Import all saved objects from file to Kibana
```bash
docker run \
	--rm \
	-it \
	-v /tmp:/tmp \
	--network=host \
	6opuc/kibana-impexp \
	./kimp.sh -u http://127.0.0.1:5601 -f /tmp/export.json
```
