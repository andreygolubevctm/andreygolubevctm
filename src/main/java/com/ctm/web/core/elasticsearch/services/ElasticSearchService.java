package com.ctm.web.core.elasticsearch.services;

import com.ctm.web.core.services.FatalErrorService;
import org.elasticsearch.action.suggest.SuggestRequestBuilder;
import org.elasticsearch.action.suggest.SuggestResponse;
import org.elasticsearch.client.Client;
import org.elasticsearch.common.unit.Fuzziness;
import org.elasticsearch.search.suggest.completion.CompletionSuggestionBuilder;
import org.elasticsearch.search.suggest.completion.CompletionSuggestionFuzzyBuilder;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ElasticSearchService {

	protected static FatalErrorService fatalErrorService;

	private final static Fuzziness SUGGESTION_FUZZINESS = Fuzziness.ONE;
	private final static int SUGGESTION_SIZE = 7;

	public ElasticSearchService() {
		fatalErrorService = new FatalErrorService();
	}

	public JSONArray suggest(Client client, String query, String index, String field) throws JSONException {
		CompletionSuggestionBuilder suggestionBuilder = new CompletionSuggestionBuilder("suggest");
		suggestionBuilder
			.text(query)
			.field(field)
			.size(SUGGESTION_SIZE);

		CompletionSuggestionFuzzyBuilder suggestionFuzzyBuilder = new CompletionSuggestionFuzzyBuilder("suggest_fuzzy");
		suggestionFuzzyBuilder
			.text(query)
			.field(field)
			.size(SUGGESTION_SIZE)
			.setFuzziness(SUGGESTION_FUZZINESS);

		SuggestRequestBuilder suggestRequest = client.prepareSuggest(index);
		suggestRequest
			.addSuggestion(suggestionBuilder)
			.addSuggestion(suggestionFuzzyBuilder);

		SuggestResponse suggestResponse = suggestRequest.execute().actionGet();

		/**
		 * We are getting the results by parsing the result as a JSON response.
		 * Doing this the proper way using the SDK doesn't return payloads (for whatever reason).
		 */
		JSONObject output = new JSONObject(suggestResponse.toString());

		JSONArray suggestArray = null;
		JSONArray suggestFuzzyArray = null;

		if(output.has("suggest")) {
			suggestArray = output.getJSONArray("suggest").getJSONObject(0).getJSONArray("options");
		}

		if(output.has("suggest_fuzzy")) {
			suggestFuzzyArray = output.getJSONArray("suggest_fuzzy").getJSONObject(0).getJSONArray("options");
		}

		if(suggestArray != null && suggestFuzzyArray != null) {
			return concatJSONArrays(suggestArray, suggestFuzzyArray);
		} else if (suggestArray != null) {
			return suggestArray;
		} else if (suggestFuzzyArray != null) {
			return suggestFuzzyArray;
		} else {
			return new JSONArray("[]");
		}
	}

	public JSONArray concatJSONArrays(JSONArray... arrs) throws JSONException {
		JSONArray result = new JSONArray();

		for (JSONArray arr : arrs) {
			for (int i = 0; i < arr.length(); i++) {
				result.put(arr.get(i));
			}
		}

		return result;
	}

}
