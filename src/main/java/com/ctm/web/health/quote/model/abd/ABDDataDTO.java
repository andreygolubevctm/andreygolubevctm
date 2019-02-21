package com.ctm.web.health.quote.model.abd;

import com.ctm.web.health.model.form.*;
import net.logstash.logback.encoder.org.apache.commons.lang.StringUtils;

import java.util.Optional;
import java.util.function.Predicate;

public class ABDDataDTO {

    private final Optional<String> primary;
    private final Optional<String> partner;

    /**
     * Factory method for selecting the correct dates of birth for use when calculating ABD.
     *
     * @param quoteRequest the quote request containing the applicants details.
     * @return an instance of {@link ABDDataDTO} containing the relevant details for ABD calculation
     */
    public static ABDDataDTO create(HealthQuote quoteRequest) {
        // When using Preload, the applicant data can be present but empty.
        Predicate<Application> verifyApplicantPresent = primaryApplicant ->
                StringUtils.isNotBlank(Optional.of(primaryApplicant).map(Application::getPrimary).map(Person::getDob).orElse(null));

        Optional<Application> application = Optional.ofNullable(quoteRequest)
                .map(HealthQuote::getApplication)
                .filter(verifyApplicantPresent);

        Optional<HealthCover> cover = Optional.ofNullable(quoteRequest).map(HealthQuote::getHealthCover);

        final Optional<String> primary;
        final Optional<String> partner;

        if (application.isPresent()) {
            primary = application.map(Application::getPrimary).map(Person::getDob);
            partner = application.map(Application::getPartner).map(Person::getDob);
        } else {
            primary = cover.map(HealthCover::getPrimary).map(Insured::getDob);
            partner = cover.map(HealthCover::getPartner).map(Insured::getDob);
        }
        return new ABDDataDTO(primary, partner);
    }

    public ABDDataDTO(Optional<String> primary, Optional<String> partner) {
        this.primary = primary;
        this.partner = partner;
    }


    public Optional<String> getPrimaryApplicantDob() {
        return primary;
    }

    public Optional<String> getPartnerApplicantDob() {
        return partner;
    }

}
