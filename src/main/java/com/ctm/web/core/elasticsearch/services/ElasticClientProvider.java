package com.ctm.web.core.elasticsearch.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.elasticsearch.exceptions.ElasticSearchConfigurationException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.web.core.services.ServiceConfigurationService;
import org.elasticsearch.client.Client;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.ImmutableSettings;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;

public class ElasticClientProvider {

	public static TransportClient transportClient = null;

	/**
	 * Create transport client to connect to elastic search nodes
	 *
	 * @return
	 * @throws ElasticSearchConfigurationException
	 */
	public static Client createClient() throws ElasticSearchConfigurationException {
		ServiceConfiguration serviceConfig = null;

		try {
			serviceConfig = ServiceConfigurationService.getServiceConfiguration("elasticSearchService", 0);
		} catch (DaoException | ServiceConfigurationException e) {
			throw new ElasticSearchConfigurationException("Could not load the required configuration for the ElasticSearch Service", e);
		}

		String clusterName = serviceConfig.getPropertyValueByKey("clusterName", 0, 0, Scope.SERVICE);
		String transportAddress = serviceConfig.getPropertyValueByKey("transportAddress", 0, 0, Scope.SERVICE);
		String portNumberString = serviceConfig.getPropertyValueByKey("portNumber", 0, 0, Scope.SERVICE);

		int portNumber = Integer.parseInt(portNumberString);

		Settings settings = ImmutableSettings.settingsBuilder()
				.put("cluster.name", clusterName)
				.put("client.transport.sniff", true)
				.build();

		// destroy client if exists - for safety as this should not be called multiple times.
		destroy();
		transportClient = new TransportClient(settings);
		return transportClient.addTransportAddress(new InetSocketTransportAddress(transportAddress, portNumber));
	}

	/**
	 * Close the transport client
	 */
	public static void destroy(){
		if(transportClient != null){
			transportClient.close();
			transportClient = null;
		}
	}

}