package de.fhopf.esbook;

import org.elasticsearch.client.Client;
import org.elasticsearch.node.NodeBuilder;

/**
 * Created by flo on 24.05.15.
 */
public class NodeClientSetup {

    public Client createClient() {

        Client client = NodeBuilder.nodeBuilder()
                .client(true)
                .node()
                .client();

        return client;

    }


}
