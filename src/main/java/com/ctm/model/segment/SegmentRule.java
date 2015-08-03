package com.ctm.model.segment;

/**
 * This model represents the ctm.conpon_rules database table.
 *
 */
public class SegmentRule {

	public enum FilterBy {
		VALUE ("value"),
		RANGE ("range"),
		DATE_RANGE ("dateRange"),
		AGE ("age");

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
	private String xpath;
	private FilterBy filterBy;
	private Option option;
	private String value;


	public int getRuleId() {
		return ruleId;
	}
	public void setRuleId(int ruleId) {
		this.ruleId = ruleId;
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
}