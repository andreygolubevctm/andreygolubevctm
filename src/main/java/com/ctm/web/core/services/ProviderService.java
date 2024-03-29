package com.ctm.web.core.services;

import com.ctm.web.core.dao.ProviderFilterDao;

import java.util.ArrayList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;
import com.ctm.web.core.dao.ProviderDao;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.core.exceptions.DaoException;

import java.util.List;

public class ProviderService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ProviderService.class);

	private static ProviderDao dao = new ProviderDao();

	public ProviderService() {}

	public static Provider getProvider(Integer providerId, Date serverDate) throws DaoException{
		return dao.getById(providerId, serverDate);
	}

	public static Provider getProvider(String providerCode, Date serverDate) throws DaoException{
		return dao.getByCode(providerCode, serverDate);
	}

	public static Boolean providerKeyExists(String providerKey) {
		Boolean exists = false;
		ProviderFilterDao providerFilterDAO = new ProviderFilterDao();
		try {
			String providerCode = providerFilterDAO.getProviderDetails(providerKey);
			if(providerCode != null && !providerCode.equalsIgnoreCase("invalid")) {
				exists = true;
			}
		} catch(Exception e) {
			// ignore and move on
		}

		return exists;
	}

	public static Boolean authTokenExists(String providerKey) {
		Boolean exists = false;
		ProviderFilterDao providerFilterDAO = new ProviderFilterDao();
		try {
			List<String> providerCode = providerFilterDAO.getProviderDetailsByAuthToken(providerKey);
			if(!providerCode.isEmpty()) {
				exists = true;
			}
		} catch(Exception e) {
			// ignore and move on
		}

		return exists;
	}

	public static List<String> getProvidersByAuthToken(String authToken) {
		List<String> providerCodes = null;
		ProviderFilterDao providerFilterDAO = new ProviderFilterDao();
		try {
			providerCodes = providerFilterDAO.getProviderDetailsByAuthToken(authToken);
		} catch(Exception e) {
			LOGGER.debug("Failed to load providers with authToken '" + authToken + "'", e);
		}

		return providerCodes;
	}
}
