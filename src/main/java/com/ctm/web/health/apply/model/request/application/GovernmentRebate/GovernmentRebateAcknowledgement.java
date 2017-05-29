package com.ctm.web.health.apply.model.request.application.GovernmentRebate;


import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import java.time.LocalDate;
import java.util.Optional;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class GovernmentRebateAcknowledgement {

    private ApplicantCovered applicationCovered;

    private EntitledToMedicare entitledToMedicare;

    private GovernmentRebateDeclaration governmentRebateDeclaration;

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate declarationDate;

    public GovernmentRebateAcknowledgement(final ApplicantCovered applicantCovered,
                                           final EntitledToMedicare entitledToMedicare,
                                           final GovernmentRebateDeclaration governmentRebateDeclaration,
                                           final LocalDate declarationDate ){
        this.applicationCovered = applicantCovered;
        this.entitledToMedicare = entitledToMedicare;
        this.governmentRebateDeclaration = governmentRebateDeclaration;
        this.declarationDate = declarationDate;
    }

    public ApplicantCovered getApplicationCovered() {
        return applicationCovered;
    }

    public EntitledToMedicare getEntitledToMedicare() {
        return entitledToMedicare;
    }

    public GovernmentRebateDeclaration getGovernmentRebateDeclaration() {
        return governmentRebateDeclaration;
    }

    public LocalDate getDeclarationDate() {
        return declarationDate;
    }
}
