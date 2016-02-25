package com.ctm.web.core.leadService.services;

import com.ctm.web.core.leadService.model.LeadRequest;
import com.ctm.web.core.leadService.model.LeadStatus;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.utils.SessionUtils;
import com.ctm.web.core.web.go.Data;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.leadService.model.LeadStatus.INBOUND_CALL;

public abstract class LeadService {
    private static final Logger LOGGER = LoggerFactory.getLogger(LeadService.class);
    public static final String LAST_LEAD_SERVICE_VALUES = "LAST_LEAD_SERVICE_VALUES";

    /**
     * Determines if we have the fields required for sending
     * @return
     * @param leadData
     */
    private boolean canSend(final LeadRequest leadData) {
        if(StringUtils.isEmpty(leadData.getSource())) {
            return false;
        }
        if(leadData.getRootId() == null) {
            return false;
        }
        if(leadData.getTransactionId() == null) {
            return false;
        }
        if(StringUtils.isEmpty(leadData.getBrandCode())) {
            return false;
        }
        if(StringUtils.isEmpty(leadData.getVerticalType())) {
            return false;
        }
        if(StringUtils.isEmpty(leadData.getClientIP())) {
            return false;
        }
        if(leadData.getStatus() == null) {
            return false;
        }
        if(StringUtils.isEmpty(leadData.getPerson().getFirstName())) {
            return false;
        }
        if(StringUtils.isEmpty(leadData.getPerson().getEmail())) {
            return false;
        }
        if(StringUtils.isEmpty(leadData.getPerson().getPhone()) && StringUtils.isEmpty(leadData.getPerson().getMobile())) {
            return false;
        }
        return true;
    }

    /**
     * Restfully sends the collected lead data to the CtM API endpoint.
     * Normally leads will not be processed when triggered by call centre. The exception is for INBOUND_CALL leads.
     *    (if customer calls us, we need to knock out any of their leads that might be outbounded)
     */
    public void sendLead(final int verticalId, final Data data, final HttpServletRequest request, final String transactionStatus) {
        if (!SessionUtils.isCallCentre(request.getSession()) || INBOUND_CALL.name().equals(transactionStatus)) {
            try {
                ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfigurationDeprecated("leadService", verticalId);

                Boolean enabled = Boolean.valueOf(serviceConfig.getPropertyValueByKey("enabled", 0, 0, ServiceConfigurationProperty.Scope.SERVICE));
                String url = serviceConfig.getPropertyValueByKey("url", 0, 0, ServiceConfigurationProperty.Scope.SERVICE);

                if (enabled) {
                    LeadRequest leadData = updatePayloadData(data);

                    leadData.setSource("SECURE");
                    leadData.setRootId(data.getLong("current/rootId"));
                    leadData.setTransactionId(data.getLong("current/transactionId"));
                    leadData.setBrandCode(data.getString("current/brandCode"));

                    leadData.setStatus(LeadStatus.valueOf(transactionStatus));

                    leadData.setClientIP(request.getRemoteAddr());

                    String previousValues = (String) request.getSession().getAttribute(LAST_LEAD_SERVICE_VALUES);
                    String currentValues = leadData.getValues();

                    if (canSend(leadData) && !currentValues.equals(previousValues)) {
                        request.getSession().setAttribute(LAST_LEAD_SERVICE_VALUES, currentValues);

                        LeadServiceUtil.sendRequest(leadData, url);
                    }
                }
            } catch (Throwable e) {
                LOGGER.error("Error sending lead request {}", kv("data", data), e);
            }
        }
    }

    /**
     * Updates the payload data object which contains commonly used fields
     * @param data
     */
    protected abstract LeadRequest updatePayloadData(final Data data);
}
