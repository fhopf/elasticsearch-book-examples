# Adjust log level
curl -XPUT "http://localhost:9200/_cluster/settings" -d'
{
    "transient" : {
        "logger.discovery" : "DEBUG"
    }
}'

# delete index
curl -XDELETE "http://localhost:9200/conference/"

# create index
curl -XPOST "http://localhost:9200/conference/"

# Mapping options
curl -XPUT "http://localhost:9200/conference/talk/_mapping" -d'
{
   "talk": {
      "_all": {
         "enabled": false
      },
      "_source": {
         "enabled": false
      },
      "properties": {
         "speaker": {
            "type": "string",
             "norms": {
                "enabled": false
             }            
         },
         "title": {
            "type": "string", 
            "store": "yes" 
         }         
      }
   }
}'

# index a doc
curl -XPUT "http://localhost:9200/conference/talk/1" -d'
{
    "title" : "Anwendungsfälle für Elasticsearch",
    "speaker" : "Florian Hopf",
    "date" : "2014-07-17T15:35:00.000Z",
    "tags" : ["Java", "Lucene"],
    "conference" : {
        "name" : "Java Forum Stuttgart",
        "city" : "Stuttgart"
    } 
}'

# search doc and retrieve stored title
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "fields": ["title"]
}'

# Cache info
curl -XGET "http://localhost:9200/conference/_stats/filter_cache,query_cache?pretty"

# Disable filter cache for query
curl -XPOST "http://localhost:9200/conference/_search" -d'
{
   "query": {
      "filtered": {
         "filter": {
            "term": {
               "title": "Elasticsearch",
               "_cache": false
            }
         }
      }
   }
}'

# Close index
curl -XPOST "http://localhost:9200/conference/_close"

# Adjust filter cache settings
curl -XPUT "http://localhost:9200/conference/_settings" -d'
{
    "index": {
        "cache.filter.max_size": "2gb"    
    }
}'

# Open index
curl -XPOST "http://localhost:9200/conference/_open"

# Activate shard query cache
curl -XPUT "http://localhost:9200/conference/_settings" -d'
{
    "index": {
        "cache.query.enable": true    
    }
}'

# Nodes info
curl -XGET "http://localhost:9200/_nodes/?pretty"

# Nodes stats
curl -XGET "http://localhost:9200/_nodes/stats?pretty"

# Hot Threads
curl -XGET "http://localhost:9200/_nodes/hot_threads"

# Cat indices
curl -XGET "http://localhost:9200/_cat/indices?v"

# Cat health
curl -XGET "http://localhost:9200/_cat/health?v"

# Cat nodes
curl -XGET "http://localhost:9200/_cat/nodes?v"

# Cat shards
curl -XGET "http://localhost:9200/_cat/shards?v"

# Create snapshot repository
curl -XPUT "http://localhost:9200/_snapshot/fs_backup" -d'
{
    "type": "fs",
    "settings": {
        "location": "/opt/es-backup/snapshot",
        "compress": true
    }
}'

# Verify snapshot
curl -XPOST "http://localhost:9200/_snapshot/fs_backup/_verify"

# Create a snapshot of all indices
curl -XPUT "http://localhost:9200/_snapshot/fs_backup/1?wait_for_completion=true"

# Restore indices
curl -XPOST "localhost:9200/_snapshot/fs_backup/1/_restore"




