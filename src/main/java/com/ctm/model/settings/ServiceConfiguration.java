package com.ctm.model.settings;

import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.model.settings.ServiceConfigurationProperty.Scope;

public class ServiceConfiguration {

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(ServiceConfiguration.class.getName());

	private int id;
	private int verticalId;
	private String code;
	private String description;
	private ArrayList<ServiceConfigurationProperty> properties;

	public ServiceConfiguration(){
		properties = new ArrayList<ServiceConfigurationProperty>();
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public ArrayList<ServiceConfigurationProperty> getProperties() {
		return properties;
	}

	public void setProperties(ArrayList<ServiceConfigurationProperty> properties) {
		this.properties = properties;
	}

	public void addProperty(ServiceConfigurationProperty property){
		this.properties.add(property);
	}

	public int getVerticalId() {
		return verticalId;
	}

	public void setVerticalId(int verticalId) {
		this.verticalId = verticalId;
	}

	/**
	 *
	 * @param scope
	 * @return
	 */
	public ArrayList<ServiceConfigurationProperty> getPropertyByScope(Scope scope){
		ArrayList<ServiceConfigurationProperty> filteredProperties = new ArrayList<ServiceConfigurationProperty>();

		for(ServiceConfigurationProperty prop : properties){
			if(prop.getScope() == scope){
				filteredProperties.add(prop);
			}
		}
		return filteredProperties;
	}

	public ArrayList<ServiceConfigurationProperty> getGlobalProperties(){
		return getPropertyByScope(Scope.GLOBAL);
	}

	public ArrayList<ServiceConfigurationProperty> getServiceProperties(){
		return getPropertyByScope(Scope.SERVICE);
	}

	public ArrayList<ServiceConfigurationProperty> getGatewayProperties(){
		return getPropertyByScope(Scope.GATEWAY);
	}

	/**
	 *
	 * @param key
	 * @param styleCodeId
	 * @param providerId
	 * @param scope
	 * @return
	 */
	public ServiceConfigurationProperty getPropertyByKey(String key, int styleCodeId, int providerId, Scope scope){

		ArrayList<ServiceConfigurationProperty> matches = new ArrayList<ServiceConfigurationProperty>();

		// Find best match... look for specific match for environment, stylecode, provider or fall back
		for(ServiceConfigurationProperty prop : properties){

			// For for a key and scope match.
			if(prop.getScope() == scope && prop.getKey().equalsIgnoreCase(key) ){

				// Look for a specific provider or fall back provider match
				if(prop.getProviderId() == providerId || prop.getProviderId() == ServiceConfigurationProperty.ALL_PROVIDERS){

					// Look for a specific stylecode or a fall back style code match
					if(prop.getStyleCodeId() == styleCodeId || prop.getStyleCodeId() == ConfigSetting.ALL_BRANDS){
						matches.add(prop);
					}

				}

			}
		}

		// if more than one match, then need to prioritise which is the best one.
		if(matches.size() > 0){

			ServiceConfigurationProperty existingProperty = null;
			for(ServiceConfigurationProperty property : matches){

				if(existingProperty != null){

					if(existingProperty.getProviderId() == ServiceConfigurationProperty.ALL_PROVIDERS && property.getProviderId() != ServiceConfigurationProperty.ALL_PROVIDERS){

						// the new setting has more specific provider, use it instead
						existingProperty = property;

					}else{

						// Settings are equal on environment, now check brand
						if(existingProperty.getStyleCodeId() == ConfigSetting.ALL_BRANDS && property.getStyleCodeId() != ConfigSetting.ALL_BRANDS){

							// The new setting has a more specific brand, use it instead.
							existingProperty = property;

						}else{

							if(existingProperty.getEnvironmentCode().equals(ConfigSetting.ALL_ENVIRONMENTS) && property.getEnvironmentCode().equalsIgnoreCase(ConfigSetting.ALL_ENVIRONMENTS) == false){

								// The new setting has a more specific environment, use it instead.
								existingProperty = property;

							}
						}

					}

				}else{
					existingProperty = property;
				}

			}

			return existingProperty;
		}


		return null;
	}

	/**
	 *
	 * @param key
	 * @param styleCodeId
	 * @param providerId
	 * @param scope
	 * @return
	 */
	public String getPropertyValueByKey(String key, int styleCodeId, int providerId, Scope scope){
		ServiceConfigurationProperty property = getPropertyByKey(key, styleCodeId, providerId, scope);
		if(property != null) return property.getValue();
		return null;
	}

	/**
	 *
	 * @return
	 */
	public ArrayList<Integer> getProviderIds() {
		ArrayList<Integer> tempProviderIds = new ArrayList<Integer>();

		for(ServiceConfigurationProperty prop : getServiceProperties()){
			int providerId = prop.getProviderId();
			if(providerId > 0 && tempProviderIds.indexOf(providerId) == -1){
				tempProviderIds.add(providerId);
			}
		}

		return tempProviderIds;
	}

	public ArrayList<Integer> getAllProviderIds() {
		ArrayList<Integer> tempProviderIds = new ArrayList<Integer>();

		for(ServiceConfigurationProperty prop : getServiceProperties()){
			int providerId = prop.getProviderId();
			if(providerId > 0 && tempProviderIds.indexOf(providerId) == -1){
				tempProviderIds.add(providerId);
			}
		}

		if(tempProviderIds.size() == 0){
			tempProviderIds.add(0);
		}

		return tempProviderIds;
	}

	/**
	 *
	 * @return
	 */
	public boolean isProviderEnabledForBrand(int providerId, int styleCodeId){
		String propValue = getPropertyValueByKey("status", styleCodeId, providerId, Scope.SERVICE);
		if(propValue != null && propValue.equals("Y")){
			return true;
		}
		return false;
	}

}
