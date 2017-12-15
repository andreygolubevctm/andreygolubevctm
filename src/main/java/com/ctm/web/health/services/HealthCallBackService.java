package com.ctm.web.health.services;

import com.ctm.web.core.leadService.model.LeadRequest;
import com.ctm.web.core.leadService.model.LeadResponse;
import com.ctm.web.core.leadService.model.LeadStatus;
import com.ctm.web.core.leadService.model.LeadType;
import com.ctm.web.core.leadService.services.LeadServiceUtil;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.callback.model.HealthCallBackData;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.concurrent.ListenableFuture;

import javax.servlet.http.HttpServletRequest;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

import static com.ctm.web.health.model.leadservice.HealthMetadata.EMPTY_HEALTH_METADATA;

@Component
public class HealthCallBackService {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthCallBackService.class);
    public static final String LAST_LEAD_SERVICE_VALUES = "LAST_LEAD_SERVICE_VALUES";
    public static final int HEALTH_VERTICAL_ID = 4;
    public static final int LEAD_SERVICE_TIMEOUT = 10;

    private IPAddressHandler ipAddressHandler;

    @Autowired
    public HealthCallBackService(IPAddressHandler ipAddressHandler) {
        this.ipAddressHandler = ipAddressHandler;
    }

    public void sendLead(HealthCallBackData data, Data dataBucket, HttpServletRequest request, LeadType leadType) throws Exception {
        ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration("leadService", HEALTH_VERTICAL_ID);

        Boolean enabled = Boolean.valueOf(serviceConfig.getPropertyValueByKey("enabled", 0, 0, ServiceConfigurationProperty.Scope.SERVICE));
        String url = serviceConfig.getPropertyValueByKey("url", 0, 0, ServiceConfigurationProperty.Scope.SERVICE);

        if (enabled) {
            final LeadRequest leadData = createLeadRequest(data, dataBucket, request, leadType);

            String previousValues = (String) request.getSession().getAttribute(LAST_LEAD_SERVICE_VALUES);
            String currentValues = leadData.getValues();

            if (!currentValues.equals(previousValues)) {
                ListenableFuture<ResponseEntity<LeadResponse>> sendRequestListenable = LeadServiceUtil.sendRequestListenable(leadData, url);

                sendRequestListenable.get(LEAD_SERVICE_TIMEOUT, TimeUnit.SECONDS);

                LOGGER.info("Successfully added health callback");
                request.getSession().setAttribute(LAST_LEAD_SERVICE_VALUES, currentValues);
            }

        }
    }

    private LeadRequest createLeadRequest(HealthCallBackData data, Data dataBucket, HttpServletRequest request, LeadType leadType) {
        final LeadRequest leadData = new LeadRequest();

        leadData.getPerson().setFirstName(StringUtils.left(data.getName(), 50));
        Optional.ofNullable(data.getMobileNumber())
                .map(mobile -> mobile.replaceAll("[^0-9]", ""))
                .ifPresent(mobile -> leadData.getPerson().setMobile(StringUtils.left(mobile, 10)));
        Optional.ofNullable(data.getOtherNumber())
                .map(phone -> phone.replaceAll("[^0-9]", ""))
                .ifPresent(phone -> leadData.getPerson().setPhone(StringUtils.left(phone, 10)));
        Optional.ofNullable(data.getScheduledDateTime())
                .map(dateTime -> ZonedDateTime.parse(dateTime, DateTimeFormatter.ISO_DATE_TIME))
                .ifPresent(leadData::setScheduledDateTime);

        leadData.setMetadata(EMPTY_HEALTH_METADATA);
        leadData.setVerticalType("HEALTH");

        leadData.setSource("SECURE");

        if (dataBucket != null) {
            leadData.setRootId(dataBucket.getLong("current/rootId"));
            leadData.setTransactionId(dataBucket.getLong("current/transactionId"));
            leadData.setBrandCode(dataBucket.getString("current/brandCode"));
        } else {
            leadData.setBrandCode("ctm");
            leadData.setRootId(Long.parseLong("-1"));
            leadData.setTransactionId(Long.parseLong("-1"));
        }

        leadData.setStatus(LeadStatus.OPEN);
        leadData.setLeadType(leadType);

        leadData.setClientIP(ipAddressHandler.getIPAddress(request));

        return leadData;
    }
}
