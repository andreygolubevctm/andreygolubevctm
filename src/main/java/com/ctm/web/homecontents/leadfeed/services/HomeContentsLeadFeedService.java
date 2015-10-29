package com.ctm.web.homecontents.leadfeed.services;

import com.ctm.web.core.dao.leadfeed.BestPriceLeadsDao;
import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.Touch.TouchType;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.leadfeed.IProviderLeadFeedService;
import com.ctm.services.leadfeed.homecontents.AGIS.AGISHomeContentsLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class HomeContentsLeadFeedService extends LeadFeedService {


	private static final Logger LOGGER = LoggerFactory.getLogger(HomeContentsLeadFeedService.class);

	public HomeContentsLeadFeedService(BestPriceLeadsDao bestPriceDao) {
		super(bestPriceDao);
	}

	protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType) {
		LeadResponseStatus responseStatus = LeadResponseStatus.SUCCESS;
		IProviderLeadFeedService providerLeadFeedService = null;

		try {
			switch(leadData.getPartnerBrand()) {
				case "BUDD":
				case "VIRG":
					LOGGER.info("[Lead feed] Prepare to send lead to AGIS brand {}", kv("leadType", leadType), kv("transactionId", leadData.getTransactionId()));
					providerLeadFeedService = new AGISHomeContentsLeadFeedService();
					break;
				default:
					LOGGER.debug("[Lead feed] No lead feed set up {}", kv("partnerBrand", leadData.getPartnerBrand()), kv("transactionId", leadData.getTransactionId()));
					break;
			}

			if(providerLeadFeedService != null) {
				responseStatus = providerLeadFeedService.process(leadType, leadData);
				if (responseStatus == LeadResponseStatus.SUCCESS) {
					recordTouch(touchType.getCode(), leadData);
				}
				LOGGER.debug("[Lead feed] Provider lead process response {}", kv("responseStatus", responseStatus));
			}

		} catch(LeadFeedException e) {
			LOGGER.error("[Lead feed] Error adding lead feed message {}, {}, {}", kv("leadType", leadType), kv("leadData", leadData), kv("touchType", touchType));
			responseStatus = LeadResponseStatus.FAILURE;
		}

		return responseStatus;
	}
}
