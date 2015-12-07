package com.ctm.web.health.email.formatter;

import com.ctm.web.core.email.formatter.ExactTargetFormatter;
import com.ctm.web.core.email.model.ExactTargetEmailModel;
import com.ctm.web.health.email.model.HealthApplicationEmailModel;
import org.apache.commons.lang3.StringUtils;

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

        return emailModel;
    }
}
