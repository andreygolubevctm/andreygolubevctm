package com.ctm.web.health.email.formatter;

import com.ctm.web.core.email.formatter.ExactTargetFormatter;
import com.ctm.web.core.email.model.ExactTargetEmailModel;
import com.ctm.web.health.email.model.HealthApplicationEmailModel;
import com.ctm.web.health.email.model.PolicyHolderModel;
import org.apache.commons.lang3.StringUtils;

import java.util.concurrent.atomic.AtomicInteger;

public class HealthApplicationExactTargetFormatter extends ExactTargetFormatter<HealthApplicationEmailModel> {

    @Override
    protected ExactTargetEmailModel formatXml(HealthApplicationEmailModel model) {
        emailModel = new ExactTargetEmailModel();
        emailModel.setAttribute("SubscriberKey", model.getEmailAddress());
        emailModel.setAttribute("EmailAddress", model.getEmailAddress());
        emailModel.setAttribute("FirstName", model.getFirstName());
        if (StringUtils.isNotBlank(model.getBccEmail())) {
            emailModel.setAttribute("BCC_email", model.getBccEmail());
        }
        emailModel.setAttribute("OptIn", parseOptIn(model.isOptIn()));
        emailModel.setAttribute("OKToCall", model.getOkToCall());
        emailModel.setAttribute("PhoneNumber", model.getPhoneNumber());
        emailModel.setAttribute("QuoteRef", Long.toString(model.getTransactionId()));
        emailModel.setAttribute("CTAUrl", model.getActionUrl());
        emailModel.setAttribute("UnsubscribeURL", model.getUnsubscribeURL());
        emailModel.setAttribute("ProductName", model.getProductName());
        emailModel.setAttribute("HealthFund", model.getHealthFund());
        emailModel.setAttribute("HealthFundPhoneNo", model.getProviderPhoneNumber());
        emailModel.setAttribute("HospitalPDSUrl", model.getHospitalPdsUrl());
        emailModel.setAttribute("ExtrasPDSUrl", model.getExtrasPdsUrl());

        model.getPremiumFrequency().ifPresent(v -> emailModel.setAttribute("PremiumFrequency", v));
        model.getProviderLogo().ifPresent(v -> emailModel.setAttribute("P1ProviderLogo", v));
        model.getPremium().ifPresent(v -> emailModel.setAttribute("P1Premium", v));
        model.getPremiumLabel().ifPresent(v -> emailModel.setAttribute("P1PremiumLhcRebate", v));
        model.getHealthMembership().ifPresent(v -> emailModel.setAttribute("HealthMembership", v));
        model.getHealthSituation().ifPresent(v -> emailModel.setAttribute("HealthSituation", v));
        model.getCoverType().ifPresent(v -> emailModel.setAttribute("CoverType", v));
        model.getPremiumTotal().ifPresent(v -> emailModel.setAttribute("P1PremiumTotal", v));
        model.getPolicyStartDate().ifPresent(v -> emailModel.setAttribute("PolicyStartDate", v));
        model.getProviderEmail().ifPresent(v -> emailModel.setAttribute("P1ProviderEmail", v));

        emailModel.setAttribute("P1ProductName",model.getProductName());
        emailModel.setAttribute("P1ProviderName",model.getHealthFund());
        emailModel.setAttribute("P1ProviderPhone", model.getProviderPhoneNumber());
        emailModel.setAttribute("P1HospitalPdsUrl", model.getHospitalPdsUrl());
        emailModel.setAttribute("P1ExtrasPdsUrl",model.getExtrasPdsUrl());


        model.getPrimary().ifPresent(p -> {
            getFromPolicyHolder(emailModel, p, 1);
        });

        final AtomicInteger index = model.getPartner()
                .map(p -> {
                    getFromPolicyHolder(emailModel, p, 2);
                    return new AtomicInteger(3);
                }).orElse(new AtomicInteger(2));

        model.getDependants()
                .stream()
                .forEach(d -> getFromPolicyHolder(emailModel, d, index.getAndIncrement()));

        return emailModel;
    }

    private void getFromPolicyHolder(ExactTargetEmailModel emailModel, PolicyHolderModel p, int index) {
        emailModel.setAttribute("Applicant" +  index + "FirstName", p.getFirstName());
        emailModel.setAttribute("Applicant" +  index + "LastName", p.getLastName());
        emailModel.setAttribute("Applicant" +  index + "DOB", p.getDateOfBirth());
    }
}
