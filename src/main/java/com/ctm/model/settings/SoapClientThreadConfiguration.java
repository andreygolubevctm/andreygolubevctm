package com.ctm.model.settings;

import com.ctm.model.settings.ServiceConfigurationProperty.Scope;
import com.disc_au.web.go.xml.XmlNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.URI;
import java.net.URL;

public class SoapClientThreadConfiguration {
	private static final Logger LOGGER = LoggerFactory.getLogger(SoapClientThreadConfiguration.class);

	private String name;
	private String type;
	private String url;
	private String user;
	private String password;
	private String soapAction;
	private String outboundXsl;
	private String maskReqInXSL;
	private String maskReqOutXSL;
	private String maskRespInXSL;
	private String outboundParms;
	private String inboundXSL;
	private String inboundParms;
	private String method;
	private int timeoutMillis;
	private String sslNoHostVerify;
	private String clientCert;
	private String clientCertPass;
	private String unescapeElement;
	private String extractElement;
	private String contentType;
	private String encoding;
	private String accept;
	private int localPort = -1;

	/**
	 * This class holds the configuration properties for the SOAP Client thread class
	 *
	 */
	public SoapClientThreadConfiguration() {
	}

	public SoapClientThreadConfiguration(int localPort){
		this.localPort = localPort;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = overrideUrlPort(url, localPort);
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getSoapAction() {
		return soapAction;
	}

	public void setSoapAction(String soapAction) {
		this.soapAction = soapAction;
	}

	public String getOutboundXsl() {
		return outboundXsl;
	}

	public void setOutboundXsl(String outboundXsl) {
		this.outboundXsl = outboundXsl;
	}

	public String getMaskReqInXSL() {
		return maskReqInXSL;
	}

	public void setMaskReqInXSL(String maskReqInXSL) {
		this.maskReqInXSL = maskReqInXSL;
	}

	public String getMaskReqOutXSL() {
		return maskReqOutXSL;
	}

	public void setMaskReqOutXSL(String maskReqOutXSL) {
		this.maskReqOutXSL = maskReqOutXSL;
	}

	public String getMaskRespInXSL() {
		return maskRespInXSL;
	}

	public void setMaskRespInXSL(String maskRespInXSL) {
		this.maskRespInXSL = maskRespInXSL;
	}

	public String getOutboundParms() {
		return outboundParms;
	}

	public void setOutboundParms(String outboundParms) {
		this.outboundParms = outboundParms;
	}

	public String getInboundXSL() {
		return inboundXSL;
	}

	public void setInboundXSL(String inboundXSL) {
		this.inboundXSL = inboundXSL;
	}

	public String getInboundParms() {
		return inboundParms;
	}

	public void setInboundParms(String inboundParms) {
		this.inboundParms = inboundParms;
	}

	public String getMethod() {
		return method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	public int getTimeoutMillis() {
		return timeoutMillis;
	}

	public void setTimeoutMillis(int timeoutMillis) {
		this.timeoutMillis = timeoutMillis;
	}

	public String getSslNoHostVerify() {
		return sslNoHostVerify;
	}

	public void setSslNoHostVerify(String sslNoHostVerify) {
		this.sslNoHostVerify = sslNoHostVerify;
	}

	public String getClientCert() {
		return clientCert;
	}

	public void setClientCert(String clientCert) {
		this.clientCert = clientCert;
	}

	public String getClientCertPass() {
		return clientCertPass;
	}

	public void setClientCertPass(String clientCertPass) {
		this.clientCertPass = clientCertPass;
	}

	public String getUnescapeElement() {
		return unescapeElement;
	}

	public void setUnescapeElement(String unescapeElement) {
		this.unescapeElement = unescapeElement;
	}

	public String getExtractElement() {
		return extractElement;
	}

	public void setExtractElement(String extractElement) {
		this.extractElement = extractElement;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public String getEncoding() {
		return encoding;
	}

	public void setEncoding(String encoding) {
		this.encoding = encoding;
	}

	public String getAccept() {
		return accept;
	}

	public void setAccept(String accept) {
		this.accept = accept;
	}

	/**
	 * Set the configuration object from legacy XML configuration files
	 *
	 * @param config
	 * @param configRoot
	 */
	public void setFromXml(XmlNode config, String configRoot){

		setName(config.getAttribute("name"));
		setType(config.getAttribute("type"));
		setUrl((String) config.get("soap-url/text()"));
		setUser((String) config.get("soap-user/text()"));
		setPassword((String) config.get("soap-password/text()"));
		setSoapAction((String) config.get("soap-action/text()"));
		setOutboundXsl(configRoot + '/'+ (String) config.get("outbound-xsl/text()"));
		setOutboundParms((String) config.get("outbound-xsl-parms/text()"));
		setInboundXSL(configRoot + '/' + (String) config.get("inbound-xsl/text()"));
		setInboundParms((String) config.get("inbound-xsl-parms/text()"));

		String maskInXsl = (String) config.get("maskRequestIn-xsl/text()");
		String maskOutXsl = (String) config.get("maskRequestOut-xsl/text()");
		String maskRespInXslConfig = (String) config.get("maskRespIn-xsl/text()");

		if(maskInXsl != null) {
			setMaskReqInXSL(configRoot + '/' + maskInXsl);
		}
		if(maskOutXsl != null) {
			setMaskReqOutXSL(configRoot + '/' + maskOutXsl);
		}

		if(maskRespInXslConfig != null) {
			setMaskRespInXSL(configRoot + '/' + maskRespInXslConfig);
		}

		if( config.hasChild("soap-method") ) {
			setMethod((String) config.get("soap-method/text()"));
		}

		String timeout = (String) config.get("timeoutMillis/text()");
		setTimeoutMillis(Integer.parseInt(timeout));


		setSslNoHostVerify((String) config.get("ssl-no-host-verify/text()"));
		setClientCert((String) config.get("ssl-client-certificate/text()"));
		setClientCertPass((String) config.get("ssl-client-certificate-password/text()"));
		setUnescapeElement((String) config.get("unescape-element/text()"));
		setExtractElement((String) config.get("extract-element/text()"));
		setContentType((String) config.get("content-type/text()"));
		setEncoding((String) config.get("encoding/text()"));
		setAccept((String) config.get("accept/text()"));
	}

	/**
	 * Set the configuration object from Database configuration object
	 *
	 * @param config
	 * @param providerId
	 * @param styleCodeId
	 * @param configRoot
	 */
	public void setFromDb(ServiceConfiguration config, Integer providerId, int styleCodeId, String configRoot) {
		setName(config.getPropertyValueByKey("serviceName", styleCodeId, providerId, Scope.SERVICE));
		setType(config.getPropertyValueByKey("serviceType", styleCodeId, providerId, Scope.SERVICE));
		setUrl(config.getPropertyValueByKey("soapUrl", styleCodeId, providerId, Scope.SERVICE));
		setUser(config.getPropertyValueByKey("soapUser", styleCodeId, providerId, Scope.SERVICE));
		setPassword(config.getPropertyValueByKey("soapPassword", styleCodeId, providerId, Scope.SERVICE));
		setSoapAction(config.getPropertyValueByKey("soapAction", styleCodeId, providerId, Scope.SERVICE));
		setOutboundXsl(configRoot + '/'+ config.getPropertyValueByKey("outboundXsl", styleCodeId, providerId, Scope.SERVICE));
		setOutboundParms(config.getPropertyValueByKey("outboundXslParms", styleCodeId, providerId, Scope.SERVICE));
		setInboundXSL(configRoot + '/' + config.getPropertyValueByKey("inboundXsl", styleCodeId, providerId, Scope.SERVICE));
		setInboundParms(config.getPropertyValueByKey("inboundXslParms", styleCodeId, providerId, Scope.SERVICE));

		String maskInXsl = config.getPropertyValueByKey("maskRequestInXsl", styleCodeId, providerId, Scope.SERVICE);
		String maskOutXsl = config.getPropertyValueByKey("maskRequestOutXsl", styleCodeId, providerId, Scope.SERVICE);
		String maskRespInXslConfig = config.getPropertyValueByKey("maskRespInXsl", styleCodeId, providerId, Scope.SERVICE);

		if(maskInXsl != null) {
			setMaskReqInXSL(configRoot + '/' + maskInXsl);
		}
		if(maskOutXsl != null) {
			setMaskReqOutXSL(configRoot + '/' + maskOutXsl);
		}

		if(maskRespInXslConfig != null) {
			setMaskRespInXSL(configRoot + '/' + maskRespInXslConfig);
		}

		String soapMethod = config.getPropertyValueByKey("soapMethod", styleCodeId, providerId, Scope.SERVICE);
		if( soapMethod != null) {
			setMethod(soapMethod);
		}

		String timeout = config.getPropertyValueByKey("timeoutMillis", styleCodeId, providerId, Scope.SERVICE);
		setTimeoutMillis(Integer.parseInt(timeout));


		setSslNoHostVerify(config.getPropertyValueByKey("sslNoHostVerify", styleCodeId, providerId, Scope.SERVICE));
		setClientCert(config.getPropertyValueByKey("sslClientCertificate", styleCodeId, providerId, Scope.SERVICE));
		setClientCertPass(config.getPropertyValueByKey("sslClientCertificatePassword", styleCodeId, providerId, Scope.SERVICE));
		setUnescapeElement(config.getPropertyValueByKey("unescapeElement", styleCodeId, providerId, Scope.SERVICE));
		setExtractElement(config.getPropertyValueByKey("extractElement", styleCodeId, providerId, Scope.SERVICE));
		setContentType(config.getPropertyValueByKey("contentType", styleCodeId, providerId, Scope.SERVICE));
		setEncoding(config.getPropertyValueByKey("encoding", styleCodeId, providerId, Scope.SERVICE));
		setAccept(config.getPropertyValueByKey("accept", styleCodeId, providerId, Scope.SERVICE));

	}

	private String overrideUrlPort(String url, int port) {
		String ret = url;
		try {
			URI testURI = new URI(url);
			if (port != -1 && port != 80 && testURI.getHost().equals("127.0.0.1") && testURI.getPort() != port) {
				URI newUri = new URI(testURI.getScheme(), testURI.getUserInfo(), testURI.getHost(), port, testURI.getPath(), testURI.getQuery(), testURI.getFragment());
				ret = newUri.toString();
			}
		} catch (Exception ex) {
			LOGGER.info("Failed to override url: {}",url,ex);
		}
		LOGGER.debug("URL={}",ret);
		return ret;
	}

	@Override
	public String toString() {
		return "SoapClientThreadConfiguration{" +
				"name='" + name + '\'' +
				", url='" + url + '\'' +
				'}';
	}



}