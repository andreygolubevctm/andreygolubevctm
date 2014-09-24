package com.ctm.model.settings;

import java.util.ArrayList;

import com.ctm.model.settings.ServiceConfigurationProperty.Scope;
import com.disc_au.web.go.xml.XmlNode;

public class SoapAggregatorConfiguration {

	private String debugPath;
	private String rootPath;
	private String mergeXsl;
	private String mergeRoot;
	private String validationFile;

	private ArrayList<SoapClientThreadConfiguration> services;

	public SoapAggregatorConfiguration(){
		services = new ArrayList<SoapClientThreadConfiguration>();
	}

	public String getDebugPath() {
		return debugPath;
	}

	public void setDebugPath(String debugPath) {
		this.debugPath = debugPath;
	}

	public String getRootPath() {
		return rootPath;
	}

	public void setRootPath(String rootPath) {
		this.rootPath = rootPath;
	}

	public String getMergeXsl() {
		return mergeXsl;
	}

	public void setMergeXsl(String mergeXsl) {
		this.mergeXsl = mergeXsl;
	}

	public String getMergeRoot() {
		return mergeRoot;
	}

	public void setMergeRoot(String mergeRoot) {
		this.mergeRoot = mergeRoot;
	}

	public ArrayList<SoapClientThreadConfiguration> getServices() {
		return services;
	}

	public void setServices(ArrayList<SoapClientThreadConfiguration> services) {
		this.services = services;
	}

	public String getValidationFile() {
		return validationFile;
	}

	public void setValidationFile(String validationFile) {
		this.validationFile = validationFile;
	}

	/**
	 * Set the configuration object from legacy XML configuration files
	 *
	 * @param config
	 * @param configRoot
	 */
	public void setFromXml(XmlNode config){
		setDebugPath((String) config.get("debug-dir/text()"));
		setMergeRoot((String) config.get("merge-root/text()"));
		setMergeXsl((String) config.get("merge-xsl/text()"));
		setRootPath((String) config.get("config-dir/text()"));
		setValidationFile((String) config.get("validation-file/text()"));
	}

	/**
	 * Set the configuration object from Database configuration object
	 *
	 * @param config
	 * @param providerId
	 * @param styleCodeId
	 * @param configRoot
	 */
	public void setFromDb(ServiceConfiguration config, int styleCodeId, int providerId){
		setDebugPath(config.getPropertyValueByKey("debugDir", styleCodeId, providerId, Scope.GLOBAL));
		setMergeRoot(config.getPropertyValueByKey("mergeRoot", styleCodeId, providerId, Scope.GLOBAL));
		setMergeXsl(config.getPropertyValueByKey("mergeXsl", styleCodeId, providerId, Scope.GLOBAL));
		setRootPath(config.getPropertyValueByKey("configDir", styleCodeId, providerId, Scope.GLOBAL));
		setValidationFile(config.getPropertyValueByKey("validationFile", styleCodeId, providerId, Scope.GLOBAL));
	}


}
