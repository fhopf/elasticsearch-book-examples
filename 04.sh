# add another document
curl -XPUT "http://localhost:9200/conference/talk/2" -d'
{
    "title" : "Search Evolution – Von Lucene zu Solr und ElasticSearch",
    "speaker" : "Florian Hopf",
    "date" : "2013-04-04T09:00:00.000Z",
    "tags" : ["Java", "Lucene", "Solr", "Elasticsearch"],
    "conference" : {
        "name" : "BED-Con",
        "city" : "Berlin"
    } 
}'

# search with a bool query
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "tags": {
              "value": "Java"
            }
          }
        }
      ],
      "should": [
        {
          "term": {
            "tags": {
              "value": "Lucene"
            }
          }
        }
      ]
    }
  }
}'

# Standard OR search
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "match": {
      "title": {
        "query": "Lucene Solr Elasticsearch"
      }
    }
  }
}'

# All terms are mandatory
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "match": {
      "title": {
        "query": "Lucene Solr Elasticsearch",
        "operator": "and"
      }
    }
  }
}'

# 3 of 3 terms are mandatory
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "match": {
      "title": {
        "query": "Lucene Solr Elasticsearch",
        "minimum_should_match": "67%"
      }
    }
   }
  }
}'

# 2 of 3 terms are mandatory
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "match": {
      "title": {
        "query": "Lucene Solr Elasticsearch",
        "minimum_should_match": "66%"
      }
    }
   }
  }
}'

# Search on multiple fields
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "multi_match": {
      "query": "Lucene Solr Elasticsearch",
        "fields": ["title", "tags"],
        "type": "best_fields"
      }   
    }
  }
}'

# Match phrase
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "match_phrase": {
      "title": "Apache DB"
    }
  }
}'

# Match phrase prefix
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "match_phrase_prefix": {
      "title": "Apache Luc"
    }
  }
}'

# Boosting match query
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "bool": {
    "should": [
        {
          "match": {
              "title": {
                "query": "Lucene",
                "boost": 2
              }
          }
        },
        {
          "match": {
              "conference.city": "Berlin"
          }
        }
      ]
    }  
  }
}'

# Rescoring
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
   "query": {
      "match": {
         "title": "Elasticsearch"
      }
   },
   "rescore": {
      "window_size": 50,
      "query": {
         "rescore_query": {
            "match": {
               "title": {
                  "query": "Solr und Elasticsearch",
                  "type": "phrase"
               }
            }
         }
      }
   }
}'

# Function Score
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
   "query": {
      "function_score": {
         "query": {
            "bool": {
               "should": [
                  {
                     "match": {
                        "title": "Elasticsearch"
                     }
                  }
               ]
            }
         },
         "functions": [
            {
               "gauss": {
                  "date": {
                     "origin": "2015-01-01T23:00:00",
                     "scale": "360d"
                  }
               }
            }
         ]
      }
   }
}'

# Index docs with popularity
curl -XPUT "http://localhost:9200/conference/talk/2" -d'
{
    "title" : "Search Evolution – Von Lucene zu Solr und ElasticSearch",
    "speaker" : "Florian Hopf",
    "date" : "2013-04-04T09:00:00.000Z",
    "tags" : ["Java", "Lucene", "Solr", "Elasticsearch"],
    "conference" : {
        "name" : "BED-Con",
        "city" : "Berlin"
    },
    "popularity": 100
}'
curl -XPUT "http://localhost:9200/conference/talk/1" -d'
{
    "title" : "Anwendungsfälle für Elasticsearch",
    "speaker" : "Florian Hopf",
    "date" : "2014-07-17T15:35:00.000Z",
    "tags" : ["Java", "Lucene"],
    "conference" : {
        "name" : "Java Forum Stuttgart",
        "city" : "Stuttgart"
    },
    "popularity": 2
}'

# Search with script score
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "function_score": {
      "query": {
          "match": {
              "title": "Elasticsearch"
          }
      },
      "script_score": {
          "script": "_score * (doc[\"popularity\"].value + 1)",
          "lang": "expression"
      }
    }
  }
}'

# Explain scoring
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "match": {
      "title": "search"
    }
   },
   "explain": true
}'
