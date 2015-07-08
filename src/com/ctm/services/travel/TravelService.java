package com.ctm.services.travel;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import com.ctm.model.request.travel.TravelRequest;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.utils.travel.TravelRequestParser;
import org.apache.log4j.Logger;

import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;
import com.ctm.services.RequestService;

/**
 * TODO: once away from jsp create a router for this
 * @author adiente
 *
 */
public class TravelService {

	private static final Logger logger = Logger.getLogger(TravelService.class.getName());
	private boolean valid = false;
	private String vertical;
	private Data data;

	/**
	 * Used by JSP
	 * @param request
	 * @return
	 */
	public String validateFields(HttpServletRequest request, Data data) {

		try {
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request); // grab this current page's settings
			Vertical vert = pageSettings.getVertical(); // grab the vertical details
			vertical = vert.getType().toString().toLowerCase();

			RequestService fromFormService = new RequestService(request, vertical, data);
			SessionDataService sessionDataService = new SessionDataService();

			// remove anything that is not a numeric value and just let it continue as per normal. If they enter crap like bob, then they get bounced out of the A/B test
			String prefix = vertical.toLowerCase() + "/";
			String currentJourney = data.getString(prefix+"currentJourney");
			if (currentJourney != null)
			{
				// check if currentJourney contains any alpha characters
				Pattern p = Pattern.compile("[a-zA-Z]+");
				Matcher m = p.matcher(currentJourney);

				if (m.find()) {
					// empty our the currentJourney node if there is any alpha characters so we don't pollute the db with false currentJourney values
					// eg bob23 would be changed to ""
					data.put(prefix + "currentJourney", "");
				}
			}

			TravelRequest travelRequest = TravelRequestParser.parseRequest(data, vertical);
			List<SchemaValidationError> errors = validateRequest(travelRequest, vertical);

			if (!valid) {
				return outputErrors(fromFormService, errors);
			}
		}
		catch (Exception e) {
			logger.error(e);
		}
		return "";
	}


	public List<SchemaValidationError> validateRequest(TravelRequest travelRequest, String vertical) {
		List<SchemaValidationError> errors = FormValidation.validate(travelRequest, vertical);
		valid = errors.isEmpty();
		return errors;
	}

	private String outputErrors(RequestService fromFormService, List<SchemaValidationError> errors) {
		String response;
		FormValidation.logErrors(fromFormService.sessionId, fromFormService.transactionId, fromFormService.styleCodeId, errors, "TravelService.java:validateRequest");
		response = FormValidation.outputToJson(fromFormService.transactionId, errors).toString();
		return response;
	}

	public boolean isValid() {
		return valid;
	}

	public Data getGetData() {
		return data;
	}
}
