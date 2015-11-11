package com.ctm.web.core.leadfeed.services;

import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadType;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public abstract class AILeadFeedService implements IProviderLeadFeedService {

	private static final Logger LOGGER = LoggerFactory.getLogger(AILeadFeedService.class);

	/**
	 * isQualifiedLead() tests valid lead data exists according to the lead type
	 *
	 */
	public LeadResponseStatus process(LeadType leadType, LeadFeedData leadData) throws LeadFeedException {

		if(leadType == LeadType.CALL_ME_BACK) {
			if (
				leadData.getProductId() != null &&
				(
					leadData.getProductId().equalsIgnoreCase("AI-01-01") ||
					leadData.getProductId().equalsIgnoreCase("AI-01-02") ||
					leadData.getProductId().equalsIgnoreCase("AI-01-04")
				)
			) {
				return LeadResponseStatus.SUCCESS;
			} else {
				LOGGER.debug("[Lead feed] Lead failed custom validation and has been skipped {}, {}", kv("leadType", leadType), kv("leadData", leadData));
				return LeadResponseStatus.SKIPPED;
			}
		} else {
			LOGGER.debug("[Lead feed] No lead type exists for AI {}, {}", kv("leadType", leadType), kv("leadData", leadData));
			return LeadResponseStatus.SKIPPED;
		}
	}
}
