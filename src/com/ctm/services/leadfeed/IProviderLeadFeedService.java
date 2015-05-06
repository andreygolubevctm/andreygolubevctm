package com.ctm.services.leadfeed;

import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.leadfeed.LeadFeedData;

/**
 * Created by msmerdon on 28/04/2015.
 */
public interface IProviderLeadFeedService {

    public LeadFeedService.LeadResponseStatus process(LeadFeedService.LeadType leadType, LeadFeedData leadData) throws LeadFeedException;
}
