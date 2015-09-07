package com.ctm.services.leadfeed.car;

import java.util.ArrayList;

import com.ctm.services.leadfeed.IProviderLeadFeedService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.Touch.TouchType;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.leadfeed.LeadFeedService;
import com.ctm.services.leadfeed.car.AGIS.AGISCarLeadFeedService;
import com.ctm.services.leadfeed.car.REIN.REINCarLeadFeedService;
import com.ctm.services.leadfeed.car.AI.AICarLeadFeedService;

import static com.ctm.logging.LoggingArguments.kv;


public class CarLeadFeedService extends LeadFeedService {

	private static final Logger logger = LoggerFactory.getLogger(CarLeadFeedService.class.getName());

	protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType) {

		LeadResponseStatus responseStatus = LeadResponseStatus.SUCCESS;

		IProviderLeadFeedService providerLeadFeedService = null;

		try {
			logger.debug("[Lead feed] Prepare to send lead {}, {}, {}", kv("leadType", leadType), kv("leadData", leadData), kv("touchType", touchType));

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
				logger.debug("[Lead feed] Provider lead process response {}", kv("responseStatus", responseStatus));
			}

		} catch(LeadFeedException e) {
			logger.error("[Lead feed] Error adding lead feed message {}, {}, {}", kv("leadType", leadType), kv("leadData", leadData),
				kv("touchType", touchType), e);
			responseStatus = LeadResponseStatus.FAILURE;
		}

		return responseStatus;
	}
}
