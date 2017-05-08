package com.ctm.web.health.apply.model.request.application.GovernmentRebate;


import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import java.time.LocalDate;
import java.util.Optional;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class GovernmentRebateAck {

    private ApplicantCovered applicationCovered;

    private EntitledToMedicare entitledToMedicare;

    private GovtRebateDeclaration govtRebateDeclaration;

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate declarationDate;

    public GovernmentRebateAck(final ApplicantCovered applicantCovered, final EntitledToMedicare claimMedicare,
                                    final GovtRebateDeclaration govtRebateDeclaration, final LocalDate declarationDate ){
        this.applicationCovered = applicantCovered;
        this.entitledToMedicare = entitledToMedicare;
        this.govtRebateDeclaration = govtRebateDeclaration;
        this.declarationDate = declarationDate;
    }

    public Optional<ApplicantCovered> getApplicationCovered() {
        return Optional.ofNullable(applicationCovered);
    }

    public Optional<EntitledToMedicare> getEntitledToMedicare() {
        return Optional.ofNullable(entitledToMedicare);
    }

    public Optional<GovtRebateDeclaration> getGovtRebateDeclaration() {
        return Optional.ofNullable(govtRebateDeclaration);
    }

    public Optional<LocalDate> getDeclarationDate() {
        return Optional.ofNullable(declarationDate);
    }
}
