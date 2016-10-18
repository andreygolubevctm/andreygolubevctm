package com.ctm.web.homecontents.leadfeed.model;

import com.ctm.web.core.leadfeed.model.AGISLeadFeedRequest;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.LeadFeedService;

public class AGISHomeContentsLeadFeedRequest extends AGISLeadFeedRequest {

	/**
	 * Create a SOAP request object to send to AGIS
	 * @param messageData
	 * @param leadData
	 */
	public AGISHomeContentsLeadFeedRequest(LeadFeedData leadData, LeadFeedService.LeadType leadType) {
		super(leadData, leadType);
	}
}
