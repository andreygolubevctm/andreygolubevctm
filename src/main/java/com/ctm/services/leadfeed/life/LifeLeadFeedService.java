package com.ctm.services.leadfeed.life;

import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.Touch;
import com.ctm.model.Touch.TouchType;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.AccessTouchService;
import com.ctm.services.leadfeed.IProviderLeadFeedService;
import com.ctm.services.leadfeed.LeadFeedService;
import com.ctm.services.leadfeed.life.AGIS.AGISLifeLeadFeedService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.logging.LoggingArguments.kv;


public class LifeLeadFeedService extends LeadFeedService {

	private static final Logger logger = LoggerFactory.getLogger(LifeLeadFeedService.class.getName());

	protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType) {

		LeadResponseStatus responseStatus = LeadResponseStatus.FAILURE;

		IProviderLeadFeedService providerLeadFeedService = null;

		try {

			switch(leadData.getPartnerBrand()) {
				case "OZIC":
					logger.info("[Lead feed] Prepare to send lead to AGIS brand {},{}", kv("leadType", leadType), kv("transactionId", leadData.getTransactionId()));
					providerLeadFeedService = new AGISLifeLeadFeedService();
					break;
			}

			if(providerLeadFeedService != null) {
				logger.info("[Lead feed] Provider lead feed service found {}", kv("providerLeadFeedServiceClass", providerLeadFeedService.getClass()));
				responseStatus = providerLeadFeedService.process(leadType, leadData);
				if (responseStatus == LeadResponseStatus.SUCCESS) {
					recordTouch(touchType.getCode(), leadData);
				}
				logger.debug("[Lead feed] Provider lead process response {}", kv("responseStatus", responseStatus));
			}

		} catch(LeadFeedException e) {
			logger.error("[Lead feed] Exception adding lead feed message {}", kv("leadType", leadType), kv("leadData", leadData), kv("touchType", touchType));
			responseStatus = LeadResponseStatus.FAILURE;
		}

		return responseStatus;
	}

	/**
	 * Override the default so that we can pass a different touch type for Life/IP
	 * @param leadData
	 * @return
	 * @throws LeadFeedException
	 */
	public LeadResponseStatus bestPrice(LeadFeedData leadData) throws LeadFeedException {
		return processGateway(LeadType.BEST_PRICE, leadData, TouchType.LEAD_FEED);
	}

	/**
	 * New lead request - mirrors callback lead but uses different touch type
	 * @param leadData
	 * @return
	 * @throws LeadFeedException
	 */
	public LeadResponseStatus policySold(LeadFeedData leadData) throws LeadFeedException {
		return processGateway(LeadType.CALL_ME_BACK, leadData, TouchType.SOLD);
	}

	protected Boolean recordTouch(String touchType, LeadFeedData leadData) {
		AccessTouchService touchService = new AccessTouchService();

		if(!leadData.getProductId().isEmpty())
			return touchService.recordTouchWithComment(leadData.getTransactionId(), touchType, Touch.ONLINE_USER, leadData.getProductId());
		else
			return touchService.recordTouch(leadData.getTransactionId(), touchType, Touch.ONLINE_USER);
	}
}
