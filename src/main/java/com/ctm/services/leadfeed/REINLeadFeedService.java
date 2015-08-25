package com.ctm.services.leadfeed;

import org.slf4j.Logger; import org.slf4j.LoggerFactory;
import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.leadfeed.LeadFeedService.LeadType;
import com.ctm.services.leadfeed.LeadFeedService.LeadResponseStatus;

public abstract class REINLeadFeedService implements IProviderLeadFeedService {

	private static final Logger logger = LoggerFactory.getLogger(REINLeadFeedService.class.getName());

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
				logger.debug("[Lead feed] Lead failed custom validation and has been skipped");
				return LeadResponseStatus.SKIPPED;
			}
		} else {
			logger.debug("[Lead feed] No " + leadType + " lead exists for WOOL");
			return LeadResponseStatus.SKIPPED;
		}
	}
}
