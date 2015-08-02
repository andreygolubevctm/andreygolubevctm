package com.ctm.services.leadfeed.homecontents;

import com.ctm.services.leadfeed.IProviderLeadFeedService;
import org.apache.log4j.Logger;

import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.Touch.TouchType;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.leadfeed.LeadFeedService;
import com.ctm.services.leadfeed.homecontents.AGIS.AGISHomeContentsLeadFeedService;

public class HomeContentsLeadFeedService extends LeadFeedService {

	private static Logger logger = Logger.getLogger(HomeContentsLeadFeedService.class.getName());

	protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType) {

		LeadResponseStatus responseStatus = LeadResponseStatus.SUCCESS;

		IProviderLeadFeedService providerLeadFeedService = null;

		try {

			switch(leadData.getPartnerBrand()) {

				case "BUDD":
				case "VIRG":
					logger.info("[Lead feed] Prepare to send lead to AGIS brand "+leadType+"; Transaction ID: "+leadData.getTransactionId());
					providerLeadFeedService = new AGISHomeContentsLeadFeedService();
					break;
				case "WOOL":
					logger.debug("[Lead feed] No lead feed set up for WOOL "+leadType+"; Transaction ID: "+leadData.getTransactionId());
					break;
				case "REIN":
					logger.debug("[Lead feed] No lead feed set up for REIN "+leadType+"; Transaction ID: "+leadData.getTransactionId());
					break;
			}

			if(providerLeadFeedService != null) {
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
}
