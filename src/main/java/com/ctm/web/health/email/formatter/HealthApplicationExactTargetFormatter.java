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
        emailModel.setAttribute("EmailAddr", model.getEmailAddress());
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
        model.getProviderLogo().ifPresent(v -> emailModel.setAttribute("ProviderLog", v));
        model.getPremium().ifPresent(v -> emailModel.setAttribute("Premium", v));
        model.getPremiumLabel().ifPresent(v -> emailModel.setAttribute("PremiumLabel", v));
        model.getHealthMembership().ifPresent(v -> emailModel.setAttribute("HealthMembership", v));
        model.getExcess().ifPresent(v -> emailModel.setAttribute("Excess", v));
        model.getHealthSituation().ifPresent(v -> emailModel.setAttribute("HealthSituation", v));
        model.getCoverType().ifPresent(v -> emailModel.setAttribute("CoverType", v));
        model.getPremiumTotal().ifPresent(v -> emailModel.setAttribute("PremiumTotal", v));
        model.getPolicyStartDate().ifPresent(v -> emailModel.setAttribute("PolicyStartDate", v));
        model.getProviderEmail().ifPresent(v -> emailModel.setAttribute("FundEmail", v));

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
        emailModel.setAttribute("P" +  index + "FirstName", p.getFirstName());
        emailModel.setAttribute("P" +  index + "Surname", p.getLastName());
        emailModel.setAttribute("P" +  index + "DOB", p.getDateOfBirth());
    }
}
