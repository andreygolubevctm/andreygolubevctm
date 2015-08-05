package com.ctm.model.leadfeed.life;

import com.ctm.model.leadfeed.AGISLeadFeedRequest;
import com.ctm.model.leadfeed.LeadFeedData;

public class AGISLifeLeadFeedRequest extends AGISLeadFeedRequest {

	/**
	 * Create a SOAP request object to send to AGIS
	 * @param leadData
	 */
	public AGISLifeLeadFeedRequest(LeadFeedData leadData) {
		super(leadData);
	}
}
