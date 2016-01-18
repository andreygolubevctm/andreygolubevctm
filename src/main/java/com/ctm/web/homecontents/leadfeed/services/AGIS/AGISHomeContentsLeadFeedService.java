package com.ctm.web.homecontents.leadfeed.services.AGIS;

import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.AGISLeadFeedRequest;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.homecontents.leadfeed.model.AGISHomeContentsLeadFeedRequest;
import com.ctm.web.core.leadfeed.services.AGISLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadType;

public class AGISHomeContentsLeadFeedService extends AGISLeadFeedService {

	public AGISHomeContentsLeadFeedService(){
		super();
	}

	public AGISLeadFeedRequest getModel(LeadType leadType, LeadFeedData leadData) throws LeadFeedException {
		AGISLeadFeedRequest model = new AGISHomeContentsLeadFeedRequest(leadData);
		model = addRequestsServiceProperties(model, leadType, leadData);
		return model;
	}
}
