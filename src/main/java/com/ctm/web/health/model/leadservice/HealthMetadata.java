package com.ctm.web.health.model.leadservice;

import com.ctm.web.core.leadService.model.LeadMetadata;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonTypeName;

import java.util.List;

@JsonTypeName("health")
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class HealthMetadata extends LeadMetadata {
    private String situation;
    private String lookingTo;
    private Boolean hasPrivateHealthInsurance;
    private Boolean hasPartnerHealthInsurance;
    private Boolean shouldApplyRebate;
    private List<String> selectedBenefits;
    private String partnerDob;
    private Integer dependants;
    private Integer rebateTier;
    private String gender;
    private String partnerGender;

    public HealthMetadata(final String situation,
                          final String lookingTo,
                          final Boolean hasPrivateHealthInsurance,
                          final Boolean hasPartnerHealthInsurance,
                          final Boolean shouldApplyRebate,
                          final List<String> selectedBenefits,
                          final String partnerDob,
                          final Integer dependants,
                          final Integer rebateTier,
                          final String gender,
                          final String partnerGender) {
        this.situation = situation;
        this.lookingTo = lookingTo;
        this.hasPrivateHealthInsurance = hasPrivateHealthInsurance;
        this.hasPartnerHealthInsurance = hasPartnerHealthInsurance;
        this.shouldApplyRebate = shouldApplyRebate;
        this.selectedBenefits = selectedBenefits;
        this.partnerDob = partnerDob;
        this.dependants = dependants;
        this.rebateTier = rebateTier;
        this.gender = gender;
        this.partnerGender = partnerGender;
    }

    @Override
    public String getValues() {
        StringBuilder builder = new StringBuilder();
        builder.append(situation);
        builder.append(",");
        builder.append(lookingTo);
        builder.append(",");
        builder.append(hasPrivateHealthInsurance);
        builder.append(",");
        builder.append(hasPartnerHealthInsurance);
        builder.append(",");
        builder.append(shouldApplyRebate);
        builder.append(",");
        builder.append(selectedBenefits);
        builder.append(",");
        builder.append(partnerDob);
        builder.append(",");
        builder.append(dependants);
        builder.append(",");
        builder.append(rebateTier);
        builder.append(",");
        builder.append(gender);
        builder.append(",");
        builder.append(partnerGender);

        return builder.toString();
    }

    @Override
    public String toString() {
        return "HealthMetadata{" +
                "situation=" + situation +
                ", lookingTo=" + lookingTo +
                ", hasPrivateHealthInsurance=" + hasPrivateHealthInsurance +
                ", hasPartnerHealthInsurance=" + hasPartnerHealthInsurance +
                ", shouldApplyRebate=" + shouldApplyRebate +
                ", selectedBenefits=" + selectedBenefits +
                ", partnerDob=" + partnerDob +
                ", dependants=" + dependants +
                ", rebateTier=" + rebateTier +
                ", gender=" + gender +
                ", partnerGender=" + partnerGender +
                '}';
    }
}