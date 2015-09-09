package com.ctm.services.segment;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.joda.time.LocalDate;
import org.joda.time.Years;

import com.ctm.model.Error;
import com.ctm.model.segment.Segment;
import com.ctm.model.segment.SegmentRule;
import com.ctm.model.segment.SegmentRule.FilterBy;
import com.ctm.model.segment.SegmentRule.Option;
import com.ctm.utils.FormDateUtils;
import com.disc_au.web.go.Data;

import static com.ctm.logging.LoggingArguments.kv;

public class SegmentRulesService {
	private static final Logger logger = LoggerFactory.getLogger(SegmentRulesService.class.getName());

	public boolean filter(Segment segment, List<SegmentRule> segmentRules, Data data) {
		if(segmentRules != null && !segmentRules.isEmpty()){
			for(SegmentRule segmentRule : segmentRules){
				if (!filterSingle(segmentRule.getFilterBy(), data.getStringNotNull(segmentRule.getXpath()), segmentRule.getValue(), segmentRule.getOption())) {
					Error error = new Error("No match found in data bucket for segment rules");
					segment.addError(error);
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
			logger.error("Error filtering by range {},{},{}", kv("formValue", formValue), kv("ruleValue", ruleValue),
				kv("option", option));
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
			logger.error("Error filtering by date range {},{},{}", kv("formValue", formValue), kv("ruleValue", ruleValue),
				kv("option", option));
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
			logger.error("Error filtering by age {},{},{}", kv("formvalue", formValue), kv("ruleValue", ruleValue),
				kv("option", option));
		}
		return false;
	}
}
