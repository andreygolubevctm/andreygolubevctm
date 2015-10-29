package com.ctm.web.health.model;

import com.disc_au.web.go.xml.XmlNode;

public class HealthPricePremiumRange {

	// Yearly premium with rebate applied rounded
	private double minYearlyPremium = 0;
	// Yearly premium with rebate applied rounded
	private double maxYearlyPremium = 0;
	// Base yearly premium without rebate applied not rounded
	private double maxYearlyPremiumBase;

	// Monthly premium with rebate applied rounded
	private double minMonthlyPremium = 0;
	// Monthly premium with rebate applied rounded
	private double maxMonthlyPremium = 0;
	// Base monthly premium without rebate applied not rounded
	private double maxMonthlyPremiumBase;

	// Fortnightly premium with rebate applied rounded
	private double minFortnightlyPremium = 0;
	// Fortnightly premium with rebate applied rounded
	private double maxFortnightlyPremium = 0;
	// Base fortnightly premium without rebate applied not rounded
	private double maxFortnightlyPremiumBase;

	public double getMinYearlyPremium() {
		return minYearlyPremium;
	}

	public double getMaxYearlyPremium() {
		return maxYearlyPremium;
	}

	public double getMaxYearlyPremiumBase() {
		return maxYearlyPremiumBase;
	}

	public double getMinMonthlyPremium() {
		return minMonthlyPremium;
	}

	public double getMaxMonthlyPremium() {
		return maxMonthlyPremium;
	}

	public double getMaxMonthlyPremiumBase() {
		return maxMonthlyPremiumBase;
	}

	public double getMinFortnightlyPremium() {
		return minFortnightlyPremium;
	}

	public double getMaxFortnightlyPremium() {
		return maxFortnightlyPremium;
	}

	public double getMaxFortnightlyPremiumBase() {
		return maxFortnightlyPremiumBase;
	}

	public void setMinMonthlyPremium(double minMonthlyPremium) {
		this.minMonthlyPremium = minMonthlyPremium;
	}

	public void setMaxYearlyPremium(double maxYearlyPremium) {
		this.maxYearlyPremium = maxYearlyPremium;
	}

	public void setMaxYearlyPremiumBase(double maxYearlyPremiumBase) {
		this.maxYearlyPremiumBase = maxYearlyPremiumBase;
	}

	public void setMaxFortnightlyPremium(double maxFortnightlyPremium) {
		this.maxFortnightlyPremium = maxFortnightlyPremium;
	}

	public void setMaxFortnightlyPremiumBase(double maxFortnightlyPremiumBase) {
		this.maxFortnightlyPremiumBase = maxFortnightlyPremiumBase;
	}

	public void setMinFortnightlyPremium(double minFortnightlyPremium) {
		this.minFortnightlyPremium = minFortnightlyPremium;
	}

	public void setMaxMonthlyPremium(double maxMonthlyPremium) {
		this.maxMonthlyPremium = maxMonthlyPremium;
	}

	public void setMaxMonthlyPremiumBase(double maxMonthlyPremiumBase) {
		this.maxMonthlyPremiumBase = maxMonthlyPremiumBase;
	}

	public void setMinYearlyPremium(double minYearlyPremium) {
		this.minYearlyPremium = minYearlyPremium;
	}

	/**
	 * Output the premium range in xml format
	 * @return 	XML string in the following format:
	 *  <premiumRange>
	 * 		<yearly>
	 * 			<min></min>
	 * 			<max></max>
	 * 		</yearly>
	 * 		<monthly>
	 * 			<min></min>
	 * 			<max></max>
	 * 		</monthly>
	 * 		<fortnightly>
	 * 			<min></min>
	 * 			<max></max>
	 * 		</fortnightly>
	 * </premiumRange>
	 */
	public String toXML() {
		XmlNode xmlNode = new XmlNode("premiumRange");

		XmlNode yearly = new XmlNode("yearly");
		xmlNode.addChild(yearly);
		yearly.put("min", getMinYearlyPremium());
		yearly.put("max", getMaxYearlyPremium());

		XmlNode monthly = new XmlNode("monthly");
		monthly.put("min", getMinMonthlyPremium());
		monthly.put("max", getMaxMonthlyPremium());
		xmlNode.addChild(monthly);

		XmlNode fortnightly = new XmlNode("fortnightly");
		fortnightly.put("min", getMinFortnightlyPremium());
		fortnightly.put("max", getMaxFortnightlyPremium());
		xmlNode.addChild(fortnightly);

		return xmlNode.getXML();
	}

}
