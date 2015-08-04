package com.ctm.services.leadfeed.homecontents.AGIS;

import org.apache.log4j.Logger;

import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.leadfeed.AGISLeadFeedRequest;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.model.leadfeed.homecontents.AGISHomeContentsLeadFeedRequest;
import com.ctm.services.leadfeed.AGISLeadFeedService;
import com.ctm.services.leadfeed.LeadFeedService.LeadType;

public class AGISHomeContentsLeadFeedService extends AGISLeadFeedService {

	private static Logger logger = Logger.getLogger(AGISHomeContentsLeadFeedService.class.getName());

	public AGISHomeContentsLeadFeedService(){
		super();
	}

	public AGISLeadFeedRequest getModel(LeadType leadType, LeadFeedData leadData) throws LeadFeedException {
		AGISLeadFeedRequest model = new AGISHomeContentsLeadFeedRequest(leadData);
		model = addRequestsServiceProperties(model, leadType, leadData);
		return model;
	}
}
