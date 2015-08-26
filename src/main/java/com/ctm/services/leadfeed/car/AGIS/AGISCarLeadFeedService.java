package com.ctm.services.leadfeed.car.AGIS;

import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.leadfeed.AGISLeadFeedRequest;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.model.leadfeed.car.AGISCarLeadFeedRequest;
import com.ctm.services.leadfeed.AGISLeadFeedService;
import com.ctm.services.leadfeed.LeadFeedService.LeadType;

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
