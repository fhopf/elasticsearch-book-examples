package de.fhopf.esbook;

import org.elasticsearch.action.index.IndexRequestBuilder;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.client.Client;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by flo on 24.05.15.
 */
public class IndexService {

    private final Client client;

    public IndexService(Client client) {
        this.client = client;
    }

    public void indexATalk() {
        Map<String, Object> jsonContent = new HashMap<>();
        jsonContent.put("title", "Search-Driven Applications");
        jsonContent.put("speaker", new String[] {"Tobias Kraft", "Florian Hopf"});
        jsonContent.put("date", new Date());

        IndexResponse response = client.prepareIndex().
                setIndex("conference").
                setType("talk").
                setSource(jsonContent).
                execute().actionGet();


    }

}
