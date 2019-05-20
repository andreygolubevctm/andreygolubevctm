package com.ctm.web.core.elasticsearch.services;

import com.ctm.web.core.elasticsearch.exceptions.ElasticSearchConfigurationException;
import org.elasticsearch.client.Client;
import org.json.JSONArray;
import org.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.UnknownHostException;

public class AddressSearchService extends ElasticSearchService {

	private static final Logger LOGGER = LoggerFactory.getLogger(AddressSearchService.class);

	private static Client elasticClient = null;
	private static boolean initialised = false;

	/**
	 * Create a connection to the ES server
	 */
	public static void init() {
		if(!initialised) {
			initialised = true;

			try {
				elasticClient = ElasticClientProvider.createClient();
				LOGGER.debug("[ElasticSearch] Address Search client has been initialised");
			} catch (Exception e) {
				initialised = false;
				LOGGER.error("[ElasticSearch] Could not initialise ElasticSearch client", e);
				fatalErrorService.logFatalError(e, 0, "AddressSearchService", false, "");
			}
		}
	}

	/**
	 * Close the connection to the ES client
	 * Should be called from the contextFinalizer class.
	 */
	public static void destroy() {
		if(elasticClient != null) {
			elasticClient.close();
			initialised = false;
			ElasticClientProvider.destroy();
			LOGGER.debug("[ElasticSearch] Address Search client has been destroyed");
		}
	}

	/**
	 * Formats a provided input in a consistent format suitable for querying ElasticSearch
	 *
	 * @param query
	 * @return
	 */
	private String formatAddressQuery(String query) {
		if(query != null) {
			return query.toLowerCase()
				.replaceFirst("^(\\/|0(?!\\s))", "")
				.replaceAll("[^A-Za-z0-9\\s\\/\\_\\-\\']+", " ")
				.replaceAll("(\\s+)?(\\-|\\/)(\\s+)?", "$2")
				.replaceFirst("^(u|unit)(\\d)", "unit $2")
				.replaceFirst("^(shop|duplex|apartment|apt|lot|store|level|lv|l|f|floor|u|townhouse|suite|site|flat|building|bld|villa|house)\\s+", "unit ")
				.replaceFirst("([a-z0-9]+)\\/([a-z0-9]+)", "unit $1 $2 ")
				.replaceAll("\\s\\-|\\-", "_")
				.replaceAll("^(unit )+", "unit ");
		} else {
			return "";
		}
	}

	/**
	 * Query the ES nodes
	 *
	 * @param query
	 * @param index
	 * @param field
	 * @return
	 * @throws JSONException
	 */
	public JSONArray suggest(String query, String index, String field) throws JSONException {

		if(!initialised){
			init();
		}

		if(elasticClient != null) {
			String formattedQueryString = formatAddressQuery(query);
			return suggest(elasticClient, formattedQueryString, index, field);
		}

		return null;

	}

}
