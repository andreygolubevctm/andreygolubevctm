package com.ctm.web.utilities.services;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.json.JSONObject;

import com.ctm.web.utilities.model.UtilitiesProviderServiceModel;
import com.ctm.web.utilities.model.UtilitiesProviderServiceRequest;

public class UtilitiesProviderService extends UtilitiesBaseService {

	public UtilitiesProviderServiceModel getResults(HttpServletRequest request, String postCode, String suburb) {
		UtilitiesProviderServiceRequest model = new UtilitiesProviderServiceRequest();
		UtilitiesProviderServiceModel providerServiceModel = new UtilitiesProviderServiceModel();
		if(StringUtils.isNotBlank(postCode) && StringUtils.isNotBlank(suburb)) {
			model.setPostcode(postCode);
			model.setSuburb(suburb);
			providerServiceModel = getResults(request, model);
		}
		return providerServiceModel;
	}

	/**
	 * Get a list of Services available along with providers for a given postcode/suburb
	 * @param request Required to look up service configuration
	 * @param model Model with necessary search parameters
	 * @return
	 */

	public UtilitiesProviderServiceModel getResults(HttpServletRequest request, UtilitiesProviderServiceRequest model) {

		try {

			// Call the service
			String sendJsonString = model.toJsonObject().toString();
			JSONObject responseJson = postJson(request, "providerService", sendJsonString);

			// Process the response
			UtilitiesProviderServiceModel responseModel = new UtilitiesProviderServiceModel();
			boolean success = responseModel.populateFromThoughtWorldJson(responseJson);

			// Validate response
			//if (success == false || !responseJson.has("fuel_type") || responseJson.isNull("fuel_type")) {
			//	throw new UtilitiesWebServiceException("Parse problem or missing mandatory field: 'unique_purchase_id' in "+responseJson);
			//}

			return responseModel;

		}catch (Exception e) {

			// Handle exception
			recordError(request, e);
		}

		return null;

	}

}
