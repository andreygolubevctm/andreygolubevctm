package com.ctm.web.car.leadfeed.services;

import com.ctm.web.core.dao.leadfeed.BestPriceLeadsDao;
import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.Touch.TouchType;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.leadfeed.IProviderLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.car.leadfeed.services.AGIS.AGISCarLeadFeedService;
import com.ctm.web.car.leadfeed.services.AI.AICarLeadFeedService;
import com.ctm.web.car.leadfeed.services.REIN.REINCarLeadFeedService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.web.core.logging.LoggingArguments.kv;


public class CarLeadFeedService extends LeadFeedService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CarLeadFeedService.class);

	public CarLeadFeedService(BestPriceLeadsDao bestPriceDao) {
		super(bestPriceDao);
	}

	protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType) {

		LeadResponseStatus responseStatus = LeadResponseStatus.SUCCESS;

		IProviderLeadFeedService providerLeadFeedService = null;

		try {
			LOGGER.debug("[Lead feed] Prepare to send lead {}, {}, {}", kv("leadType", leadType), kv("leadData", leadData), kv("touchType", touchType));

			switch(leadData.getPartnerBrand()) {

				case "BUDD":
				case "EXPO":
				case "VIRG":
				case "EXDD":
				case "1FOW":
				case "RETI":
				case "OZIC":
				case "IECO":
				case "CBCK":
					providerLeadFeedService = new AGISCarLeadFeedService();
					break;
				case "WOOL":
					break;
				case "REIN":
					providerLeadFeedService = new REINCarLeadFeedService();
					break;
				case "AI":
					providerLeadFeedService = new AICarLeadFeedService();
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
			LOGGER.error("[Lead feed] Error adding lead feed message {}, {}, {}", kv("leadType", leadType), kv("leadData", leadData),
				kv("touchType", touchType), e);
			responseStatus = LeadResponseStatus.FAILURE;
		}

		return responseStatus;
	}
}
