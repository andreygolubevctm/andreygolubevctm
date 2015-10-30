package com.ctm.web.life.leadfeed.services;

import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.PageSettings;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.core.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class AGISLeadFromRequest {

	private static final Logger LOGGER = LoggerFactory.getLogger(AGISLeadFromRequest.class);

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
				LOGGER.error("Failed to retrieve session {}", kv("transactionId", transactionId));
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
			LifeLeadFeedService service = new LifeLeadFeedService(new BestPriceLeadsDao());
			if(policySold == true) {
				output = service.policySold(leadDataPack);
			} else {
				output = service.callMeBack(leadDataPack);
			}
		} catch (Exception e) {
			LOGGER.error("[lead feed] Failed creating new lead feed {}, {}, {}", kv("pageSettings", pageSettings),
					kv("transactionId", transactionId), kv("policySold", policySold));
		}

		if(output == LeadFeedService.LeadResponseStatus.SUCCESS) {
			return "OK";
		} else {
			return "ERROR";
		}
	}
	
}
