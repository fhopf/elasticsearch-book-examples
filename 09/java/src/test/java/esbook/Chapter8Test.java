package esbook;

import org.elasticsearch.action.admin.indices.refresh.RefreshRequest;
import org.elasticsearch.action.get.GetResponse;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.Client;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.node.NodeBuilder;
import org.junit.After;
import org.junit.Test;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

/**
 * Created by flo on 24.05.15.
 */
public class Chapter8Test {

    private Client createNodeClient() {
        Client client = NodeBuilder.nodeBuilder()
                .client(true)
                .node()
                .client();

        return client;
    }

    private Client createTransportClient() {
        Client transportClient = new TransportClient()
                .addTransportAddress(new InetSocketTransportAddress("localhost", 9300));
        return transportClient;
    }

    @Test
    public void indexATalkWithNodeClient() {
        indexATalk(createNodeClient());
    }

    public void indexATalk(Client client) {
        Map<String, Object> jsonContent = new HashMap<>();
        jsonContent.put("title", "Search-Driven Applications");
        jsonContent.put("speaker", new String[] {"Tobias Kraft", "Florian Hopf"});
        jsonContent.put("date", new Date());

        IndexResponse response = client.prepareIndex().
                setIndex("conference").
                setType("talk").
                setId("1").
                setSource(jsonContent).
                execute().actionGet();

        assertTrue(response.isCreated());

        // execute a GET on the doc id
        GetResponse getResponse = client.prepareGet("conference", "talk", response.getId()).
                execute().actionGet();
        assertTrue(getResponse.isExists());
        assertEquals("Search-Driven Applications", getResponse.getSource().get("title"));

        // refresh so we can search
        client.admin().indices().prepareRefresh("conference").execute().actionGet();

        SearchResponse searchResponse = client.prepareSearch("conference").
                setTypes("talk").
                setQuery(QueryBuilders.matchQuery("title", "search-driven")).
                execute().actionGet();

        assertEquals(1, searchResponse.getHits().getTotalHits());

    }

}
