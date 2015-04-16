package com.ctm.model.coupon;

/**
 * This model represents the ctm.conpon_rules database table.
 *
 */
public class CouponRule {

	public enum FilterBy {
		VALUE ("value"),
		RANGE ("range"),
		DATE_RANGE ("dateRange");

		private final String code;

		FilterBy(String code) {
			this.code = code;
		}

		public String getCode() {
			return code;
		}

		/**
		 * Find a filterBy by its code.
		 * @param code Code e.g. range
		 */
		public static FilterBy findByCode(String code) {
			for (FilterBy t : FilterBy.values()) {
				if (code.equalsIgnoreCase(t.getCode())) {
					return t;
				}
			}
			return null;
		}
	}

	public enum Option {
		MIN ("min"),
		MAX ("max"),
		IN_ARRAY ("inArray"),
		EQUALS ("equals"),
		NOT_EQUALS ("notEquals");

		private final String code;

		Option(String code) {
			this.code = code;
		}

		public String getCode() {
			return code;
		}

		/**
		 * Find a option by its code.
		 * @param code Code e.g. min
		 */
		public static Option findByCode(String code) {
			for (Option t : Option.values()) {
				if (code.equalsIgnoreCase(t.getCode())) {
					return t;
				}
			}
			return null;
		}
	}

	private int ruleId;
	private int couponId;
	private String xpath;
	private FilterBy filterBy;
	private Option option;
	private String value;
	private boolean isHard;
	private String errorMessage;


	public int getRuleId() {
		return ruleId;
	}
	public void setRuleId(int ruleId) {
		this.ruleId = ruleId;
	}
	public int getCouponId() {
		return couponId;
	}
	public void setCouponId(int couponId) {
		this.couponId = couponId;
	}
	public String getXpath() {
		return xpath;
	}
	public void setXpath(String xpath) {
		this.xpath = xpath;
	}
	public FilterBy getFilterBy() {
		return filterBy;
	}
	public void setFilterBy(FilterBy filterBy) {
		this.filterBy = filterBy;
	}
	public void setFilterBy(String filterByString) {
		this.filterBy = FilterBy.findByCode(filterByString);
	}
	public Option getOption() {
		return option;
	}
	public void setOption(Option option) {
		this.option = option;
	}
	public void setOption(String optionString) {
		this.option = Option.findByCode(optionString);
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public boolean isHard() {
		return isHard;
	}
	public void setHard(boolean isHard) {
		this.isHard = isHard;
	}
	public String getErrorMessage() {
		return errorMessage;
	}
	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
}