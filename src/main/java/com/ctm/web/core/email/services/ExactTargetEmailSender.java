package com.ctm.services.email;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.exceptions.SendEmailException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.email.EmailModel;
import com.ctm.web.core.model.email.EmailResponse;
import com.ctm.web.core.model.email.ExactTargetEmailModel;
import com.ctm.web.core.email.formatter.ExactTargetFormatter;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.ServiceConfigurationProperty;
import com.ctm.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.security.StringEncryption;
import com.ctm.services.ServiceConfigurationService;
import com.ctm.web.core.webservice.WebServiceUtils;
import com.exacttarget.wsdl.partnerapi.*;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.endpoint.Endpoint;
import org.apache.cxf.frontend.ClientProxy;
import org.apache.cxf.transport.http.HTTPConduit;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.DOMException;

import javax.xml.ws.BindingProvider;
import javax.xml.ws.Service;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.GeneralSecurityException;
import java.util.Map;

import static com.ctm.web.core.logging.LoggingArguments.kv;
import static java.lang.Integer.parseInt;

public class ExactTargetEmailSender<T extends EmailModel> {

    private PageSettings pageSettings;
    private Client client;
    private Long transactionId;

    private static final String SECRET_KEY = "UyNf-Kh4jnzztSZQI8Z6Wg";
    private String WEBSERVICE_URL;
    private String WEBSERVICE_USER;
    private String WEBSERVICE_PASSWORD;

    private static final Logger LOGGER = LoggerFactory.getLogger(ExactTargetEmailSender.class);

    public ExactTargetEmailSender(PageSettings pageSettings, Long transactionId) throws SendEmailException {
        this.pageSettings = pageSettings;
        this.transactionId = transactionId;
        setWebserviceConfiguration(ConfigSetting.ALL_VERTICALS, ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS);
    }

    public ExactTargetEmailSender(PageSettings pageSettings, Long transactionId, int verticalId, int brandId, int providerId) throws SendEmailException {
        this.pageSettings = pageSettings;
        this.transactionId = transactionId;
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
            Soap stub = initWebserviceClient(transactionId);
            CreateRequest createRequest = new CreateRequest();

            ExactTargetEmailBuilder.createPayload(exactTargetEmailModel, createRequest);

            CreateResponse createResponse = stub.create(createRequest);
            EmailResponse response = parseResponse(createResponse);
            if (!response.isSuccessful()) {
                SendEmailException exception = new SendEmailException("error returned from exact target error code:" + response.getErrorCode());
                exception.setDescription("failed to call exact target message:" + response.getMessage() + " OverallStatus: " + response.getOverallStatus() + " requestID:" + response.getRequestID());
                throw exception;
            }
        } catch (ConfigSettingException e) {
            LOGGER.error("Failed to call exact target web service {}", kv("emailModel", emailModel), e);
            throw new SendEmailException("failed to call exact target web service", e);
        } finally {
            destroyWebserviceClient();
        }
    }

    private Soap initWebserviceClient(Long transactionId) {
        Service service = new PartnerAPI();
        Soap port = service.getPort(Soap.class);
        BindingProvider bp = (BindingProvider) port;
        bp.getRequestContext().put(BindingProvider.ENDPOINT_ADDRESS_PROPERTY, WEBSERVICE_URL);
        client = ClientProxy.getClient(port);

        Endpoint cxfEndpoint = client.getEndpoint();
        initProxyAuth(client);

        Map<String, Object> ctx = ((BindingProvider) port).getRequestContext();
        WebServiceUtils.setWsSecurity(cxfEndpoint, ctx, WEBSERVICE_USER, WEBSERVICE_PASSWORD);
        WebServiceUtils.setLogging(client, pageSettings, transactionId, "EXACT_TARGET_EMAIL");
        return port;
    }

    private void initProxyAuth(Client cxfClient) {
        // If system properties for proxy user/pass are set, then configure the httpconduit for cxf
        HTTPConduit http = (HTTPConduit) cxfClient.getConduit();
        try {
            URL webAddressUrl = new URL(http.getAddress());
            if (webAddressUrl.getProtocol().equals(WebServiceUtils.HTTP_PROTOCOL) &&
                    System.getProperty(WebServiceUtils.HTTP_PROXY_USER) != null) {
                http.getProxyAuthorization().setUserName(System.getProperty(WebServiceUtils.HTTP_PROXY_USER));
                http.getProxyAuthorization().setPassword(System.getProperty(WebServiceUtils.HTTP_PROXY_PASSWORD));
            }
            if (webAddressUrl.getProtocol().equals(WebServiceUtils.HTTPS_PROTOCOL) &&
                    System.getProperty(WebServiceUtils.HTTPS_PROXY_USER) != null) {
                http.getProxyAuthorization().setUserName(System.getProperty(WebServiceUtils.HTTPS_PROXY_USER));
                http.getProxyAuthorization().setPassword(System.getProperty(WebServiceUtils.HTTPS_PROXY_PASSWORD));
            }
        } catch(MalformedURLException mue) {
            LOGGER.error("Failed to parse ws address: [{}]",http.getAddress());
        }
    }

    private void destroyWebserviceClient() {
        if (client != null) {
            client.destroy();
        }
        client = null;
    }

    private EmailResponse parseResponse(CreateResponse createResponse) throws DOMException, SendEmailException {
        boolean success = false;
        String statusMessage = "";
        EmailResponse response = new EmailResponse();

        String overallStatus = createResponse.getOverallStatus();
        String requestID = createResponse.getRequestID();
        response.setOverallStatus(overallStatus);
        if (overallStatus != null && overallStatus.equals("OK")) {
            success = true;
        }
        for (CreateResult createResult : createResponse.getResults()) {
            statusMessage += createResult.getStatusMessage();
            if (!success) {
                statusMessage = handleResponseErrors(statusMessage,
                        response, createResult);
            }
        }
        response.setMessage(statusMessage);
        response.setSuccessful(success);
        response.setRequestID(requestID);
        LOGGER.debug("Exact target response message {}", kv("response", response.getMessage()));
        return response;
    }

    private String handleResponseErrors(String statusMessage,
                                        EmailResponse response, CreateResult result) {
        int errorCode = 0;
        if (result.getErrorCode() != null) {
            errorCode = result.getErrorCode();
        }
        String errorDescription = result.getResultDetailXML();
        for (CreateResult r2 : result.getCreateResults()) {
            statusMessage += " subscriberFailuresErrorDescription:";
            String separator = "";
            errorDescription += r2.getResultDetailXML();
            if (!errorDescription.isEmpty()) {
                statusMessage += separator + errorDescription;
                separator = ",";
            }
        }
        response.setErrorCode(errorCode);
        return statusMessage;
    }

}
