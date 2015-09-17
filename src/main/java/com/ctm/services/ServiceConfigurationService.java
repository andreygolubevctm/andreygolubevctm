package com.ctm.services;

import com.ctm.dao.ProviderExclusionsDao;
import com.ctm.dao.ServiceConfigurationDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.model.ProviderExclusion;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.Vertical;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

public class ServiceConfigurationService {

	private static ArrayList<ServiceConfiguration> services = new ArrayList<ServiceConfiguration>();
	private static Date servicesLastAccessed;

	/**
	 * Get the all the service configuration objects
	 * Caches the service configuration object for an hour
	 *
	 * @return
	 * @throws DaoException
	 */
	public static ArrayList<ServiceConfiguration> getServiceConfigurations() throws DaoException {

		Calendar oneHourAgo = Calendar.getInstance();
		oneHourAgo.add(Calendar.HOUR, -1);

		if(services.size() == 0 || (servicesLastAccessed == null || servicesLastAccessed.before(oneHourAgo.getTime()) )){

			// Get all service configurations from Db.
			ServiceConfigurationDao serviceConfigurationDao = new ServiceConfigurationDao();
			services = serviceConfigurationDao.getAllConfigurations(ApplicationService.getServerDate());

			// Update last accessed timestamp
			servicesLastAccessed = new Date();

		}

		return services;

	}

	/**
	 * Gets the excluded providers list from the database, this array is cached in application memory for an hour.
	 *
	 * @param brandId
	 * @param verticalId
	 * @return
	 * @throws DaoException
	 */
	public static ArrayList<ProviderExclusion> getExcludedProviders(int brandId, int verticalId) throws DaoException {

		//Calendar oneHourAgo = Calendar.getInstance();
		//oneHourAgo.add(Calendar.HOUR, -1);

		//if(excludedProviders == null && (excludedProvidersLastAccessed == null || excludedProvidersLastAccessed.before(oneHourAgo.getTime()) )){

			// Get all service configurations from Db.
			ProviderExclusionsDao providerExclusionsDao = new ProviderExclusionsDao();
			return providerExclusionsDao.getForVerticalId(brandId, verticalId, ApplicationService.getServerDate());

			// Update last accessed timestamp
			//excludedProvidersLastAccessed = new Date();

		//}

		//return excludedProviders;

	}

	/**
	 * Get the service configuration object for a code. (uses page context to determine the correct brand and vertical)
	 * DO NOT USE FOR SERVER TO SERVER transactions, in order for the page context to be set correctly, this page must
	 * have been accessed via the F5 url rewriting rules.
	 *
	 * @param request
	 * @param code 'serviceCode' key in ctm.service_master
	 * @return
	 * @throws DaoException
	 * @throws ServiceConfigurationException
	 */
	public static ServiceConfiguration getServiceConfigurationForContext(HttpServletRequest request, String code) throws DaoException, ServiceConfigurationException{

		Brand brand = ApplicationService.getBrandFromRequest(request);
		String verticalCode = ApplicationService.getVerticalCodeFromRequest(request);
		Vertical vertical = brand.getVerticalByCode(verticalCode);

		return getServiceConfiguration(code, vertical.getId(), brand.getId());
	}

	/**
	 * Get the service configuration for a specific code, vertical and brand - only call this directly if you are not able to rely on F5 rewriting rules.
	 * @param code 'serviceCode' key in ctm.service_master
	 * @param verticalId
	 * @param brandId
	 * @return
	 * @throws DaoException
	 * @throws ServiceConfigurationException
	 */
	public static ServiceConfiguration getServiceConfiguration(String code, int verticalId, int brandId) throws DaoException, ServiceConfigurationException {

		getServiceConfigurations();

		ServiceConfiguration serviceConfiguration = null;
		
		for(ServiceConfiguration service : services){
			if(service.getCode().equals(code) && ((service.getVerticalId() == ConfigSetting.ALL_VERTICALS && serviceConfiguration == null) || service.getVerticalId() == verticalId)){
				serviceConfiguration = service;
			}
		}
		
		if(serviceConfiguration != null)
			return serviceConfiguration;

		throw new ServiceConfigurationException("Unable to find matching service with code "+code);

	}

	/**
	 * Work out which of the provider ids contained in the Service Configuration object are actually enabled
	 * Looks up the provider exclusions table.
	 *
	 * @param brandId
	 * @param verticalId
	 * @param serviceConfiguration
	 * @return
	 * @throws DaoException
	 */
	public static ArrayList<Integer> getEnabledProviderIdsForConfiguration(int brandId, int verticalId, ServiceConfiguration serviceConfiguration) throws DaoException{

		ArrayList<Integer> providerIds = serviceConfiguration.getProviderIds();
		ArrayList<ProviderExclusion> excludedProvidersList = getExcludedProviders(brandId, verticalId);
		ArrayList<Integer> excludedIds = new ArrayList<Integer>();

		for(ProviderExclusion exclusion : excludedProvidersList){
			excludedIds.add(exclusion.getProviderId());
		}

		providerIds.removeAll(excludedIds);

		if(providerIds.size() == 0) providerIds.add(0);

		return providerIds;
	}


	/**
	 * Clear the services array, therefore forcing the application to reload the services from the database.
	 */
	public static void clearCache(){
		services = new ArrayList<ServiceConfiguration>();
	}

}
