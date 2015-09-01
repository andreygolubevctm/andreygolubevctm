package com.ctm.services;

import com.ctm.dao.ProviderFilterDao;
import com.ctm.exceptions.TravelServiceException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.Date;
import com.ctm.dao.ProviderDao;
import com.ctm.model.Provider;
import com.ctm.exceptions.DaoException;

public class ProviderService {

	private static final Logger logger = LoggerFactory.getLogger(ProviderService.class.getName());

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
		} catch(DaoException e) {
			// ignore and move on
		}
		logger.info("@@@@ Provider Key Exists: " + (exists == true ? "YES" : "NO"));
		return exists;
	}
}
