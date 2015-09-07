package com.ctm.services.leadfeed.homecontents;

import com.ctm.services.leadfeed.IProviderLeadFeedService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.Touch.TouchType;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.leadfeed.LeadFeedService;
import com.ctm.services.leadfeed.homecontents.AGIS.AGISHomeContentsLeadFeedService;

import static com.ctm.logging.LoggingArguments.kv;

public class HomeContentsLeadFeedService extends LeadFeedService {

	private static final Logger logger = LoggerFactory.getLogger(HomeContentsLeadFeedService.class.getName());

	protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType) {
		LeadResponseStatus responseStatus = LeadResponseStatus.SUCCESS;
		IProviderLeadFeedService providerLeadFeedService = null;

		try {
			switch(leadData.getPartnerBrand()) {
				case "BUDD":
				case "VIRG":
					logger.info("[Lead feed] Prepare to send lead to AGIS brand {}", kv("leadType", leadType), kv("transactionId", leadData.getTransactionId()));
					providerLeadFeedService = new AGISHomeContentsLeadFeedService();
					break;
				case "WOOL":
				case "REIN":
					logger.debug("[Lead feed] No lead feed set up {}", kv("partnerBrand", leadData.getPartnerBrand()), kv("transactionId", leadData.getTransactionId()));
					break;
			}

			if(providerLeadFeedService != null) {
				responseStatus = providerLeadFeedService.process(leadType, leadData);
				if (responseStatus == LeadResponseStatus.SUCCESS) {
					recordTouch(touchType.getCode(), leadData);
				}
				logger.debug("[Lead feed] Provider lead process response {}", kv("responseStatus", responseStatus));
			}

		} catch(LeadFeedException e) {
			logger.error("[Lead feed] Error adding lead feed message {}, {}, {}", kv("leadType", leadType), kv("leadData", leadData), kv("touchType", touchType));
			responseStatus = LeadResponseStatus.FAILURE;
		}

		return responseStatus;
	}
}
