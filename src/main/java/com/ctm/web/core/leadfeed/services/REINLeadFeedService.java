package com.ctm.web.core.leadfeed.services;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadType;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public abstract class REINLeadFeedService implements IProviderLeadFeedService {

	private static final Logger LOGGER = LoggerFactory.getLogger(REINLeadFeedService.class);

	/**
	 * isValidLead() tests valid lead data exists according to the lead type
	 *
	 */
	public LeadResponseStatus process(LeadType leadType, LeadFeedData leadData) throws LeadFeedException {

		if(leadType == LeadType.BEST_PRICE) {
			if (
				leadData.getProductId() != null &&
				leadData.getProductId().equalsIgnoreCase("REIN-01-01")
			) {
				return LeadResponseStatus.SUCCESS;
			} else {
				LOGGER.debug("[Lead feed] Lead failed custom validation and has been skipped");
				return LeadResponseStatus.SKIPPED;
			}
		} else {
			LOGGER.debug("[Lead feed] No lead exists for WOOL, {}", kv("leadType", leadType));
			return LeadResponseStatus.SKIPPED;
		}
	}
}
