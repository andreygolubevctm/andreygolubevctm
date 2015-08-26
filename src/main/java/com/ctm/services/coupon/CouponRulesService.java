package com.ctm.services.coupon;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.model.Error;
import com.ctm.model.coupon.Coupon;
import com.ctm.model.coupon.CouponRule;
import com.ctm.model.coupon.CouponRule.FilterBy;
import com.ctm.model.coupon.CouponRule.Option;
import com.ctm.utils.FormDateUtils;
import com.disc_au.web.go.Data;

public class CouponRulesService {
	private static final Logger logger = LoggerFactory.getLogger(CouponRulesService.class.getName());

	public boolean filterAllRules(Coupon coupon, Data data) {
		return filter(coupon, coupon.getCouponRules(), data);
	}

	public boolean filterHardRules(Coupon coupon, Data data) {
		List<CouponRule> hardCouponRules = new ArrayList<CouponRule>();

		for(CouponRule couponRule : coupon.getCouponRules()){
			if(couponRule.isHard()) hardCouponRules.add(couponRule);
		}

		return filter(coupon, hardCouponRules, data);
	}

	private boolean filter(Coupon coupon, List<CouponRule> couponRules, Data data) {
		if(couponRules != null && !couponRules.isEmpty()){
			for(CouponRule couponRule : couponRules){
				if (!filterSingle(couponRule.getFilterBy(), data.getStringNotNull(couponRule.getXpath()), couponRule.getValue(), couponRule.getOption())) {
					if (couponRule.getErrorMessage() != null && !couponRule.getErrorMessage().equals("")) {
						Error error = new Error(couponRule.getErrorMessage());
						coupon.addError(error);
					}
					return false;
				}
			}
		}
		return true; // also pass when no rules
	}

	private boolean filterSingle(FilterBy filterBy, String formValue, String ruleValue, Option option) {
		if (formValue != null && ruleValue != null) {
			switch(filterBy){
				case VALUE:
					return filterByValue(formValue, ruleValue, option);
				case RANGE:
					return filterByRange(formValue, ruleValue, option);
				case DATE_RANGE:
					return filterByDateRange(formValue, ruleValue, option);
			}
		}
		return false;
	}

	private boolean filterByValue(String formValue, String ruleValue, Option option) {
		switch(option){
			case EQUALS:
				return formValue.equalsIgnoreCase(ruleValue);
			case NOT_EQUALS:
				return !formValue.equalsIgnoreCase(ruleValue);
			case IN_ARRAY:
				List<String> ruleValuelist = Arrays.asList(StringUtils.split(ruleValue.toUpperCase(), ","));
				return ruleValuelist.contains(formValue.toUpperCase());
			default:
				return false;
		}
	}

	private boolean filterByRange(String formValue, String ruleValue, Option option) {
		try{
			// parser for string value in case the number format is currency
			BigDecimal formValueDecimal = new BigDecimal(formValue.replaceAll("$|,", ""));
			BigDecimal ruleValueDecimal = new BigDecimal(ruleValue.replaceAll("$|,", ""));

			switch(option){
				case MIN:
					return formValueDecimal.doubleValue() >= ruleValueDecimal.doubleValue();
				case MAX:
					return formValueDecimal.doubleValue() <= ruleValueDecimal.doubleValue();
				default:
					return false;
			}
		}
		catch (Exception e) {
			logger.error("{}",e);
		}
		return false;
	}

	private boolean filterByDateRange(String formValue, String ruleValue, Option option) {
		try{
			Date formValueDate = FormDateUtils.parseDateFromForm(formValue);
			Date ruleValueDate = FormDateUtils.parseDateFromForm(ruleValue);

			switch(option){
				case MIN:
					return !formValueDate.before(ruleValueDate);
				case MAX:
					return !formValueDate.after(ruleValueDate);
				default:
					return false;
			}
		}
		catch (Exception e) {
			logger.error("{}",e);
		}
		return false;
	}
}
