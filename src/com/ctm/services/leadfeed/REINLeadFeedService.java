package com.ctm.services.leadfeed;

import org.apache.log4j.Logger;
import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.leadfeed.LeadFeedService.LeadType;
import com.ctm.services.leadfeed.LeadFeedService.LeadResponseStatus;

public abstract class REINLeadFeedService implements IProviderLeadFeedService {

	private static Logger logger = Logger.getLogger(REINLeadFeedService.class.getName());

	/**
	 * isValidLead() tests valid lead data exists according to the lead type
	 *
	 */
	public LeadResponseStatus process(LeadType leadType, LeadFeedData leadData) throws LeadFeedException {

		if(
			leadType == LeadType.BEST_PRICE &&
			leadData.getProductId() != null &&
			leadData.getProductId().equalsIgnoreCase("REIN-01-01")
		) {
			return LeadResponseStatus.SUCCESS;
		} else {
			logger.debug("[Lead feed] Lead failed custom validation and has been skipped");
			return LeadResponseStatus.SKIPPED;
		}
	}
}
