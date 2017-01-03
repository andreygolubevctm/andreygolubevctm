package com.ctm.web.car.leadfeed.model;

import com.ctm.web.core.leadfeed.model.AGISLeadFeedRequest;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.LeadFeedService;

public class AGISCarLeadFeedRequest extends AGISLeadFeedRequest {

	/**
	 * Create a SOAP request object to send to AGIS
	 * @param messageData
	 * @param leadData
	 * @param leadType
	 */
	public AGISCarLeadFeedRequest(LeadFeedData leadData, LeadFeedService.LeadType leadType) {
		super(leadData, leadType);
	}
}
