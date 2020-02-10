package com.ctm.web.health.apply.model.request.application.GovernmentRebate;


import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.time.LocalDate;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class GovernmentRebateAcknowledgement {

    private AGRBoolean applicantCovered;

    private AGRBoolean entitledToMedicare;

    private AGRBoolean governmentRebateDeclaration;

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate declarationDate;

    private AGRBoolean voiceConsent;

    private AGRBoolean childOnlyPolicy;

    public GovernmentRebateAcknowledgement(final AGRBoolean applicantCovered,
                                           final AGRBoolean entitledToMedicare,
                                           final AGRBoolean governmentRebateDeclaration,
                                           final LocalDate declarationDate,
                                           final AGRBoolean voiceConsent,
                                           final AGRBoolean childOnlyPolicy) {
        this.applicantCovered = applicantCovered;
        this.entitledToMedicare = entitledToMedicare;
        this.governmentRebateDeclaration = governmentRebateDeclaration;
        this.declarationDate = declarationDate;
        this.voiceConsent = voiceConsent;
        this.childOnlyPolicy = childOnlyPolicy;
    }

    public AGRBoolean getApplicantCovered() {
        return applicantCovered;
    }

    public AGRBoolean getEntitledToMedicare() {
        return entitledToMedicare;
    }

    public AGRBoolean getGovernmentRebateDeclaration() {
        return governmentRebateDeclaration;
    }

    public LocalDate getDeclarationDate() {
        return declarationDate;
    }

    public AGRBoolean getVoiceConsent() {
        return voiceConsent;
    }

    public AGRBoolean getChildOnlyPolicy() {
        return childOnlyPolicy;
    }
}