package com.ctm.web.homecontents.leadfeed.services;

import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.IProviderLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.core.model.Touch.TouchType;
import com.ctm.web.homecontents.leadfeed.services.AGIS.AGISHomeContentsLeadFeedService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class HomeContentsLeadFeedService extends LeadFeedService {

	private static final Logger LOGGER = LoggerFactory.getLogger(HomeContentsLeadFeedService.class);

	public HomeContentsLeadFeedService(BestPriceLeadsDao bestPriceDao) {
		super(bestPriceDao, new ContentService());
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
