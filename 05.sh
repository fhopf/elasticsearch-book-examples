# Index single doc
curl -XPUT "http://localhost:9200/example/doc/1" -d'
{
    "title": "Elasticsearch"
}'

# Retrieve doc
curl -XGET "http://localhost:9200/example/doc/1"

# Update doc
curl -XPUT "http://localhost:9200/example/doc/1" -d'
{
    "title": "The New Elasticsearch"
}'

# Retrieve doc
curl -XGET "http://localhost:9200/example/doc/1"

# Updating old version fails
curl -XPUT "http://localhost:9200/example/doc/1?version=1" -d'
{
    "title": "The Old Elasticsearch"
}'

# Creating on an existing document fails
curl -XPUT "http://localhost:9200/example/doc/1?op_type=create" -d'
{
    "title": "Not Elasticsearch"
}'

# Bulk index
curl -XPOST "http://localhost:9200/_bulk" -d'
{"create": {"_index": "example", "_type": "talk", "_id": 1}}
{"title": "Anwendungsfälle für Elasticsearch"}
{"index": {"_index": "example", "_type": "doc", "_id": 2}}
{"title": "Create or Update"}
{"update": {"_index": "example", "_type": "doc", "_id": 1}}
{"doc": {"conference": {"name": "Java Forum"}}}
'

# JDBC Importer to come

# Attachement plugin to come
