package com.ctm.services.utilities;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;

import com.ctm.exceptions.UtilitiesWebServiceException;
import com.ctm.model.utilities.UtilitiesResultsModel;
import com.ctm.model.utilities.UtilitiesResultsRequestModel;

public class UtilitiesResultsService extends UtilitiesBaseService{

	public static String getFromJsp(HttpServletRequest request){

		UtilitiesResultsRequestModel model = new UtilitiesResultsRequestModel();
		model.populateFromRequest(request);

		UtilitiesResultsService service = new UtilitiesResultsService();

		UtilitiesResultsModel returnedModel = service.getResults(request, model);

		return returnedModel.toJson();

	}

	public UtilitiesResultsModel getResults(HttpServletRequest request, UtilitiesResultsRequestModel model){

		try {

			// Call the service
			String sendJsonString = model.toJsonObject().toString();
			JSONArray responseJson = postJsonArray(request, "resultsService", sendJsonString);

			// Process the response
			UtilitiesResultsModel responseModel = new UtilitiesResultsModel();
			boolean success = responseModel.populateFromThoughtWorldJson(responseJson);

			// Validate response
			if (success == false || responseModel.getPlans().size() == 0) {
				throw new UtilitiesWebServiceException("Parse problem or missing mandatory field: 'plans' in "+responseJson);
			}

			return responseModel;

		}catch (Exception e) {

			// Handle exception
			recordError(request, e);
		}

		return null;

	}
}
