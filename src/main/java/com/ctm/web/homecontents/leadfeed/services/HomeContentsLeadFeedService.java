package com.ctm.web.homecontents.leadfeed.services;

import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.IProviderLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedTouchService;
import com.ctm.web.core.model.Touch.TouchType;
import com.ctm.web.core.services.AccessTouchService;
import com.ctm.web.homecontents.leadfeed.services.AGIS.AGISHomeContentsLeadFeedService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class HomeContentsLeadFeedService extends LeadFeedService {

	private static final Logger LOGGER = LoggerFactory.getLogger(HomeContentsLeadFeedService.class);

	public HomeContentsLeadFeedService(BestPriceLeadsDao bestPriceDao) {
		super(bestPriceDao, new ContentService(), new LeadFeedTouchService(new AccessTouchService()));
	}

	protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType) {
		LeadResponseStatus responseStatus;
		IProviderLeadFeedService providerLeadFeedService = null;

		try {
			switch(leadData.getPartnerBrand()) {
				case "BUDD":
				case "VIRG":
				case "EXDD":
				case "EXPO":
					LOGGER.info("[Lead feed] Prepare to send lead to AGIS brand {}", kv("leadType", leadType), kv("transactionId", leadData.getTransactionId()));
					providerLeadFeedService = new AGISHomeContentsLeadFeedService();
					break;
				default:
					LOGGER.debug("[Lead feed] No lead feed set up {}", kv("partnerBrand", leadData.getPartnerBrand()), kv("transactionId", leadData.getTransactionId()));
					break;
			}
			 responseStatus = getLeadResponseStatus(leadType, leadData, touchType, providerLeadFeedService);
		} catch(LeadFeedException e) {
			LOGGER.error("[Lead feed] Error adding lead feed message {}, {}, {}", kv("leadType", leadType), kv("leadData", leadData), kv("touchType", touchType));
			responseStatus = LeadResponseStatus.FAILURE;
		}

		return responseStatus;
	}
}
