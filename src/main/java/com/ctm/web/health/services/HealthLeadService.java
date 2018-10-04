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

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private ResultsDisplayService resultsDisplayService = new ResultsDisplayService();

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
            leadData.getPerson().setLastName(StringUtils.left(data.getString("health/application/primary/surname"), 50));
        } else {
            leadData.getPerson().setFirstName(StringUtils.left(data.getString("health/contactDetails/name"), 50));
        }

        // DOB
        String dobXPath = "health/application/primary/dob";
        if(!StringUtils.isEmpty(data.getString(dobXPath))) {
            leadData.getPerson().setDob(LocalDate.parse(data.getString(dobXPath), DATE_TIME_FORMATTER));
        } else {
            leadData.getPerson().setDob(LocalDate.parse(data.getString("health/healthCover/primary/dob"), DATE_TIME_FORMATTER));
        }

        // Contact Details
        if(!StringUtils.isEmpty(data.getString("health/application/email"))) {
            leadData.getPerson().setEmail(StringUtils.left(data.getString("health/application/email"), 128));
        } else {
            leadData.getPerson().setEmail(StringUtils.left(data.getString("health/contactDetails/email"), 128));
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

        if(!StringUtils.isEmpty(data.getString("health/application/address/suburbName"))) {
            leadData.getPerson().getAddress().setSuburb(data.getString("health/application/address/suburbName"));
        } else {
            leadData.getPerson().getAddress().setSuburb(data.getString("health/situation/suburb"));
        }

        if(!StringUtils.isEmpty(data.getString("health/application/address/postCode"))) {
            leadData.getPerson().getAddress().setPostcode(data.getString("health/application/address/postCode"));
        } else {
            leadData.getPerson().getAddress().setPostcode(data.getString("health/situation/postcode"));
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

        List<String> benefitList = new ArrayList<>();
        List<ResultsTemplateItem> resultsTemplateItemList = resultsDisplayService.getResultsTemplateItems(VerticalType.HEALTH.name());
        for(ResultsTemplateItem resultsTemplateItem : resultsTemplateItemList) {
            String benefit = data.getString("health/benefits/benefitsExtras/" + resultsTemplateItem.getShortlistKey());
            if(!StringUtils.isEmpty(benefit) && benefit.equalsIgnoreCase("Y")) {
                benefitList.add(resultsTemplateItem.getShortlistKey());
            }
        }

        String situation = data.getString("health/situation/healthCvr");
        String lookingTo = data.getString("health/situation/healthSitu");
        String hasPrivateHealthInsurance = data.getString("health/healthCover/primary/cover");
        String hasPartnerHealthInsurance = data.getString("health/healthCover/partner/cover");
        String shouldApplyRebate = data.getString("health/healthCover/rebate");

        String partnerDob = data.getString("health/application/partner/dob");
        if(StringUtils.isEmpty(partnerDob)) {
            partnerDob = data.getString("health/healthCover/partner/dob");
        }

        String dependants = data.getString("health/healthCover/dependants");
        String rebateTier = data.getString("health/healthCover/income");
        String gender = data.getString("health/application/primary/gender");
        String partnerGender = data.getString("health/application/partner/gender");
        String optinLeadCopy = data.getString("health/contactDetails/optinLeadCopy");

        // Metadata
        HealthMetadata healthMetadata = new HealthMetadata(
                situation,
                lookingTo,
                StringUtils.isEmpty(hasPrivateHealthInsurance) ? null : hasPrivateHealthInsurance.equalsIgnoreCase("Y"),
                StringUtils.isEmpty(hasPartnerHealthInsurance) ? null : hasPartnerHealthInsurance.equalsIgnoreCase("Y"),
                StringUtils.isEmpty(shouldApplyRebate) ? null : shouldApplyRebate.equalsIgnoreCase("Y"),
                benefitList,
                StringUtils.isEmpty(partnerDob) ? null : LocalDate.parse(partnerDob, DATE_TIME_FORMATTER).toString(),
                StringUtils.isEmpty(dependants) ? null : dependants,
                StringUtils.isEmpty(rebateTier) ? null : rebateTier,
                gender,
                partnerGender,
				StringUtils.isEmpty(optinLeadCopy) ? null : optinLeadCopy
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