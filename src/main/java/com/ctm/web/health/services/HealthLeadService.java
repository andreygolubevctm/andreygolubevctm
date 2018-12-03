package com.ctm.web.health.services;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.leadService.model.LeadRequest;
import com.ctm.web.core.leadService.services.LeadService;
import com.ctm.web.core.results.model.ResultsTemplateItem;
import com.ctm.web.core.results.services.ResultsDisplayService;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.model.leadservice.HealthMetadata;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Component
public class HealthLeadService extends LeadService {

    private enum PhoneType {
        OTHER,
        MOBILE,
        LANDLINE;
    }

    @Deprecated // used by write_quote.tag
    @SuppressWarnings("unused")
    public HealthLeadService() {
        super(IPAddressHandler.getInstance());
    }

    @Autowired
    public HealthLeadService(IPAddressHandler ipAddressHandler) {
        super(ipAddressHandler);
    }

    @Override
    protected LeadRequest updatePayloadData(final Data data) {
        final LeadRequest leadData = new LeadRequest();

        // Name
        if(!StringUtils.isEmpty(data.getString("health/application/primary/firstname"))) {
            leadData.getPerson().setFirstName(StringUtils.left(data.getString("health/application/primary/firstname"), 50));
        } else {
            leadData.getPerson().setFirstName(StringUtils.left(data.getString("health/contactDetails/name"), 50));
        }

        String mobile = null;
        String appMobile = getCleanPhone(data.getString("health/application/mobile"));
        String flexiMobile = getCleanPhone(data.getString("health/contactDetails/flexiContactNumber"));
        String contactMobile = getCleanPhone(data.getString("health/contactDetails/contactNumber/mobile"));
        if(appMobile != null && getPhoneType(appMobile).equals(PhoneType.MOBILE)) {
            mobile = appMobile;
        } else if (flexiMobile != null && getPhoneType(flexiMobile).equals(PhoneType.MOBILE)) {
            mobile = flexiMobile;
        } else if (contactMobile != null && getPhoneType(contactMobile).equals(PhoneType.MOBILE)) {
            // Required because flexi doesn't exist in Simples/V1 journey
            mobile = contactMobile;
        }
        if(mobile != null) {
            leadData.getPerson().setMobile(mobile);
        }

        String phone = null;
        String appPhone = getCleanPhone(data.getString("health/application/other"));
        String flexiPhone = getCleanPhone(data.getString("health/contactDetails/flexiContactNumber"));
        String contactPhone = getCleanPhone(data.getString("health/contactDetails/contactNumber/other"));
        if(appPhone != null && getPhoneType(appPhone).equals(PhoneType.LANDLINE)) {
            phone = appPhone;
        } else if (flexiPhone != null && getPhoneType(flexiPhone).equals(PhoneType.LANDLINE)) {
            phone = flexiPhone;
        } else if (contactPhone != null && getPhoneType(contactPhone).equals(PhoneType.LANDLINE)) {
            // Required because flexi doesn't exist in Simples/V1 journey
            phone = contactPhone;
        }
        if(phone != null) {
            leadData.getPerson().setPhone(phone);
        }

        // Location
        if(!StringUtils.isEmpty(data.getString("health/application/address/state"))) {
            leadData.getPerson().getAddress().setState(data.getString("health/application/address/state"));
        } else {
            leadData.getPerson().getAddress().setState(data.getString("health/situation/state"));
        }

        if (StringUtils.isNotBlank(data.getString("health/gaclientid"))) {
            leadData.setAnalyticsId(data.getString("health/gaclientid"));
        }

        if (StringUtils.isNotBlank(data.getString("health/tracking/cid"))) {
            String cid = data.getString("health/tracking/cid");
            cid = StringUtils.substringBefore(cid,"|"); // Required to handle cases like ps:ga:health:115969|2017-03-15
            leadData.setCampaignId(cid);
        }

        leadData.setVerticalType(VerticalType.HEALTH.name());

        String situation = data.getString("health/situation/healthCvr");
        String hasPrivateHealthInsurance = data.getString("health/healthCover/primary/cover");
        String screenSize = data.getString("health/renderingMode");

        // Metadata
        HealthMetadata healthMetadata = new HealthMetadata(
                situation,
                StringUtils.isEmpty(hasPrivateHealthInsurance) ? null : hasPrivateHealthInsurance.equalsIgnoreCase("Y"),
                StringUtils.isEmpty(screenSize) ? null : screenSize
        );
        leadData.setMetadata(healthMetadata);
        return leadData;
    }

    private String getCleanPhone(String phone) {
        if(StringUtils.isNotEmpty(phone)) {
            return StringUtils.left(phone.replaceAll("\\D", ""), 10);
        } else {
            return null;
        }
    }

    private PhoneType getPhoneType(String phone) {
        PhoneType response = PhoneType.OTHER;
        if(phone != null) {
            if (phone.matches("0[45][0-9]{8}")) {
                return PhoneType.MOBILE;
            } else if (phone.matches("0[0-9]{9}")) {
                return PhoneType.LANDLINE;
            }
        }
        return response;
    }
}