package com.ctm.web.life.services;

import com.ctm.web.life.model.request.LifeRequest;
import com.ctm.web.core.services.RequestService;
import com.ctm.web.core.utils.life.LifeRequestParser;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.core.web.go.Data;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * TODO: once away from jsp create a router for this
 * @author lbuchanan
 *
 */
public class LifeService {

	private boolean valid = false;
	private String vertical;
	/**
	 * Used by JSP
	 * @param request
	 * @return
	 */
	public String contactLeadViaJSP(HttpServletRequest request, Data data) {
		vertical = request.getParameter("vertical");
		RequestService fromFormService = new RequestService(request, vertical, data);

		LifeRequest lifeRequest = LifeRequestParser.parseRequest(data, vertical);
		List<SchemaValidationError> errors = contactLead(lifeRequest, vertical);
		if(!valid) {
			return outputErrors(fromFormService, errors);
		}
		return "";
	}


	public List<SchemaValidationError> contactLead(LifeRequest lifeRequest, String vertical) {
		List<SchemaValidationError> errors = FormValidation.validate(lifeRequest, vertical);
		valid = errors.isEmpty();
		return errors;
	}

	private String outputErrors(RequestService fromFormService, List<SchemaValidationError> errors) {
		String response;
		FormValidation.logErrors(fromFormService.sessionId, fromFormService.transactionId, fromFormService.styleCodeId, errors, "LifeService.java:contactLead");
		response = FormValidation.outputToJson(fromFormService.transactionId, errors).toString();
		return response;
	}

	public boolean isValid() {
		return valid;
	}

}
