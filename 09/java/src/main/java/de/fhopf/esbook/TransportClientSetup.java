package de.fhopf.esbook;

import org.elasticsearch.client.Client;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.transport.InetSocketTransportAddress;

/**
 * Created by flo on 24.05.15.
 */
public class TransportClientSetup {

    public Client createClient() {
        Client transportClient = new TransportClient()
                .addTransportAddress(new InetSocketTransportAddress("localhost", 9300));
        return transportClient;
    }

}
