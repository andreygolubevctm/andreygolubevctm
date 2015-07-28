package com.ctm.services.leadfeed.life.AGIS;

import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.leadfeed.AGISLeadFeedRequest;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.model.leadfeed.life.AGISLifeLeadFeedRequest;
import com.ctm.services.leadfeed.AGISLeadFeedService;
import com.ctm.services.leadfeed.LeadFeedService.LeadType;
import org.apache.log4j.Logger;

public class AGISLifeLeadFeedService extends AGISLeadFeedService {

	private static Logger logger = Logger.getLogger(AGISLifeLeadFeedService.class.getName());

	public AGISLifeLeadFeedService(){
		super();
	}

	public AGISLeadFeedRequest getModel(LeadType leadType, LeadFeedData leadData) throws LeadFeedException {
		AGISLeadFeedRequest model = new AGISLifeLeadFeedRequest(leadData);
		model = addRequestsServiceProperties(model, leadType, leadData);
		return model;
	}

}
