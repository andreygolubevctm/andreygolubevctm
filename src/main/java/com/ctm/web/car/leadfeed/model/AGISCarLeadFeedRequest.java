package com.ctm.web.car.leadfeed.model;

import com.ctm.web.core.leadfeed.model.AGISLeadFeedRequest;
import com.ctm.web.core.leadfeed.model.LeadFeedData;

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
