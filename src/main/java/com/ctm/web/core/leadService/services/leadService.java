package com.ctm.web.core.leadService.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.leadService.factories.LeadDataModelFactory;
import com.ctm.web.core.leadService.models.LeadDataModel;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;

public abstract class LeadService {

    protected static final Logger LOGGER = LoggerFactory.getLogger(LeadService.class);
    protected static FatalErrorService fatalErrorService;

    protected HttpServletRequest request = null;
    protected Data data = null;

    protected ServiceConfiguration serviceConfig = null;

    protected Boolean isInitialized = false;

    protected String url = null;
    protected Integer verticalId = null;

    protected LeadDataModel leadData = null;

    public LeadService(HttpServletRequest request, Integer verticalId, Data data) {
        this.request = request;
        this.verticalId = verticalId;
        this.data = data;

        String vertical = data.getString("current/verticalCode").toLowerCase();

        Boolean isInitialized = initialize();

        if(isInitialized) {
            LeadDataModelFactory leadDataModelFactory = new LeadDataModelFactory();
            leadData = leadDataModelFactory.createLeadDataModel(vertical);

            updatePayloadData();
            sendLead();
        }
    }

    /**
     * Initializes the service configuration and sets the target endpoints for the API calls
     */
    protected Boolean initialize() {
        try {
            serviceConfig = ServiceConfigurationService.getServiceConfiguration("leadService", this.verticalId, 0);
        } catch(DaoException | ServiceConfigurationException e) {
            LOGGER.error("[Lead Service] Could not initialize Lead Service configuration", e);
            fatalErrorService.logFatalError(e, 0, "LeadService", false, "");
            return false;
        }

        String enabled = serviceConfig.getPropertyValueByKey("enabled", 0, 0, ServiceConfigurationProperty.Scope.SERVICE);

        if(enabled.equals("true")) {
            url = serviceConfig.getPropertyValueByKey("url", 0, 0, ServiceConfigurationProperty.Scope.SERVICE);
        }

        return true;
    }

    /**
     * Restfully sends the collected lead data to the CtM API endpoint
     */
    private void sendLead() {
        try {
            URL targetUrl = new URL(url);

            HttpURLConnection httpConnection = (HttpURLConnection) targetUrl.openConnection();
            httpConnection.setDoOutput(true);
            httpConnection.setRequestMethod("POST");
            httpConnection.setRequestProperty("Content-Type", "application/json");

            String body = "{\"a\": \"b\"}";

            OutputStream outputStream = httpConnection.getOutputStream();
            outputStream.write(body.getBytes());
            outputStream.flush();

            if (httpConnection.getResponseCode() != 200) {
                throw new RuntimeException("Failed : HTTP error code : " + httpConnection.getResponseCode());
            }

            BufferedReader responseBuffer = new BufferedReader(
                new InputStreamReader(httpConnection.getInputStream())
            );

            // TODO: Do something with the response

            httpConnection.disconnect();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (ProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Updates the payload data object which contains commonly used fields
     */
    protected abstract void updatePayloadData();

}
