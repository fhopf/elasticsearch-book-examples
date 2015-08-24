# Analyze text without indexing
curl -XPOST "http://localhost:9200/_analyze?tokenizer=standard&token_filters=lowercase&pretty" -d "Anwendungsfälle für Elasticsearch"

# Analyze text for a field
curl -XPOST "http://localhost:9200/conference/_analyze?field=title&pretty" -d "Anwendungsfälle für Elasticsearch"

# Delete the index
curl -XDELETE "http://localhost:9200/conference"

# Add the index
curl -XPUT "http://localhost:9200/conference"

# Add new mapping
curl -XPUT "http://localhost:9200/conference/talk/_mapping " -d'
{
    "talk" : {
        "properties" : {
            "title" : {"type" : "string", "analyzer" : "german"},
            "tags" : {"type": "string", "index": "not_analyzed"}
        }
    }
}'

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

# Search for stemmed term
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "match": {
           "title": "Anwendungsfall"
        }
    }
}'

# Search using wildcard
curl -XPOST "http://localhost:9200/conference/_search" -d'
{
    "query": {
        "query_string": {
           "default_field": "title",
           "query": "anwendung*"
        }
    }
}'

# Search using prefix query
curl -XPOST "http://localhost:9200/conference/_search" -d'
{
    "query": {
        "prefix": {
           "title": "anwendung"
        }
    }
}'

# Delete the index
curl -XDELETE "http://localhost:9200/conference"

# Add tokenizers to index
curl -XPOST "http://localhost:9200/conference/" -d'
{
   "settings": {
      "analysis": {
        "tokenizer": {
            "prefix_tokenizer": {
               "type": "edgeNGram",
               "min_gram": "4",
               "max_gram": "9",
               "token_chars": [
                  "letter",
                  "digit"
               ]
            }
         },
         "analyzer": {
            "prefix_analyzer": {
               "tokenizer": "prefix_tokenizer",
               "filter": [
                  "lowercase"
               ]
            }
         }
       }
   }
}'

# Add new mapping
curl -XPUT "http://localhost:9200/conference/talk/_mapping " -d'
{
    "talk" : {
        "properties" : {
             "title": {
                "type": "string",
                "analyzer": "german",
                "fields": {
                    "prefix": {
                        "type": "string", 
                        "index_analyzer": "prefix_analyzer",
                        "search_analyzer": "standard"
                    }    
                }
             },
             "tags" : {"type": "string", "index": "not_analyzed"}
        }
    }
}'

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

# Search for stemmed term
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "match": {
           "title": "Anwendungsfall"
        }
    }
}'

# Search for ngram
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "match": {
           "title.prefix": "anwendung"
        }
    }
}'

# Delete the index
curl -XDELETE "http://localhost:9200/conference"

# Add tokenizers to index
curl -XPOST "http://localhost:9200/conference/" -d'
{
   "settings": {
      "analysis": {
        "tokenizer": {
            "prefix_tokenizer": {
               "type": "edgeNGram",
               "min_gram": "4",
               "max_gram": "9",
               "token_chars": [
                  "letter",
                  "digit"
               ]
            }
         },
         "analyzer": {
            "prefix_analyzer": {
               "tokenizer": "prefix_tokenizer",
               "filter": [
                  "lowercase"
               ]
            }
         }
       }
   }
}'

# Add mapping with copy fields
curl -XPUT "http://localhost:9200/conference/talk/_mapping" -d'
{
    "talk" : {
        "properties" : {
            "title" : {
                "type" : "string", 
                "analyzer" : "german", 
                "copy_to": "prefix"
            },
            "tags" : {
                "type": "string", 
                "analyzer": "german", 
                "copy_to": "prefix"
            },
            "prefix" : {
                "type": "string", 
                "index_analyzer": "prefix_analyzer", 
                "search_analyzer": "standard"
            }
        }
    }
}'

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

# Search for stemmed term
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "match": {
           "title": "Anwendungsfall"
        }
    }
}'

# Search for ngram
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "match": {
           "prefix": "anwendung"
        }
    }
}'

# Correct typos with fuzzy query
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
  "query": {
    "match": {
      "title": {
        "query": "elasticsaerch",
        "fuzziness": "2"
      }
    }
  }
}'

# Delete the index
curl -XDELETE "http://localhost:9200/conference"

# Create the index
curl -XPUT "http://localhost:9200/conference"

# Add multilang mapping
curl -XPUT "http://localhost:9200/conference/talk/_mapping" -d'
{
    "talk" : {
      "properties": {
         "title_de": {
            "type": "string",
            "analyzer": "german"
         },
         "title_en": {
            "type": "string",
            "analyzer": "english"
         }
      }
    }
}'

# Index a german doc
curl -XPUT "http://localhost:9200/conference/talk/1" -d'
{
    "title_de" : "Anwendungsfälle für Elasticsearch",
    "speaker" : "Florian Hopf",
    "date" : "2014-07-17T15:35:00.000Z",
    "tags" : ["Java", "Lucene"],
    "conference" : {
        "name" : "Java Forum Stuttgart",
        "city" : "Stuttgart"
    }
}'

# Index an english doc
curl -XPUT "http://localhost:9200/conference/talk/2" -d'
{
    "title_en" : "Use cases for Elasticsearch",
    "speaker" : "Florian Hopf",
    "date" : "2014-07-17T15:35:00.000Z",
    "tags" : ["Java", "Lucene"],
    "conference" : {
        "name" : "Java Forum Stuttgart",
        "city" : "Stuttgart"
    }
}'

# Search german
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "match": {
           "title_de": "anwendungsfall"
        }
    }
}'

# Search english
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "match": {
           "title_en": "case"
        }
    }
}'

# Delete the index
curl -XDELETE "http://localhost:9200/conference"

# Index synonyms
curl -XPOST "http://localhost:9200/conference-synonym/" -d'
{
    "settings": {
        "analysis": {
            "filter": {
                "talk_synonyms": {
                    "type" : "synonym",
                    "synonyms" : [
                        "anwendungsfall, use-case"
                    ]
                },
                "minimal_german": {
                    "type": "stemmer",
                    "language": "minimal_german"
                }
            },
            "analyzer": {
                "query_time_talk_analyzer": {
                    "tokenizer": "standard",
                    "filter": [
                        "lowercase",
                        "minimal_german",
                        "talk_synonyms"
                    ]
                }
            }
        }
    }
}'

# See the synonyms
curl -XPOST "http://localhost:9200/conference-synonym/_analyze?analyzer=query_time_talk_analyzer&pretty" -d "Anwendungsfälle für Elasticsearch"

# Delete the index
curl -XDELETE "http://localhost:9200/conference-synonym"

# Add the stopword filter
curl -XPOST "http://localhost:9200/conference-synonym/" -d'
{
    "settings": {
        "analysis": {
            "filter": {
                "talk_synonyms": {
                    "type" : "synonym",
                    "synonyms" : [
                        "anwendungsfall, use-case"
                    ]
                },
                "german_stop_filter": {
                    "type": "stop",
                    "stopwords": "_german_"
                },
                "minimal_german": {
                    "type": "stemmer",
                    "language": "minimal_german"
                }
            },
            "analyzer": {
                "query_time_talk_analyzer": {
                    "tokenizer": "standard",
                    "filter": [
                        "lowercase",
                        "german_stop_filter",
                        "minimal_german",
                        "talk_synonyms"
                    ]
                }
            }
        }
    }
}'

# See 'für' being removed 
curl -XPOST "http://localhost:9200/conference-synonym/_analyze?analyzer=query_time_talk_analyzer&pretty" -d "Anwendungsfälle für Elasticsearch"

# Add mapping for some umlauts
curl -XPOST "http://localhost:9200/mapping-char-filter/" -d'
{
    "index" : {
        "analysis" : {
            "char_filter" : {
                "umlaut_filter" : {
                    "type" : "mapping",
                    "mappings" : ["ä=>ae", "ö=>oe"]
                }
            },
            "analyzer" : {
                "umlaut_analyzer" : {
                    "tokenizer" : "standard",
                    "char_filter" : ["umlaut_filter"]
                }
            }
        }
    }
}'

# See the mapping
curl -XPOST "http://localhost:9200/mapping-char-filter/_analyze?analyzer=umlaut_analyzer&pretty" -d "Motörhead"

# Delete the index
curl -XDELETE "http://localhost:9200/conference"

# Add tokenizers to index
curl -XPOST "http://localhost:9200/conference/" -d'
{
   "settings": {
      "analysis": {
        "tokenizer": {
            "prefix_tokenizer": {
               "type": "edgeNGram",
               "min_gram": "4",
               "max_gram": "9",
               "token_chars": [
                  "letter",
                  "digit"
               ]
            }
         },
         "analyzer": {
            "prefix_analyzer": {
               "tokenizer": "prefix_tokenizer",
               "filter": [
                  "lowercase"
               ]
            }
         }
       }
   }
}'

# Add new mapping
curl -XPUT "http://localhost:9200/conference/talk/_mapping " -d'
{
    "talk" : {
        "properties" : {
             "title": {
                "type": "string",
                "analyzer": "german",
                "fields": {
                    "prefix": {
                        "type": "string", 
                        "index_analyzer": "prefix_analyzer",
                        "search_analyzer": "standard"
                    }    
                }
             },
             "tags" : {"type": "string", "index": "not_analyzed"},
             "abstract": {
                "type": "string",
                "analyzer": "german",
                "index_options": "offsets"
             }        
        }
    }
}'

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
    },
    "abstract": "Elasticsearch findet als verteilte Volltextsuchmaschine immer weiter Verbreitung. Die Basis Lucene bietet viele für die Suche notwendige Features, die durch eine einfach zu bedienende REST-API von Elasticsearch zur Verfügung gestellt werden. In diesem Vortrag werden anhand unterschiedlicher Anwendungsfälle einige wichtige Eigenschaften von Elasticsearch vorgestellt: Die verteilte Natur ermöglicht die Speicherung auch großer Datenmengen auf denen dann einfach gesucht werden kann, Geo-Spatial-Features ermöglichen die Handhabung von Geo-Koordinaten und die Suche darauf, flexible Auswertungen über die Oberfläche Kibana werden häufig zur Logfile-Analyse eingesetzt, sind aber auch für andere Zwecke nützlich." 
}'

# Search and highlight
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "match": {
           "abstract": "Elasticsearch"
        }
    },
    "highlight": {
        "fields": {
            "abstract": {}
        }
    }
}'

# Search and highlight with custom marker
curl -XPOST "http://localhost:9200/conference/talk/_search" -d'
{
    "query": {
        "match": {
           "abstract": "Elasticsearch"
        }
    },
    "highlight": {
        "fields": {
            "abstract": {
                "fragment_size": 200,
                "number_of_fragments": 1
            }
        },
        "pre_tags": ["<mark>"],
        "post_tags": ["</mark>"]
     }
}'

# Delete the index
curl -XDELETE "http://localhost:9200/conference"

# Add tokenizers to index
curl -XPOST "http://localhost:9200/conference/" -d'
{
   "settings": {
      "analysis": {
        "tokenizer": {
            "prefix_tokenizer": {
               "type": "edgeNGram",
               "min_gram": "4",
               "max_gram": "9",
               "token_chars": [
                  "letter",
                  "digit"
               ]
            }
         },
         "analyzer": {
            "prefix_analyzer": {
               "tokenizer": "prefix_tokenizer",
               "filter": [
                  "lowercase"
               ]
            }
         }
      }
   }
}'

# Add new mapping
curl -XPUT "http://localhost:9200/conference/talk/_mapping " -d'
{
    "talk" : {
        "properties" : {
             "title": {
                "type": "string",
                "analyzer": "german",
                "fields": {
                    "prefix": {
                        "type": "string", 
                        "index_analyzer": "prefix_analyzer",
                        "search_analyzer": "standard"
                    }    
                }
             },
             "tags" : {"type": "string", "index": "not_analyzed"},
             "abstract": {
                "type": "string",
                "analyzer": "german",
                "index_options": "offsets"
             },
            "suggestion" : {
                "type" : "completion",
                "index_analyzer" : "simple",
                "search_analyzer" : "simple"
            }        
        }
    }
}'

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
    },
    "abstract": "Elasticsearch findet als verteilte Volltextsuchmaschine immer weiter Verbreitung. Die Basis Lucene bietet viele für die Suche notwendige Features, die durch eine einfach zu bedienende REST-API von Elasticsearch zur Verfügung gestellt werden. In diesem Vortrag werden anhand unterschiedlicher Anwendungsfälle einige wichtige Eigenschaften von Elasticsearch vorgestellt: Die verteilte Natur ermöglicht die Speicherung auch großer Datenmengen auf denen dann einfach gesucht werden kann, Geo-Spatial-Features ermöglichen die Handhabung von Geo-Koordinaten und die Suche darauf, flexible Auswertungen über die Oberfläche Kibana werden häufig zur Logfile-Analyse eingesetzt, sind aber auch für andere Zwecke nützlich.",
    "suggestion": {
        "input": [
            "Anwendungsfall",
            "Anwendungsfälle",
            "Anwendungsfälle für Elasticsearch",
            "Elasticsearch"
        ]
    }
}'

# Suggest terms
curl -XPOST "http://localhost:9200/_suggest?pretty" -d'
{
   "talk-suggestions": {
      "text": "anwendung",
      "completion": {
         "field": "suggestion"
      }
   }
}'

# Delete the index
curl -XDELETE "http://localhost:9200/conference"

# Add tokenizers to index
curl -XPOST "http://localhost:9200/conference/" -d'
{
   "settings": {
      "analysis": {
        "tokenizer": {
            "prefix_tokenizer": {
               "type": "edgeNGram",
               "min_gram": "4",
               "max_gram": "9",
               "token_chars": [
                  "letter",
                  "digit"
               ]
            }
         },
         "analyzer": {
            "prefix_analyzer": {
               "tokenizer": "prefix_tokenizer",
               "filter": [
                  "lowercase"
               ]
            }
         }
      }
   }
}'

# Add new mapping
curl -XPUT "http://localhost:9200/conference/talk/_mapping " -d'
{
    "talk" : {
        "properties" : {
             "title": {
                "type": "string",
                "analyzer": "german",
                "fields": {
                    "prefix": {
                        "type": "string", 
                        "index_analyzer": "prefix_analyzer",
                        "search_analyzer": "standard"
                    }    
                }
             },
             "tags" : {"type": "string", "index": "not_analyzed"},
             "abstract": {
                "type": "string",
                "analyzer": "german",
                "index_options": "offsets"
             },
            "suggestion" : {
                "type" : "completion",
                "index_analyzer" : "simple",
                "search_analyzer" : "simple",
                "context": {
                    "tag": {
                        "type": "category",
                        "path": "tags"
                    }            
                } 
            }       
        }
    }
}'

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
    },
    "abstract": "Elasticsearch findet als verteilte Volltextsuchmaschine immer weiter Verbreitung. Die Basis Lucene bietet viele für die Suche notwendige Features, die durch eine einfach zu bedienende REST-API von Elasticsearch zur Verfügung gestellt werden. In diesem Vortrag werden anhand unterschiedlicher Anwendungsfälle einige wichtige Eigenschaften von Elasticsearch vorgestellt: Die verteilte Natur ermöglicht die Speicherung auch großer Datenmengen auf denen dann einfach gesucht werden kann, Geo-Spatial-Features ermöglichen die Handhabung von Geo-Koordinaten und die Suche darauf, flexible Auswertungen über die Oberfläche Kibana werden häufig zur Logfile-Analyse eingesetzt, sind aber auch für andere Zwecke nützlich.",
    "suggestion": {
        "input": [
            "Anwendungsfall",
            "Anwendungsfälle",
            "Anwendungsfälle für Elasticsearch",
            "Elasticsearch"
        ]
    }
}'

# Suggest terms
curl -XPOST "http://localhost:9200/_suggest?pretty" -d'
{
   "talk-suggestions": {
      "text": "elastic",
      "completion": {
         "field": "suggestion",
         "context": {
            "tag": "Java"
         }
      }
   }
}'


