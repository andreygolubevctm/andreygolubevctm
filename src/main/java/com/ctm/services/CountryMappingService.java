package com.ctm.services;

import com.ctm.dao.CountryMappingDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.CountryMapping;
import com.ctm.model.session.SessionData;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.utils.RequestUtils;
import com.disc_au.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;

public class CountryMappingService {
	private static final Logger logger = LoggerFactory.getLogger(CountryMappingService.class);
    private final SessionDataService sessionDataService = new SessionDataService();
    private static final long serialVersionUID = 69L;


    /**
     *
     */
    public Data getCountryMapping(Data data) throws DaoException {

		String test = data.getString("travel/destination");
        CountryMappingDao countryMappingDao = new CountryMappingDao();

		ArrayList<CountryMapping> mappedCountries =  countryMappingDao.getMapping(data.getString("travel/destination"));

		String partnerXpath;

		for (CountryMapping partnerEntry : mappedCountries) {
			partnerXpath = getProviderXPath(partnerEntry);

			if (partnerEntry.getHasCountries() == 'Y') {
				data.put(partnerXpath + "countries", partnerEntry.getSelectedCountries());
			}

			if (partnerEntry.getHasRegions() == 'Y') {
				data.put(partnerXpath + "regions", partnerEntry.getSelectedRegions());
			}

			if (partnerEntry.getHasHandoverValues() == 'Y') {
				data.put(partnerXpath + "handoverMapping", partnerEntry.getHandoverMappings());
			}
		}
		return data;
	}

	/**
	 * Build the xpaths for the mapped countries and/or regions
	 */
	private String getProviderXPath(CountryMapping partnerEntry) {
		String partnerXpath = "travel/mappedCountries/" + partnerEntry.getProviderCode() + "/";

		if (partnerEntry.getProductGroup() > 0 && partnerEntry.getProviderCode().equals("TSAV")) {
			String groupName = "";
			switch (partnerEntry.getProductGroup()) {
				case 1:
					groupName = "comprehensive";
					break;
				case 2:
					groupName = "essentials";
					break;
				case 3:
					groupName = "elements";
					break;
			}
			partnerXpath += groupName + "/";
		}

		return partnerXpath;
	}

    /**
     * Get the details from the data bucket for this current transaction
     */
    private Data getData(HttpServletRequest request, long transactionId) throws SessionException {
        SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
        if (sessionData == null) {
            throw new SessionException("session has expired");
        }

        return sessionData.getSessionDataForTransactionId(transactionId);
    }
}
