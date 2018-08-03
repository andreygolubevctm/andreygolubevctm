package com.ctm.web.core.leadfeed.dao;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;

import java.util.ArrayList;
import java.util.Date;

/**
 * Provides a base for different versions of Lead based DAOs, to enable easier swapping and expansion.
 */
public interface LeadsDao {

    ArrayList<LeadFeedData> getLeads(int brandCodeId, String verticalCode, Integer minutes, Date serverDate) throws DaoException;
}
