package com.ctm.services.elasticsearch;

import org.apache.log4j.Logger;
import org.elasticsearch.client.Client;
import org.json.JSONArray;
import org.json.JSONException;

import com.ctm.exceptions.ElasticSearchConfigurationException;

public class AddressSearchService extends ElasticSearchService {

	private static Logger logger = Logger.getLogger(AddressSearchService.class.getName());

	private static Client elasticClient = null;
	private static boolean initialised = false;

	/**
	 * Create a connection to the ES server
	 */
	public static void init() {

		if(initialised == false) {

			initialised = true;

			try {

				elasticClient = ElasticClientProvider.createClient();
				logger.info("[ElasticSearch] Address Search client has been initialised");

			} catch (ElasticSearchConfigurationException e) {

				initialised = false;
				logger.error("[ElasticSearch] Could not initialise ElasticSearch client", e);
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
			logger.info("[ElasticSearch] Address Search client has been destroyed");
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

		if(initialised == false){
			init();
		}

		if(elasticClient != null) {
			String formattedQueryString = formatAddressQuery(query);
			return suggest(elasticClient, formattedQueryString, index, field);
		}

		return null;

	}

}
