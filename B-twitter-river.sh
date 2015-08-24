# Install the plugin
bin/plugin -install elasticsearch/elasticsearch-river-twitter/2.6.0

# Configure the river
curl -XPUT "http://localhost:9200/_river/twitter-river/_meta" -d'
{
    "type" : "twitter",
    "twitter" : {
        "oauth" : {
            "consumer_key" : "...",
            "consumer_secret" : "...",
            "access_token" : "...",
            "access_token_secret" : "..."
        }
    }
}'

# Count current tweet documents
curl -XGET "http://localhost:9200/twitter-river/status/_count"

# Delete the river
curl -XDELETE "http://localhost:9200/_river/twitter-river/"

