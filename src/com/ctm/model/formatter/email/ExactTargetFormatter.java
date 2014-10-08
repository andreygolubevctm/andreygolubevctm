package com.ctm.model.formatter.email;

import com.ctm.model.email.EmailModel;
import com.ctm.model.email.ExactTargetEmailModel;

public abstract class ExactTargetFormatter<T extends EmailModel> {

	protected static final String IMAGE_BASE_URL = "http://image.e.comparethemarket.com.au/lib/fe9b12727466047b76/m/1/";

	protected ExactTargetEmailModel emailModel;

	protected abstract ExactTargetEmailModel formatXml(T model);

	public ExactTargetEmailModel convertToExactTarget(T model) {
		formatXml(model);
		emailModel.setBrand(model.getBrand());
		emailModel.setClientId(model.getClientId());
		emailModel.setCustomerKey(model.getCustomerKey());
		emailModel.setEnv(model.getEnv());

		emailModel.setEmailAddress(model.getEmailAddress());
		emailModel.setSubscriberKey(model.getSubscriberKey());

		emailModel.setAttribute("UnsubscribeURL", model.getUnsubscribeURL());
		return emailModel;
	}

	public String parseOptIn(boolean optIn){
		return optIn ? "Y" : "N";
	}

}
