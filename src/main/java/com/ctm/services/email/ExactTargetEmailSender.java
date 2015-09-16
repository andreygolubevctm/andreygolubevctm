package com.ctm.services.email;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SendEmailException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.logging.LoggingVariables;
import com.ctm.model.email.EmailModel;
import com.ctm.model.email.EmailResponse;
import com.ctm.model.email.ExactTargetEmailModel;
import com.ctm.model.formatter.email.ExactTargetFormatter;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.ServiceConfigurationProperty;
import com.ctm.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.security.StringEncryption;
import com.ctm.services.ServiceConfigurationService;
import com.ctm.webservice.WebServiceUtils;
import com.exacttarget.wsdl.partnerapi.*;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.endpoint.Endpoint;
import org.apache.cxf.frontend.ClientProxy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.DOMException;

import javax.xml.bind.JAXBElement;
import javax.xml.ws.BindingProvider;
import javax.xml.ws.Service;
import java.security.GeneralSecurityException;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import static java.lang.Integer.parseInt;

public class ExactTargetEmailSender<T extends EmailModel> {

	private PageSettings pageSettings;
	private Client client;
	
	private static final String SECRET_KEY = "UyNf-Kh4jnzztSZQI8Z6Wg";
	private String WEBSERVICE_URL;
	private String WEBSERVICE_USER;
	private String WEBSERVICE_PASSWORD;

	private static final Logger logger = LoggerFactory.getLogger(ExactTargetEmailSender.class.getName());

	public ExactTargetEmailSender(PageSettings pageSettings) throws SendEmailException {
		this.pageSettings = pageSettings;
		setWebserviceConfiguration(ConfigSetting.ALL_VERTICALS, ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS);
	}
	
	public ExactTargetEmailSender(PageSettings pageSettings, int verticalId, int brandId, int providerId) throws SendEmailException {
		this.pageSettings = pageSettings;
		setWebserviceConfiguration(verticalId, brandId, providerId);
	}
	
	private void setWebserviceConfiguration(int verticalId, int brandId, int providerId) throws SendEmailException {		
		try {
			ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration("exactTargetService", verticalId, brandId);
			if (serviceConfig == null)
				throw new SendEmailException("Unable to find service 'exactTarget'");
				
			WEBSERVICE_URL = serviceConfig.getPropertyValueByKey("serviceUrl", brandId, providerId, Scope.SERVICE);
			WEBSERVICE_USER = serviceConfig.getPropertyValueByKey("serviceUser", brandId, providerId, Scope.SERVICE);
			WEBSERVICE_PASSWORD = serviceConfig.getPropertyValueByKey("servicePassword", brandId, providerId, Scope.SERVICE);
		} catch (DaoException | ServiceConfigurationException e1) {
			throw new SendEmailException("Could not successfully get default exact target service configuration from database", e1);
		}
	
		if (WEBSERVICE_URL == null)
			throw new SendEmailException("Unable to find service property 'serviceUrl' for service 'exactTarget'");
		
		if (WEBSERVICE_USER == null)
			throw new SendEmailException("Unable to find service property 'serviceUser' for service 'exactTarget'");
		
		if (WEBSERVICE_PASSWORD == null) {
			throw new SendEmailException("Unable to find service property 'servicePassword' for service 'exactTarget'");
		} else {
			try {
				WEBSERVICE_PASSWORD = StringEncryption.decrypt(SECRET_KEY, WEBSERVICE_PASSWORD);
			} catch (GeneralSecurityException e) {
				throw new SendEmailException("Could not decrypt ExactTarget password", e);
			}
		}			
	}
	
	public void sendToExactTarget(ExactTargetFormatter<T> formatter, T emailModel)
			throws SendEmailException {
		ExactTargetEmailModel exactTargetEmailModel = formatter.convertToExactTarget(emailModel);
		try {
			exactTargetEmailModel.setClientId(parseInt(pageSettings.getSetting("sendClientId")));
			Soap stub = initWebserviceClient();
			CreateRequest createRequest = new CreateRequest();

			createPayload(exactTargetEmailModel, createRequest);

			CreateResponse createResponse = stub.create(createRequest);
			EmailResponse response = parseResponse(createResponse);
			if(!response.isSuccessful()){
				SendEmailException exception = new SendEmailException("error returned from exact target error code:" + response.getErrorCode());
				exception.setDescription("failed to call exact target message:" + response.getMessage() + " OverallStatus: "+ response.getOverallStatus() + " requestID:"+ response.getRequestID());
				throw exception;
			}
		} catch (ConfigSettingException  e) {
			logger.error( "failed to call exact target web service", e);
			throw new SendEmailException( "failed to call exact target web service", e );
		} finally {
			destroyWebserviceClient();
		}
	}

	private Soap initWebserviceClient()  {
		Service service = new PartnerAPI();
		Soap port = service.getPort(Soap.class);
		BindingProvider bp = (BindingProvider)port;
		bp.getRequestContext().put(BindingProvider.ENDPOINT_ADDRESS_PROPERTY, WEBSERVICE_URL);
		client = ClientProxy.getClient(port);
		Endpoint cxfEndpoint = client.getEndpoint();
		Map<String, Object> ctx = ((BindingProvider) port).getRequestContext();
		WebServiceUtils.setWsSecurity(cxfEndpoint , ctx, WEBSERVICE_USER, WEBSERVICE_PASSWORD);
		WebServiceUtils.setLogging(cxfEndpoint);
		return port;
	}

	private void destroyWebserviceClient()  {
		if(client != null){
			client.destroy();
		}
		client = null;
	}


	private void createPayload(ExactTargetEmailModel exactTargetEmailModel, CreateRequest createRequest) {
		ObjectFactory  objectFactory = new com.exacttarget.wsdl.partnerapi.ObjectFactory();

		CreateOptions options = new CreateOptions();
		createRequest.setOptions(options );
		List<APIObject> objects = createRequest.getObjects();

		TriggeredSend triggeredSend = new TriggeredSend();
		triggeredSend.setCorrelationID(LoggingVariables.getCorrelationId());

		ClientID client = createClient(exactTargetEmailModel);

		triggeredSend.setClient(client);

		TriggeredSendDefinition triggeredSendDefinition = createTriggeredSendDefinition(
				exactTargetEmailModel, objectFactory);

		triggeredSend.setTriggeredSendDefinition(triggeredSendDefinition);

		Subscriber subscriber = createSubscriber(exactTargetEmailModel);
		triggeredSend.getSubscribers().add(subscriber);

		objects.add(triggeredSend);
	}

	private ClientID createClient(ExactTargetEmailModel exactTargetEmailModel) {
		ClientID clientId = new ClientID();
		clientId.setClientID(exactTargetEmailModel.getClientId());
		return clientId;
	}

	private Subscriber createSubscriber(ExactTargetEmailModel exactTargetEmailModel) {
		Subscriber subscriber = new Subscriber();
		subscriber.setEmailAddress(exactTargetEmailModel.getEmailAddress()); // updating to new email address.
		subscriber.setSubscriberKey(subscriber.getEmailAddress()); //subscriber unique, cannot update

		for(Entry<String, String> attribute: exactTargetEmailModel.getAttributes().entrySet()) {
			String value = attribute.getValue();
			String normalisedValue = value == null ? "" : value;
			Attribute attributeElement = new Attribute();
			attributeElement.setName(attribute.getKey());
			attributeElement.setValue(normalisedValue);
			subscriber.getAttributes().add(attributeElement);
		}
		return subscriber;
	}


	private TriggeredSendDefinition createTriggeredSendDefinition(
			ExactTargetEmailModel exactTargetEmailModel,
			ObjectFactory objectFactory) {
		TriggeredSendDefinition triggeredSendDefinition = new TriggeredSendDefinition();
		JAXBElement<String> partnerKey = objectFactory.createAPIObjectPartnerKey(null);
		partnerKey.setNil(true);
		triggeredSendDefinition.setPartnerKey(partnerKey);
		JAXBElement<String> objectID = objectFactory.createAPIObjectObjectID(null);
		objectID.setNil(true);
		triggeredSendDefinition.setObjectID(objectID);
		triggeredSendDefinition.setCustomerKey(exactTargetEmailModel.getCustomerKey());
		SendClassification sendClassification = new SendClassification();
		triggeredSendDefinition.setSendClassification(sendClassification );
		return triggeredSendDefinition;
	}

	private EmailResponse parseResponse(CreateResponse createResponse) throws DOMException, SendEmailException {
		boolean success = false;
		String statusMessage = "";
		EmailResponse response = new EmailResponse();

		String overallStatus = createResponse.getOverallStatus();
		String requestID = createResponse.getRequestID();
		response.setOverallStatus(overallStatus);
		if(overallStatus != null && overallStatus.equals("OK")){
			success = true;
		}
		for (CreateResult createResult: createResponse.getResults()) {
				statusMessage += createResult.getStatusMessage();
				if(!success){
					statusMessage = handleResponseErrors(statusMessage,
							response, createResult);
				}
		}
		response.setMessage(statusMessage);
		response.setSuccessful(success);
		response.setRequestID(requestID);
		logger.info("exact target respone message:" + response.getMessage());
		return response;
	}

	private String handleResponseErrors(String statusMessage,
			EmailResponse response, CreateResult result) {
		int errorCode = 0;
		if(result.getErrorCode() != null){
			errorCode = result.getErrorCode();
		}
		String errorDescription = result.getResultDetailXML();
		for(CreateResult r2 :  result.getCreateResults()) {
				statusMessage += " subscriberFailuresErrorDescription:";
				String separator = "";
				errorDescription += r2.getResultDetailXML();
				if(!errorDescription.isEmpty()){
					statusMessage += separator + errorDescription;
						separator = ",";
				}
		}
		response.setErrorCode(errorCode);
		return statusMessage;
	}

}
