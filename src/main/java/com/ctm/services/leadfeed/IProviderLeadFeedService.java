package com.ctm.services.leadfeed;

import com.ctm.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.LeadFeedService;

/**
 * Created by msmerdon on 28/04/2015.
 */
public interface IProviderLeadFeedService {

    public LeadFeedService.LeadResponseStatus process(LeadFeedService.LeadType leadType, LeadFeedData leadData) throws LeadFeedException;
}
