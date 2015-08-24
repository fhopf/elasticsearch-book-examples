# install and start ES
wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.6.0.zip
unzip elasticsearch-1.6.0.zip
elasticsearch-1.6.0/bin/elasticsearch

# status 
curl -XGET "http://localhost:9200"

# index example
curl -XPOST "http://localhost:9200/example/doc" -d'
{
    "title": "Hallo Welt",
    "tags": ["example", "elasticsearch"]
}'

# search indexed documents
curl -XGET "http://localhost:9200/_search?q=welt"
