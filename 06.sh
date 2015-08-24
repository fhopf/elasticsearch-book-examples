# Retrieve index settings
curl -XGET "http://localhost:9200/conference/_settings?pretty"

# Create index with single shard
curl -XPUT "http://localhost:9200/single_shard_index/" -d'
{
   "settings": {
     "number_of_shards": 1
   } 
}'

# Adjust number of replicas
curl -XPUT "http://localhost:9200/single_shard_index/_settings" -d'
{
   "settings": {
     "number_of_replicas": 2
   } 
}'

# Install Kopf (this is an older version)
bin/plugin --install lmenezes/elasticsearch-kopf/1.2

# Adjust number of replicas
curl -XPUT "http://localhost:9200/conference/_settings" -d'
{
    "settings": {
        "number_of_replicas": 2
    }
}'

# Reset number of replicas
curl -XPUT "http://localhost:9200/conference/_settings" -d'
{
    "settings": {
        "number_of_replicas": 1
    }
}'

# Wait for cluster health yellow
curl -XGET 'http://localhost:9200/_cluster/health?wait_for_status=yellow&timeout=60s'

# Show current recovery
curl -XGET "http://localhost:9200/_recovery?pretty=true"

# Add tag to index setting
curl -XPUT "http://localhost:9200/conference/_settings" -d'
{
    "index.routing.allocation.include.tag" : "strong-machine"
}'

# Prefer local shards
curl -XGET "http://localhost:9200/conference/talk/_search?q=elasticsearch&preference=_local"

# Add document with routing
curl -XPOST "http://localhost:9200/conference/talk/1?routing=Karlsruhe" -d'
{
    "title": "Search-Driven Applications",
    "conference": {
        "name": "Entwicklertag",
        "city": "Karlsruhe"
    }
}'

# Search with routing
curl -XPOST "http://localhost:9200/conference/talk/_search?routing=Karlsruhe" -d'
{
    "query": {
        "filtered": {
           "query": {
            "match": {
                "title": "search"
            }
           },
           "filter": {
               "term": {
                  "conference.city": "karlsruhe"
               }
           }
        }
    }
}'

# Retrieve cluster state
curl -XGET "http://localhost:9200/_cluster/state?pretty"

# Update minimum master nodes
curl -XPUT "http://localhost:9200/_cluster/settings" -d'
{
   "persistent": {
      "discovery.zen.minimum_master_nodes": 3
   }
}'

# Index with consistency setting
curl -XPOST "http://localhost:9200/conference2/talk?consistency=one" -d'
{
    "title": "What to do when there are not enough shards"
}'
