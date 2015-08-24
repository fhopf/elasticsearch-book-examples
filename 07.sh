# Add an alias
curl -XPOST "http://localhost:9200/_aliases" -d'
{
    "actions" : [
        { 
            "add" : { 
                "index" : "conference", 
                "alias" : "konferenz" 
            } 
        }
    ]
}'

# Search alias
curl -XGET "http://localhost:9200/konferenz/_search"

# Remove
curl -XPOST "http://localhost:9200/_aliases" -d'
{
    "actions" : [
        { 
            "remove" : { 
                "index" : "conference", 
                "alias" : "konferenz" 
            } 
        }
    ]
}'

# Add filtered alias
curl -XPOST "http://localhost:9200/_aliases" -d'
{
    "actions" : [
        {
            "add" : {
                 "index" : "conference",
                 "alias" : "java",
                 "filter" : { "term" : { "tags" : "Java" } }
            }
        }
    ]
}'

# Search filtered alias
curl -XGET "http://localhost:9200/java/_search"

# Add index template
curl -XPUT "http://localhost:9200/_template/conference-template" -d'
{
    "template" : "conference-*",
    "settings" : {
        "number_of_shards" : 2
    }
}'

# Create index
curl -XPOST "http://localhost:9200/conference-240815"

# See index settings
curl -XGET "http://localhost:9200/conference-240815/_settings"

# put mapping
curl -XPUT "http://localhost:9200/conference-240815/talk/_mapping" -d'
{
    "talk" : {
        "properties" : {
            "date": {
                "type": "date",
                "format": "dd.MM.YYYY HH:mm"
            }
        }
    }
}'

# index a document with new format
curl -XPUT "http://localhost:9200/conference-240815/talk/1" -d'
{
    "title": "Anwendungsfälle für Elasticsearch",
    "date": "17.07.2014 15:35"
}'

# Update mapping with geodata
curl -XPUT "http://localhost:9200/conference-240815/talk/_mapping" -d'
{
    "talk" : {
        "properties" : {
            "conference": {
                "properties": {
                    "location": {
                        "type": "geo_point"    
                    }
                }    
            }
        }
    }
}'

# index a document with geo point
curl -XPUT "http://localhost:9200/conference-240815/talk/1" -d'
{
    "title": "Anwendungsfälle für Elasticsearch",
    "date": "17.07.2014 15:35",
    "conference": {
      "name": "Java Forum Stuttgart",
      "city": "Stuttgart",
      "location": {
         "lon": "9.170045",
         "lat": "48.779506"
      }
    }    
}'

# sort by distance
curl -XPOST "http://localhost:9200/conference-240815/talk/_search" -d'
{    
    "sort" : [
        {
            "_geo_distance" : {
                "conference.location" : {
                    "lon": 8.403697,
                    "lat": 49.006616
                },
                "order" : "asc",
                "unit" : "km"
            }
        }
    ]
}'

# filter by distance
curl -XPOST "http://localhost:9200/conference-240815/talk/_search" -d'
{
    "query": {
        "filtered": {
         "filter": {
            "geo_distance": {
               "conference.location": {
                  "lon": 8.403697,
                  "lat": 49.006616
               },
               "distance": "200km"
            }
         }
       }
    }
}'

# enable strict mapping
curl -XPUT "http://localhost:9200/conference/talk/_mapping" -d'
{
    "talk": {
        "dynamic": "strict"    
    }
}'

# Indexing a document with wrong title doesn't work now
curl -XPOST "http://localhost:9200/conference/talk?pretty" -d'
{
    "titel": "Falsch"
}'

# Add a talk with multiple speakers
curl -XPOST "http://localhost:9200/conference-relation/talk" -d'
{
    "title": "Search-Driven Applications",
    "speaker": [
        {
            "name": "Florian Hopf",
            "twitter": "@fhopf"
        },
        {
            "name": "Tobias Kraft",
            "twitter": "@tokraft"
        }
    ]
}'

# See mapping 
curl -XGET "http://localhost:9200/conference-relation/talk/_mapping?pretty"

# querying a speaker
curl -XPOST "http://localhost:9200/conference-relation/talk/_search" -d'
{
    "query": {
        "match": {
           "speaker.name": "Florian Hopf"
        }
    }
}'

# mixing two speaker names
curl -XPOST "http://localhost:9200/conference-relation/talk/_search" -d'
{
    "query": {
        "match": {
            "speaker.name": {
                "query": "Florian Kraft",    
                "operator": "and"
            }
        }
    }
}'

# delete the index
curl -XDELETE "http://localhost:9200/conference-relation/"

# add index
curl -XPOST "http://localhost:9200/conference-relation/"

# add mapping
curl -XPUT "http://localhost:9200/conference-relation/talk/_mapping" -d'
{
    "talk" : {
        "properties" : {
            "speaker" : {
                "type" : "nested"
            }
        }
    }
}'

# Index multiple speakers
curl -XPOST "http://localhost:9200/conference-relation/talk" -d'
{
    "title": "Search-Driven Applications",
    "speaker": [
        {
            "name": "Florian Hopf",
            "twitter": "@fhopf"
        },
        {
            "name": "Tobias Kraft",
            "twitter": "@tokraft"
        }
    ]
}'

# Query with nested query
curl -XPOST "http://localhost:9200/conference-relation/talk/_search" -d'
{
   "query": {
      "nested": {
         "path": "speaker",
         "query": {
            "match": {
               "speaker.name": {
                  "query": "Florian Hopf",
                  "operator": "and"
               }
            }
         }
      }
   }
}'

# No result for mixed names
curl -XPOST "http://localhost:9200/conference-relation/talk/_search" -d'
{
   "query": {
      "nested": {
         "path": "speaker",
         "query": {
            "match": {
               "speaker.name": {
                  "query": "Florian Kraft",
                  "operator": "and"
               }
            }
         }
      }
   }
}'

# delete the index
curl -XDELETE "http://localhost:9200/conference/"

# add index
curl -XPOST "http://localhost:9200/conference/"

# add mapping
curl -XPUT "http://localhost:9200/conference/talk/_mapping" -d'
{
    "talk": {
        "properties": {
            "title": {"type": "string"}
        }    
    }
}'

# index a talk
curl -XPOST "http://localhost:9200/conference/talk/1" -d'
{
    "title": "Search-Driven Applications"
}'

# add speaker type
curl -XPUT "http://localhost:9200/conference/speaker/_mapping" -d'
{
    "speaker": {
        "_parent": {
            "type": "talk"    
        },
        "properties": {
            "name": {"type": "string"},
            "twitter": {"type": "string"}
        }    
    }
}'

# indexing a speaker with missing parent doesn't work
curl -XPOST "http://localhost:9200/conference/speaker/" -d'
{
    "name": "Florian Hopf",
    "twitter": "@fhopf"
    
}'

# index a speaker with parent talk
curl -XPOST "http://localhost:9200/conference/speaker/?parent=1" -d'
{
    "name": "Florian Hopf",
    "twitter": "@fhopf"
    
}'


