package com.ctm.services.life;

import javax.servlet.http.HttpServletRequest;

import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.model.settings.Brand;
import com.ctm.services.ApplicationService;
import com.ctm.services.leadfeed.LeadFeedService;
import com.ctm.services.leadfeed.life.LifeLeadFeedService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.SessionDataService;
import com.disc_au.web.go.Data;

public class AGISLeadFromRequest {

	private static final Logger logger = LoggerFactory.getLogger(AGISLeadFromRequest.class);

	public String newPolicySold(HttpServletRequest request, PageSettings pageSettings, String transactionId) {
		return process(request, pageSettings, transactionId, true);
	}

	public String newLeadFeed(HttpServletRequest request, PageSettings pageSettings, String transactionId) {
		return process(request, pageSettings, transactionId, false);
	}
	
	public String process(HttpServletRequest request, PageSettings pageSettings, String transactionId, Boolean policySold) {

		LeadFeedService.LeadResponseStatus output = LeadFeedService.LeadResponseStatus.FAILURE;

		try {
			LeadFeedData lead = new LeadFeedData();

			SessionDataService sds = new SessionDataService();
			Data data = null;
			try {
				data = sds.getDataForTransactionId(request, transactionId, false);
			} catch (DaoException | SessionException e1) {
				e1.printStackTrace();
			}

			String vertical = data.get("current/verticalCode").toString().toLowerCase();
			String verticalCode = data.get("current/verticalCode").toString().toUpperCase();

			lead.setEventDate(ApplicationService.getApplicationDate(request));
			lead.setBrandCode(ApplicationService.getBrandCodeFromRequest(request));

			Brand brand = ApplicationService.getBrandByCode(lead.getBrandCode());
			lead.setBrandId(brand.getId());
			lead.setVerticalCode(verticalCode);
			lead.setVerticalId(brand.getVerticalByCode(verticalCode).getId());

			lead.setCallType(LeadFeedData.CallType.GET_CALLBACK);

			lead.setTransactionId(Long.parseLong(transactionId));
			String clientName = data.get(vertical + "/primary/firstName").toString() + " " + data.get(vertical + "/primary/lastname").toString();
			lead.setClientName(clientName.trim());
			lead.setPhoneNumber(data.get(vertical + "/contactDetails/contactNumber").toString().trim());
			lead.setState(data.get(vertical + "/primary/state") != null ? data.get(vertical + "/primary/state").toString() : "");
			lead.setPartnerBrand(data.get("lead/brand").toString());
			lead.setProductId(data.get("lead/company").toString().toLowerCase());
			lead.setClientIpAddress(data.get(vertical + "/clientIpAddress") != null ? data.get(vertical + "/clientIpAddress").toString() : request.getRemoteAddr());
			lead.setPartnerReference(data.get("lead/leadNumber").toString());

			// Call Lead Feed Service
			LeadFeedData leadDataPack = lead;
			LifeLeadFeedService service = new LifeLeadFeedService();
			if(policySold == true) {
				output = service.policySold(leadDataPack);
			} else {
				output = service.callMeBack(leadDataPack);
			}
		} catch (Exception e) {
			logger.error("[lead feed] Exception thrown: " + e.getMessage(), e);
		}

		if(output == LeadFeedService.LeadResponseStatus.SUCCESS) {
			return "OK";
		} else {
			return "ERROR";
		}
	}
	
}
