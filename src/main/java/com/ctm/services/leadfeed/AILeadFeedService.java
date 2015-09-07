package com.ctm.services.leadfeed;

import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.leadfeed.LeadFeedService.LeadType;
import com.ctm.services.leadfeed.LeadFeedService.LeadResponseStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.logging.LoggingArguments.kv;

public abstract class AILeadFeedService implements IProviderLeadFeedService {

	private static final Logger logger = LoggerFactory.getLogger(AILeadFeedService.class.getName());

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
				logger.debug("[Lead feed] Lead failed custom validation and has been skipped {}, {}", kv("leadType", leadType), kv("leadData", leadData));
				return LeadResponseStatus.SKIPPED;
			}
		} else {
			logger.debug("[Lead feed] No lead type exists for AI {}, {}", kv("leadType", leadType), kv("leadData", leadData));
			return LeadResponseStatus.SKIPPED;
		}
	}
}
