package com.ctm.web.life.leadfeed.services.AGIS;

import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.AGISLeadFeedRequest;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.life.leadfeed.model.AGISLifeLeadFeedRequest;
import com.ctm.web.core.leadfeed.services.AGISLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadType;

public class AGISLifeLeadFeedService extends AGISLeadFeedService {

	public AGISLifeLeadFeedService(){
		super();
	}

	public AGISLeadFeedRequest getModel(LeadType leadType, LeadFeedData leadData) throws LeadFeedException {
		AGISLeadFeedRequest model = new AGISLifeLeadFeedRequest(leadData);
		model = addRequestsServiceProperties(model, leadType, leadData);
		return model;
	}

}
