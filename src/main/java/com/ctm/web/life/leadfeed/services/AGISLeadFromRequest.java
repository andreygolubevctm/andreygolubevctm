package com.ctm.web.life.leadfeed.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.exceptions.SessionExpiredException;
import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.core.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * Use LifeApplyService instead
 **/
@Deprecated // TODO: Delete once life apply and life lead feed service has gone live
public class AGISLeadFromRequest {

	private static final Logger LOGGER = LoggerFactory.getLogger(AGISLeadFromRequest.class);

	private final IPAddressHandler ipAddressHandler;

    @Deprecated
    @SuppressWarnings("unused")
    public AGISLeadFromRequest() {
        this.ipAddressHandler = IPAddressHandler.getInstance();
    }

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
			} catch(SessionExpiredException e0) {
				LOGGER.info(e0.getMessage());
			} catch (DaoException | SessionException e1) {
				LOGGER.error("Failed to retrieve session {} {}", kv("errorMessage", e1.getMessage()), kv("transactionId", transactionId));
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
			lead.setClientIpAddress(data.get(vertical + "/clientIpAddress") != null ? data.get(vertical + "/clientIpAddress").toString() : ipAddressHandler.getIPAddress(request));
			lead.setPartnerReference(data.get("lead/leadNumber").toString());

			// Call Lead Feed Service
			LifeLeadFeedService service = new LifeLeadFeedService(new BestPriceLeadsDao());
			if(policySold) {
				output = service.policySold(lead);
			} else {
				output = service.callMeBack(lead);
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
