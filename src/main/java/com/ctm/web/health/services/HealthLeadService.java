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

    private static final String CHARS_TO_REPLACE_PHONE_NUMBER[] = {"(", ")", " "};
    private static final String CHARS_TO_REPLACE_WITH_PHONE_NUMBER[] = {"", "", ""};

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

        if(StringUtils.isNotEmpty(data.getString("health/application/mobile"))) {
            String mobile = StringUtils.replaceEach(data.getString("health/application/mobile"), CHARS_TO_REPLACE_PHONE_NUMBER, CHARS_TO_REPLACE_WITH_PHONE_NUMBER);
            leadData.getPerson().setMobile(StringUtils.left(mobile, 10));
        } else if (StringUtils.isNotEmpty(data.getString("health/contactDetails/flexiContactNumber"))) {
            String mobile = StringUtils.replaceEach(data.getString("health/contactDetails/flexiContactNumber"), CHARS_TO_REPLACE_PHONE_NUMBER, CHARS_TO_REPLACE_WITH_PHONE_NUMBER);
            if(mobile != null && mobile.startsWith("04")) {
                leadData.getPerson().setMobile(StringUtils.left(mobile, 10));
            }
        } else if (StringUtils.isNotEmpty(data.getString("health/contactDetails/contactNumber/mobile"))) {
            // Required because flexi doesn't exist in Simples/V1 journey
            String mobile = StringUtils.replaceEach(data.getString("health/contactDetails/contactNumber/mobile"), CHARS_TO_REPLACE_PHONE_NUMBER, CHARS_TO_REPLACE_WITH_PHONE_NUMBER);
            leadData.getPerson().setMobile(StringUtils.left(mobile, 10));
        }

        if(StringUtils.isNotEmpty(data.getString("health/application/other"))) {
            String phone = StringUtils.replaceEach(data.getString("health/application/other"), CHARS_TO_REPLACE_PHONE_NUMBER, CHARS_TO_REPLACE_WITH_PHONE_NUMBER);
            leadData.getPerson().setPhone(StringUtils.left(phone, 10));
        } else if (StringUtils.isNotEmpty(data.getString("health/contactDetails/flexiContactNumber"))) {
            String phone = StringUtils.replaceEach(data.getString("health/contactDetails/flexiContactNumber"), CHARS_TO_REPLACE_PHONE_NUMBER, CHARS_TO_REPLACE_WITH_PHONE_NUMBER);
            if(phone != null && !phone.startsWith("04")) {
                leadData.getPerson().setPhone(StringUtils.left(phone, 10));
            }
        } else if (StringUtils.isNotEmpty(data.getString("health/contactDetails/contactNumber/other"))) {
            // Required because flexi doesn't exist in Simples/V1 journey
            String mobile = StringUtils.replaceEach(data.getString("health/contactDetails/contactNumber/other"), CHARS_TO_REPLACE_PHONE_NUMBER, CHARS_TO_REPLACE_WITH_PHONE_NUMBER);
            leadData.getPerson().setPhone(StringUtils.left(mobile, 10));
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
        String leadOptinCopy = data.getString("health/contactDetails/leadOptinCopy");

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
				StringUtils.isEmpty(leadOptinCopy) ? null : leadOptinCopy
        );
        leadData.setMetadata(healthMetadata);
        return leadData;
    }
}