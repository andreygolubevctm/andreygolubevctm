package com.ctm.services.leadfeed.life;

import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.Touch;
import com.ctm.model.Touch.TouchType;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.AccessTouchService;
import com.ctm.services.leadfeed.IProviderLeadFeedService;
import com.ctm.services.leadfeed.LeadFeedService;
import com.ctm.services.leadfeed.life.AGIS.AGISLifeLeadFeedService;
import org.apache.log4j.Logger;


public class LifeLeadFeedService extends LeadFeedService {

	private static Logger logger = Logger.getLogger(LifeLeadFeedService.class.getName());

	protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType) {

		LeadResponseStatus responseStatus = LeadResponseStatus.FAILURE;

		IProviderLeadFeedService providerLeadFeedService = null;

		try {

			switch(leadData.getPartnerBrand()) {
				case "OZIC":
					logger.info("[Lead feed] Prepare to send lead to AGIS brand "+leadType+"; Transaction ID: "+leadData.getTransactionId());
					providerLeadFeedService = new AGISLifeLeadFeedService();
					break;
			}

			if(providerLeadFeedService != null) {
				logger.info("[Lead feed] Provider lead feed service found: " + providerLeadFeedService.getClass());
				responseStatus = providerLeadFeedService.process(leadType, leadData);
				if (responseStatus == LeadResponseStatus.SUCCESS) {
					recordTouch(touchType.getCode(), leadData);
				}
				logger.debug("[Lead feed] Provider lead process response: " + responseStatus);
			}

		} catch(LeadFeedException e) {
			logger.error("[Lead feed] Exception adding lead feed message",e);
			responseStatus = LeadResponseStatus.FAILURE;
		}

		return responseStatus;
	}

	protected Boolean recordTouch(String touchType, LeadFeedData leadData) {
		AccessTouchService touchService = new AccessTouchService();

		if(!leadData.getProductId().isEmpty())
			return touchService.recordTouchWithComment(leadData.getTransactionId(), touchType, Touch.ONLINE_USER, leadData.getProductId());
		else
			return touchService.recordTouch(leadData.getTransactionId(), touchType, Touch.ONLINE_USER);
	}
}
