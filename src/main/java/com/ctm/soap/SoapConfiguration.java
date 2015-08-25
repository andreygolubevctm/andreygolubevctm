package com.ctm.soap;

import java.util.ArrayList;

import org.slf4j.Logger; import org.slf4j.LoggerFactory;
import org.xml.sax.SAXException;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.model.settings.SoapAggregatorConfiguration;
import com.ctm.model.settings.SoapClientThreadConfiguration;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ApplicationService;
import com.ctm.services.EnvironmentService;
import com.ctm.services.ServiceConfigurationService;
import com.ctm.services.EnvironmentService.Environment;
import com.disc_au.web.go.xml.XmlNode;
import com.disc_au.web.go.xml.XmlParser;

public class SoapConfiguration {

	private static final Logger logger = LoggerFactory.getLogger(SoapConfiguration.class.getName());

	public static void setUpConfigurationFromDatabase(String configDbKey , SoapAggregatorConfiguration configuration, int styleCodeId,
			String verticalCode, String manuallySetProviderIds, String authToken) {
		// If the configDbKey is specified, attempt to load the config from the database and/or config xml.
		if(configDbKey != null && !configDbKey.isEmpty()){
			try {
				Brand brand = ApplicationService.getBrandById(styleCodeId);
				Vertical vertical = brand.getVerticalByCode(verticalCode);
				if(vertical == null){
					logger.error("vertical is not set");
					return;
				}

				ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration(configDbKey, vertical.getId(), brand.getId());
				configuration.setFromDb(serviceConfig, styleCodeId, 0);
				setUpIsWriteToFile(serviceConfig, styleCodeId, 0, configuration);

				// If the tag has specific partner ids specified use that, otherwise load from the configuration object.
				ArrayList<Integer> providerIds = new ArrayList<Integer>();

				if(!manuallySetProviderIds.isEmpty()){
					for(String item: manuallySetProviderIds.split(",")){
						providerIds.add(Integer.parseInt(item));
					}
				} else{
					// Ensure to only use enabled partners
					providerIds = ServiceConfigurationService.getEnabledProviderIdsForConfiguration(brand.getId(),  vertical.getId(), serviceConfig);
				}

				for(Integer providerId : providerIds){
					SoapClientThreadConfiguration item = new SoapClientThreadConfiguration();
					if (serviceConfig.isProviderEnabledForBrand(providerId, brand.getId())) {
						item.setFromDb(serviceConfig, providerId, styleCodeId, configuration.getRootPath());

						if (EnvironmentService.getEnvironment() == Environment.NXS && authToken != null) {
							String storedAuthToken = serviceConfig.getPropertyValueByKey("authToken", styleCodeId, providerId, Scope.SERVICE);

							if (storedAuthToken != null) {
								if (storedAuthToken.equals(authToken)) {
									configuration.getServices().add(item);

								}
							}
						} else {
							// Do normal, no auth needed.
							configuration.getServices().add(item);
						}
					}
				}


			} catch (DaoException | ServiceConfigurationException e) {
				logger.error("Unable to load Database configuration or ServiceConfiguration exception", e);
			}
		}
	}

	private static void setUpIsWriteToFile(ServiceConfiguration config,
			int styleCodeId, int providerId, SoapAggregatorConfiguration configuration) {
		String isWriteToFileValue = config.getPropertyValueByKey("isWriteToFile", styleCodeId, providerId, Scope.GLOBAL);
		if(isWriteToFileValue != null && !isWriteToFileValue.isEmpty()){
			configuration.setIsWriteToFile(isWriteToFileValue.equals("Y"));
		}
	}

	/**
	 * Sets the configuration xml.
	 * @param parser
	 *
	 * @param config the new configuration xml
	 * @throws SAXException thrown as a result of an error parsing the config xml
	 */
	public static SoapAggregatorConfiguration setUpConfigurationFromXml(String configXmlString, XmlParser parser) throws SAXException {
		SoapAggregatorConfiguration configuration = new SoapAggregatorConfiguration();
		// Load up the configuration
		if(!configXmlString.isEmpty()) {
			XmlNode config = parser.parse(configXmlString);

			configuration.setFromXml(config);

			for (XmlNode service : config.getChildNodes("service")) {
				SoapClientThreadConfiguration item = new SoapClientThreadConfiguration();
				item.setFromXml(service, configuration.getRootPath());
				configuration.getServices().add(item);
			}
		}

		return configuration;
	}

}
