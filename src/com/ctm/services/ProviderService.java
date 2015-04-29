package com.ctm.services;

import org.apache.log4j.Logger;
import java.util.Date;
import com.ctm.dao.ProviderDao;
import com.ctm.model.Provider;
import com.ctm.exceptions.DaoException;

public class ProviderService {

	private static Logger logger = Logger.getLogger(ProviderService.class.getName());

	private static ProviderDao dao = new ProviderDao();

	public ProviderService() {}

	public static Provider getProvider(Integer providerId, Date serverDate) throws DaoException{
		return dao.getById(providerId, serverDate);
	}

	public static Provider getProvider(String providerCode, Date serverDate) throws DaoException{
		return dao.getByCode(providerCode, serverDate);
	}
}
