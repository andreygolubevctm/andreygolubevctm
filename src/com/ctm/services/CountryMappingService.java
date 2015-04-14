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
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;

public class CountryMappingService {
    private static final Logger logger = Logger.getLogger(CountryMappingService.class);
    private Data data;
    private final SessionDataService sessionDataService = new SessionDataService();
    private static final long serialVersionUID = 69L;

    /**
     *
     */
    public void getCountryMapping(HttpServletRequest request, String selectedCountries) throws DaoException {

        CountryMappingDao countryMappingDao = new CountryMappingDao();
		ArrayList<CountryMapping> mappedCountries =  countryMappingDao.getMapping(selectedCountries);
		try {
			long transactionId = RequestUtils.getTransactionIdFromRequest(request);

			// grab the databucket details
			data = getData(request, transactionId);
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request); // grab this current page's settings
			Vertical v = pageSettings.getVertical();
			String vertical = v.getType().toString().toLowerCase();

            if(data != null) {
				String partnerXpath;

				for (CountryMapping partnerEntry : mappedCountries) {
					partnerXpath = getProviderXPath(vertical, partnerEntry);

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
			}
		} catch (SessionException | ConfigSettingException e) {
			logger.error(e);
		}

	}

	/**
	 * Build the xpaths for the mapped countries and/or regions
	 */
	private String getProviderXPath(String vertical, CountryMapping partnerEntry) {
		String partnerXpath = vertical+"/mappedCountries/" + partnerEntry.getProviderCode() + "/";

		if (partnerEntry.getProductGroup() > 0 && partnerEntry.getProviderCode().equals("TSAV") && vertical.equals("travel")) {
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
