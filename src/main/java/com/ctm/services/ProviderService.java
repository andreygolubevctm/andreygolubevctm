package com.ctm.services;

import com.ctm.dao.ProviderFilterDao;
import com.ctm.exceptions.TravelServiceException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.Date;
import com.ctm.dao.ProviderDao;
import com.ctm.model.Provider;
import com.ctm.exceptions.DaoException;

import static com.ctm.logging.LoggingArguments.kv;

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
		} catch(DaoException e) {
			// ignore and move on
		}
		LOGGER.debug("Provider key already exists {},{}", kv("providerKey", providerKey), kv("exists", exists));
		return exists;
	}
}
