package com.ctm.web.car.leadfeed.services.AGIS;

import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.AGISLeadFeedRequest;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.car.leadfeed.model.AGISCarLeadFeedRequest;
import com.ctm.web.core.leadfeed.services.AGISLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadType;

public class AGISCarLeadFeedService extends AGISLeadFeedService {

	public AGISCarLeadFeedService(){
		super();
	}

	public AGISLeadFeedRequest getModel(LeadType leadType, LeadFeedData leadData) throws LeadFeedException {
		AGISLeadFeedRequest model = new AGISCarLeadFeedRequest(leadData);
		model = addRequestsServiceProperties(model, leadType, leadData);
		return model;
	}

}
