package com.ctm.web.health.services;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.leadService.model.LeadRequest;
import com.ctm.web.core.leadService.services.LeadService;
import com.ctm.web.core.results.model.ResultsTemplateItem;
import com.ctm.web.core.results.services.ResultsDisplayService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.model.leadservice.HealthMetadata;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class HealthLeadService extends LeadService {
    private static final Logger LOGGER = LoggerFactory.getLogger(HealthLeadService.class);

    private static final String CHARS_TO_REPLACE_PHONE_NUMBER[] = {"(", ")", " "};
    private static final String CHARS_TO_REPLACE_WITH_PHONE_NUMBER[] = {"", "", ""};

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private ResultsDisplayService resultsDisplayService = new ResultsDisplayService();

    @Override
    protected LeadRequest updatePayloadData(final Data data) {
        final LeadRequest leadData = new LeadRequest();

        // Name
        if(data.hasChild("health/application/primary/firstname")) {
            leadData.getPerson().setFirstName(data.getString("health/application/primary/firstname"));
            leadData.getPerson().setLastName(data.getString("health/application/primary/surname"));
        } else {
            leadData.getPerson().setFirstName(data.getString("health/contactDetails/name"));
        }

        // DOB
        String dobXPath = "health/application/primary/dob";
        if(data.hasChild(dobXPath) && !data.getString(dobXPath).isEmpty()) {
            leadData.getPerson().setDob(LocalDate.parse(data.getString(dobXPath)));
        }

        // Contact Details
        if(!StringUtils.isEmpty(data.getString("health/application/email"))) {
            leadData.getPerson().setEmail(data.getString("health/application/email"));
        } else {
            leadData.getPerson().setEmail(data.getString("health/contactDetails/email"));
        }

        if(!StringUtils.isEmpty(data.getString("health/application/mobile"))) {
            String mobile = data.getString("health/application/mobile");
            leadData.getPerson().setMobile(StringUtils.replaceEach(mobile, CHARS_TO_REPLACE_PHONE_NUMBER, CHARS_TO_REPLACE_WITH_PHONE_NUMBER));
        } else {
            String mobile = data.getString("health/contactDetails/flexiContactNumber");
            leadData.getPerson().setMobile(StringUtils.replaceEach(mobile, CHARS_TO_REPLACE_PHONE_NUMBER, CHARS_TO_REPLACE_WITH_PHONE_NUMBER));
        }

        if(!StringUtils.isEmpty(data.getString("health/application/other"))) {
            String phone = data.getString("health/application/other");
            leadData.getPerson().setPhone(StringUtils.replaceEach(phone, CHARS_TO_REPLACE_PHONE_NUMBER, CHARS_TO_REPLACE_WITH_PHONE_NUMBER));
        } else {
            String phone = data.getString("health/contactDetails/contactNumber/other");
            leadData.getPerson().setPhone(StringUtils.replaceEach(phone, CHARS_TO_REPLACE_PHONE_NUMBER, CHARS_TO_REPLACE_WITH_PHONE_NUMBER));
        }

        // Location
        if(!StringUtils.isEmpty("health/application/address/state")) {
            leadData.getPerson().getAddress().setState(data.getString("health/application/address/state"));
        } else {
            leadData.getPerson().getAddress().setState(data.getString("health/situation/state"));
        }

        if(!StringUtils.isEmpty("health/application/address/suburb")) {
            leadData.getPerson().getAddress().setSuburb(data.getString("health/application/address/suburb"));
        } else {
            leadData.getPerson().getAddress().setSuburb(data.getString("health/situation/suburb"));
        }

        if(!StringUtils.isEmpty("health/application/address/postCode")) {
            leadData.getPerson().getAddress().setPostcode(data.getString("health/application/address/postCode"));
        } else {
            leadData.getPerson().getAddress().setPostcode(data.getString("health/situation/postcode"));
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
        String dependants = data.getString("health/healthCover/dependants");
        String rebateTier = data.getString("health/healthCover/income");
        String gender = data.getString("health/application/primary/gender");
        String partnerGender = data.getString("health/application/partner/gender");

        // Metadata
        HealthMetadata healthMetadata = new HealthMetadata(
                situation,
                lookingTo,
                StringUtils.isEmpty(hasPrivateHealthInsurance) ? null : hasPrivateHealthInsurance.equalsIgnoreCase("Y") ? true : false,
                StringUtils.isEmpty(hasPartnerHealthInsurance) ? null : hasPartnerHealthInsurance.equalsIgnoreCase("Y") ? true : false,
                StringUtils.isEmpty(shouldApplyRebate) ? null : shouldApplyRebate.equalsIgnoreCase("Y") ? true : false,
                benefitList,
                StringUtils.isEmpty(partnerDob) ? null : LocalDate.parse(partnerDob, DATE_TIME_FORMATTER).toString(),
                StringUtils.isEmpty(dependants) ? null : Integer.parseInt(dependants),
                StringUtils.isEmpty(rebateTier) ? null : Integer.parseInt(rebateTier),
                gender,
                partnerGender
        );
        leadData.setMetadata(healthMetadata);
        return leadData;
    }
}
