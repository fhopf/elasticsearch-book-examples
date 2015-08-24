# Terms aggregation
curl -XPOST "http://localhost:9200/twitter-river/status/_search?pretty" -d'
{
    "size": 0,
    "aggs": {
        "language": {
            "terms": {
                "field": "language"    
            }
        }
    }
}'

# Nest aggregations
curl -XPOST "http://localhost:9200/twitter-river/status/_search?pretty" -d'
{
   "size": 0,
   "query": {
      "filtered": {
         "filter": {
            "term": {
               "language": "en"
            }
         }
      }
   },
   "aggs": {
      "language": {
         "terms": {
            "field": "language"
         },
         "aggs": {
            "hashtag": {
               "terms": {
                  "field": "hashtag.text"
               }
            }
         }
      }
   }
}'

# Date range aggregation
curl -XPOST "http://localhost:9200/twitter-river/status/_search?pretty" -d'
{
   "size": 0,
   "query": {
      "filtered": {
         "filter": {
            "term": {
               "language": "en"
            }
         }
      }
   },
   "aggs": {
      "language": {
         "terms": {
            "field": "language"
         },
        "aggs": {
            "datum": {
                "date_range": {
                    "field": "date",
                    "format": "MM-yyyy",
                    "ranges": [
                        { "to": "now-3M/M" },
                        { "from": "now-3M/M" }
                    ]
                }
            }
        }
     }
   }
}'

# Date histogram
curl -XPOST "http://localhost:9200/twitter-river/status/_search?pretty" -d'
{
   "size": 0,
   "query": {
      "filtered": {
         "filter": {
            "term": {
               "language": "en"
            }
         }
      }
   },
   "aggs": {
      "language": {
         "terms": {
            "field": "language"
         },
        "aggs": {
            "tweet_count": {
                "date_histogram": {
                    "field": "created_at",
                    "interval": "0.5h"
                }
            }
        }
    }
   }
}'

# Significant hashtags
curl -XPOST "http://localhost:9200/twitter-river/status/_search?pretty" -d'
{
   "size": 0,
   "query": {
      "filtered": {
         "filter": {
            "term": {
               "language": "en"
            }
         }
      }
   },
   "aggs": {
      "hashtag": {
         "terms": {
            "field": "hashtag.text"
         },
         "aggs": {
            "associated_hashtags": {
               "significant_terms": {
                  "field": "hashtag.text"
               }
            }
         }
      }
   }
   }
}'

# Retweet stats
curl -XPOST "http://localhost:9200/twitter-river/status/_search?pretty" -d'
{
   "size": 0,
   "query": {
      "filtered": {
         "filter": {
            "term": {
               "language": "en"
            }
         }
      }
   },
    "aggs": {
        "retweet_stats": {
            "stats": {
                "field": "retweet.retweet_count"    
            }
        }
    }
   }
}'

# User cardinality
curl -XPOST "http://localhost:9200/twitter-river/status/_search?pretty" -d'
{
   "size": 0,
   "query": {
      "filtered": {
         "filter": {
            "term": {
               "language": "en"
            }
         }
      }
   },
    "aggs": {
        "usercount": {
            "cardinality": {
                "field": "user.screen_name"    
            }
        }
    }
   }
}'

# Top hits 
curl -XPOST "http://localhost:9200/twitter-river/status/_search?pretty" -d'
{
   "size": 0,
   "query": {
      "filtered": {
         "filter": {
            "term": {
               "language": "en"
            }
         }
      }
   },
    "aggs": {
        "top-tweets": {
            "terms": {
                "field": "hashtag.text",
                "size": 3
            },
            "aggs": {
                "top_tweet_hits": {
                    "top_hits": {
                        "sort": [
                            {
                                "created_at": {
                                    "order": "desc"
                                }
                            }
                        ],
                        "_source": {
                            "include": [
                                "text", "user.screen_name"
                            ]
                        },
                        "size" : 1
                    }
                }
            }
        }
       }
   }
}'


