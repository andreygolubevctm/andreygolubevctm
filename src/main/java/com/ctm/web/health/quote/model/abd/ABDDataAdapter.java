package com.ctm.web.health.quote.model.abd;

import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.Fund;
import com.ctm.web.health.model.form.HealthCover;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Insured;
import com.ctm.web.health.model.form.Person;
import com.ctm.web.health.model.form.PreviousFund;
import net.logstash.logback.encoder.org.apache.commons.lang.StringUtils;

import java.time.LocalDate;
import java.util.Optional;
import java.util.function.Predicate;

public class ABDDataAdapter {

    private final Optional<LocalDate> primary;
    private final Optional<LocalDate> partner;
    private final Optional<LocalDate> primaryPreviousPolicyStart;
    private final Optional<LocalDate> partnerPreviousPolicyStart;

    /**
     * Factory method for selecting the correct dates of birth for use when calculating ABD.
     *
     * @param quoteRequest the quote request containing the applicants details.
     * @param request
     * @param isSimples
     * @return an instance of {@link ABDDataAdapter} containing the relevant details for ABD calculation
     */
    public static ABDDataAdapter create(HealthQuote quoteRequest, HealthRequest request, boolean isSimples) {
        // When using Preload, the applicant data can be present but empty.
        Predicate<Application> verifyApplicantPresent = primaryApplicant ->
                StringUtils.isNotBlank(Optional.of(primaryApplicant).map(Application::getPrimary).map(Person::getDob).orElse(null));

        Optional<Application> application = Optional.ofNullable(quoteRequest)
                .map(HealthQuote::getApplication)
                .filter(verifyApplicantPresent);

        Optional<HealthCover> cover = Optional.ofNullable(quoteRequest).map(HealthQuote::getHealthCover);

        final Optional<LocalDate> primary;
        final Optional<LocalDate> partner;

        if (application.isPresent()) {
            primary = application.map(Application::getPrimary).map(Person::getDob).flatMap(ABD.safeParseDate);
            partner = application.map(Application::getPartner).map(Person::getDob).flatMap(ABD.safeParseDate);
        } else {
            primary = cover.map(HealthCover::getPrimary).map(Insured::getDob).flatMap(ABD.safeParseDate);
            partner = cover.map(HealthCover::getPartner).map(Insured::getDob).flatMap(ABD.safeParseDate);
        }

        final Optional<LocalDate> primaryABDStart;
        final Optional<LocalDate> partnerABDStart;

        if (isSimples) {
            primaryABDStart = cover.map(HealthCover::getPrimary).map(Insured::getAbdPolicyStart).flatMap(ABD.safeParseDate);
            partnerABDStart = cover.map(HealthCover::getPartner).map(Insured::getAbdPolicyStart).flatMap(ABD.safeParseDate);
        } else {
            Optional<PreviousFund> previousFund = Optional.of(request)
                    .map(HealthRequest::getQuote)
                    .map(HealthQuote::getPreviousfund);
            primaryABDStart = previousFund.map(PreviousFund::getPrimary).map(Fund::getAbdPolicyStart).flatMap(ABD.safeParseDate);
            partnerABDStart = previousFund.map(PreviousFund::getPartner).map(Fund::getAbdPolicyStart).flatMap(ABD.safeParseDate);
        }
        return new ABDDataAdapter(primary, partner, primaryABDStart, partnerABDStart);
    }

    public ABDDataAdapter(Optional<LocalDate> primary, Optional<LocalDate> partner, Optional<LocalDate> primaryPreviousPolicyStart, Optional<LocalDate> partnerPreviousPolicyStart) {
        this.primary = primary;
        this.partner = partner;
        this.primaryPreviousPolicyStart = primaryPreviousPolicyStart;
        this.partnerPreviousPolicyStart = partnerPreviousPolicyStart;
    }


    public Optional<LocalDate> getPrimaryApplicantDob() {
        return primary;
    }

    public Optional<LocalDate> getPartnerApplicantDob() {
        return partner;
    }

    public Optional<LocalDate> getPrimaryPreviousPolicyStart() {
        return primaryPreviousPolicyStart;
    }

    public Optional<LocalDate> getPartnerPreviousPolicyStart() {
        return partnerPreviousPolicyStart;
    }
}
