package com.ctm.web.core.model.soap.settings;

import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.web.core.web.go.xml.XmlNode;

import java.util.ArrayList;

public class SoapAggregatorConfiguration {

	private String debugPath;
	private String rootPath;
	private String mergeXsl;
	private String mergeRoot;
	private String validationFile;

	private ArrayList<SoapClientThreadConfiguration> services;
	private boolean isWriteToFile = true;
	private boolean sendCorrelationId;

	public SoapAggregatorConfiguration(){
		services = new ArrayList<SoapClientThreadConfiguration>();
	}

	public String getDebugPath() {
		return debugPath;
	}

	private void setDebugPath(String debugPath) {
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

	private void setMergeXsl(String mergeXsl) {
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

	private void setValidationFile(String validationFile) {
		this.validationFile = validationFile;
	}

	public boolean isWriteToFile() {
		return isWriteToFile;
	}
	
	public void setIsWriteToFile(boolean isWriteToFile) {
		this.isWriteToFile = isWriteToFile;
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
	public void setFromDb(ServiceConfiguration config, int styleCodeId, int providerId) {
		setDebugPath(getValue(config, styleCodeId, providerId, "debugDir", debugPath));
		setMergeRoot(getValue(config, styleCodeId, providerId, "mergeRoot", mergeRoot));
		setMergeXsl(getValue(config, styleCodeId, providerId, "mergeXsl", mergeXsl));
		setRootPath(getValue(config, styleCodeId, providerId, "configDir", rootPath));
		setValidationFile(getValue(config, styleCodeId, providerId, "validationFile", validationFile));
	}

	private String getValue(ServiceConfiguration config, int styleCodeId,
			int providerId, String key, String current) {
		// TODO remove these checks once setFromXml is removed
		if(current == null || current.isEmpty()){
			return config.getPropertyValueByKey(key, styleCodeId, providerId, Scope.GLOBAL);
		} else {
			return current;
		}
	}

	public void setSendCorrelationId(boolean sendCorrelationId) {
		this.sendCorrelationId = sendCorrelationId;
	}

	public boolean isSendCorrelationId() {
		return sendCorrelationId;
	}
}
