package com.ctm.model.leadfeed.homecontents;

import com.ctm.model.leadfeed.AGISLeadFeedRequest;
import com.ctm.model.leadfeed.LeadFeedData;

public class AGISHomeContentsLeadFeedRequest extends AGISLeadFeedRequest {

	/**
	 * Create a SOAP request object to send to AGIS
	 * @param messageData
	 * @param leadData
	 */
	public AGISHomeContentsLeadFeedRequest(LeadFeedData leadData) {
		super(leadData);
	}
}
