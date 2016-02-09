package com.ctm.web.health.model.request;

import javax.validation.Valid;


public class HealthApplicationRequest {

	public String loading;
	public String membership;
	public double rebateValue;
	public double loadingValue;
	public Integer income;
	public boolean hasRebate;

	@Valid
	public Application application;

	@Valid
	public Payment payment;

	@Override
	public String toString() {
		return "loading:" + loading + ",membership:" + membership +
				",rebateValue:" + rebateValue +
				"loadingValue:" + loadingValue + ",income:" + income +
				",hasRebate:" + hasRebate + ",application: " +  application +
				",payment: " + payment;
	}

}