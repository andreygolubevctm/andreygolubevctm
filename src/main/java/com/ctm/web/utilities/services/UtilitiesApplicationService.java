package com.ctm.web.utilities.services;

import com.ctm.exceptions.UtilitiesWebServiceException;
import com.ctm.web.utilities.model.UtilitiesApplicationModel;
import com.ctm.web.utilities.model.UtilitiesApplicationRequestModel;
import com.ctm.web.core.web.go.Data;
import org.json.JSONObject;

import javax.annotation.Nullable;
import javax.servlet.http.HttpServletRequest;

public class UtilitiesApplicationService extends UtilitiesBaseService {

	/**
	 * Method to be called from the JSP page to submit an application to Thought World.
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unused") // Used by JSP
	public String submitFromJsp(HttpServletRequest request, Data data){
		String validationResult = validate(request, data);

		if(isValid()) {
			UtilitiesApplicationRequestModel model = new UtilitiesApplicationRequestModel();
			model.populateFromRequest(request);

			UtilitiesApplicationModel returnedModel = doSubmit(request, model);

			// Validate response. Create an empty model so it can be run through toJson.
			if (returnedModel == null) {
				return "";
			}
			return returnedModel.toJson();
		}
		return validationResult;
	}

	/**
	 * Method to be called from Java to submit an application to Thought World.
	 * @param request
	 * @param model
	 * @return
	 */
	@Nullable
	public UtilitiesApplicationModel doSubmit(HttpServletRequest request, UtilitiesApplicationRequestModel model){

		try {

			// Call the service
			String sendJsonString = model.toJsonObject().toString();
			JSONObject responseJson = postJson(request, "applicationService", sendJsonString);

			// Process the response
			UtilitiesApplicationModel responseModel = new UtilitiesApplicationModel();
			boolean success = responseModel.populateFromThoughtWorldJson(responseJson);

			// Validate response
			if (success == false || responseJson.has("unique_purchase_id") == false || responseJson.isNull("unique_purchase_id")) {
				throw new UtilitiesWebServiceException("Parse problem or missing mandatory field: 'unique_purchase_id' in "+responseJson);
			}

			return responseModel;

		}catch (Exception e) {

			// Handle exception
			recordError(request, e);
		}

		return null;

	}
}
