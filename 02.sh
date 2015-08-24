# Index a document
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

# Retrieve a document by id
curl -XGET "http://localhost:9200/conference/talk/1"

# Search documents using a query string
curl -XGET "http://localhost:9200/conference/talk/_search?q=Elasticsearch"

# Search documents in a certain field
curl -XGET "http://localhost:9200/conference/talk/_search?q=title:elasticsearch"

# Search documents using the query DSL
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "query_string": {
           "query": "Elasticsearch"
        }
    }
}'

# Search documents in a certain field using the query DSL
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "query_string": {
      "query": "title:Elasticsearch"
    }
  }
}'

# Match query
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "match": {
           "title": "Elasticsearch"
        }
    }
}'

# Multi match query
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "multi_match": {
           "query": "Elasticsearch",
           "fields": ["title", "tags"]
        }    
    }
}'

# Term query
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "term": {
           "tags": {
              "value": "java"
           }
        }
    }
}'

# Filtered query
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "filtered": {
           "filter": {
               "term": {
                  "tags": "java"
               }
           }
        }
    }
}'

# get mapping
curl -XGET "http://localhost:9200/conference/talk/_mapping"

# delete index
curl -XDELETE "http://localhost:9200/conference"

# create index
curl -XPUT "http://localhost:9200/conference"

# put mapping
curl -XPUT "http://localhost:9200/conference/talk/_mapping" -d'
{
    "talk" : {
        "properties" : {
            "tags" : {"type": "string", "index": "not_analyzed"}
        }
    }
}'

# range filter
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "filter": {
        "range": {
           "date": {
              "to": "now"
           }
        }    
    }
}'

# page size
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "size": 5
}'

# page size and start
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "size": 5,
    "from": 5
}'

# sort by field
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "sort": "date"
}'

# specify order
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "sort": [
        { "date": {"order": "desc"}}
    ]
}'

# sort by multiple fields
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "sort": [
        { "date": {"order": "desc"}},
        "title"
    ]
}'

# build facet via terms aggregation
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "aggs":
    {
        "tags_facet": {
            "terms": { 
                "field": "tags"
            }
        }
    }
}'

# source filtering
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "_source": ["title", "conference.*"]
}'

# search with search template
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "template": {
            "query": {
                    "match" : { "title": "{{title}}" }
            },
            "params" : {
                "title" : "Elasticsearch"
            }
        }
    }
}'

# register search template
curl -XPUT "http://localhost:9200/_search/template/by-title" -d'
{
    "template": {
        "query": {
            "match": {
                "title": "{{title}}"
            }
        }
    }
}'

# use registered search template
curl -XPOST "http://localhost:9200/conference/_search/template" -d'
{
    "template": {
        "id": "by-title" 
    },
    "params": {
        "title": "Elasticsearch"
    }
}'

