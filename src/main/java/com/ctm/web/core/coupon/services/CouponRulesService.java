package com.ctm.web.core.coupon.services;

import com.ctm.web.core.coupon.model.Coupon;
import com.ctm.web.core.coupon.model.CouponRule;
import com.ctm.web.core.coupon.model.CouponRule.FilterBy;
import com.ctm.web.core.coupon.model.CouponRule.Option;
import com.ctm.web.core.model.Error;
import com.ctm.web.core.utils.FormDateUtils;
import com.ctm.web.core.web.go.Data;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.LocalDate;
import org.joda.time.Years;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class CouponRulesService {
	private static final Logger LOGGER = LoggerFactory.getLogger(CouponRulesService.class);

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
                case AGE:
                    return filterByAge(formValue, ruleValue, option);
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
			LOGGER.error("Failed filtering coupon by range {}, {}, {}", kv("formValue", formValue), kv("ruleValue", ruleValue), kv("option", option));
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
			LOGGER.error("Failed filtering coupon by date range {}, {}, {}", kv("formValue", formValue), kv("ruleValue", ruleValue), kv("option", option));
		}
		return false;
	}

    private boolean filterByAge(String formValue, String ruleValue, Option option) {
        try{
            LocalDate birthDate = new LocalDate(FormDateUtils.parseDateFromForm(formValue));
            LocalDate now = new LocalDate();
            int age = Years.yearsBetween(birthDate, now).getYears();
            int ageLimit = Integer.parseInt(ruleValue);

            switch(option){
                case MIN:
                    return age >= ageLimit;
                case MAX:
                    return age <= ageLimit;
                default:
                    return false;
            }
        }
        catch (Exception e) {
            LOGGER.error("Error filtering by age {},{},{}", kv("formvalue", formValue), kv("ruleValue", ruleValue),
                    kv("option", option));
        }
        return false;
    }
}
