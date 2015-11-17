package com.ctm.web.core.leadfeed.services;

import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;

/**
 * Created by msmerdon on 28/04/2015.
 */
public interface IProviderLeadFeedService {

    public LeadFeedService.LeadResponseStatus process(LeadFeedService.LeadType leadType, LeadFeedData leadData) throws LeadFeedException;
}
