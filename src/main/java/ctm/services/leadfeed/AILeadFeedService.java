package com.ctm.services.leadfeed;

import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.leadfeed.LeadFeedService.LeadType;
import com.ctm.services.leadfeed.LeadFeedService.LeadResponseStatus;
import org.apache.log4j.Logger;

public abstract class AILeadFeedService implements IProviderLeadFeedService {

	private static Logger logger = Logger.getLogger(AILeadFeedService.class.getName());

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
				logger.debug("[Lead feed] Lead failed custom validation and has been skipped");
				return LeadResponseStatus.SKIPPED;
			}
		} else {
			logger.debug("[Lead feed] No " + leadType + " lead exists for AI");
			return LeadResponseStatus.SKIPPED;
		}
	}
}
