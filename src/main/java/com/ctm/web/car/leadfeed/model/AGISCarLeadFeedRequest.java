package com.ctm.web.car.leadfeed.model;

import com.ctm.model.leadfeed.AGISLeadFeedRequest;
import com.ctm.model.leadfeed.LeadFeedData;

public class AGISCarLeadFeedRequest extends AGISLeadFeedRequest {

	/**
	 * Create a SOAP request object to send to AGIS
	 * @param messageData
	 * @param leadData
	 */
	public AGISCarLeadFeedRequest(LeadFeedData leadData) {
		super(leadData);
	}
}
