package com.ctm.web.life.leadfeed.model;

import com.ctm.web.core.leadfeed.model.AGISLeadFeedRequest;
import com.ctm.web.core.leadfeed.model.LeadFeedData;

public class AGISLifeLeadFeedRequest extends AGISLeadFeedRequest {

	/**
	 * Create a SOAP request object to send to AGIS
	 * @param leadData
	 */
	public AGISLifeLeadFeedRequest(LeadFeedData leadData) {
		super(leadData);
	}
}
