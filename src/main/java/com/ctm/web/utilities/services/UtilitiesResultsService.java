package com.ctm.web.utilities.services;

import com.ctm.exceptions.UtilitiesWebServiceException;
import com.ctm.web.utilities.model.UtilitiesResultsModel;
import com.ctm.web.utilities.model.UtilitiesResultsRequestModel;
import com.ctm.web.core.web.go.Data;
import org.json.JSONArray;

import javax.servlet.http.HttpServletRequest;

public class UtilitiesResultsService extends UtilitiesBaseService {

	public String getFromJsp(HttpServletRequest request, Data data){
		String validationResult = validate(request, data);

		if(isValid()) {
			UtilitiesResultsRequestModel model = new UtilitiesResultsRequestModel();
			model.populateFromRequest(request);

			UtilitiesResultsService service = new UtilitiesResultsService();

			UtilitiesResultsModel returnedModel = service.getResults(request, model);

			if(returnedModel == null) {
				return "";
			}

			return returnedModel.toJson();
		} else {
			return validationResult;
		}
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
