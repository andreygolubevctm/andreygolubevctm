package com.ctm.web.utilities.services;

import com.ctm.exceptions.UtilitiesWebServiceException;
import com.ctm.web.utilities.model.UtilitiesProductModel;
import com.ctm.web.utilities.model.UtilitiesProductRequestModel;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;

public class UtilitiesProductService extends UtilitiesBaseService {


	/**
	 * Call Thought World and get the plan details information (used on the more info dialog)
	 * @param request
	 * @param model
	 * @return
	 */
	public UtilitiesProductModel getResults(HttpServletRequest request, UtilitiesProductRequestModel model) {

		try {

			// Call the service
			String sendJsonString = model.toJsonObject().toString();
			JSONObject responseJson = postJson(request, "productService", sendJsonString);

			// Process the response
			UtilitiesProductModel responseModel = new UtilitiesProductModel();
			boolean success = responseModel.populateFromThoughtWorldJson(responseJson);

			// Validate response
			if (success == false || !responseJson.has("plan_name") || responseJson.isNull("plan_name")) {
				throw new UtilitiesWebServiceException("Parse problem or missing mandatory field: 'plan_name' in "+responseJson);
			}

			return responseModel;

		}catch (Exception e) {

			// Handle exception
			recordError(request, e);
		}

		return null;
	}
}
