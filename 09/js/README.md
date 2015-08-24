Simplest Example of the official Elasticsearch JavaScript client used in a browser.

The Elasticsearch instance that is accessed on http://localhost:9200 needs to be configured with CORS enabled. Add this to elasticsearch.yml:

    http.cors.allow-origin: "/.*/"
    http.cors.enabled: true


