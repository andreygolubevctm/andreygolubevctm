package com.ctm.model.health;

import com.disc_au.web.go.xml.XmlNode;

public class HealthPricePremiumRange {

	private double minYearlyPremium = 0;
	private double maxYearlyPremium = 0;

	private double minFortnightlyPremium = 0;
	private double maxFortnightlyPremium = 0;

	private double minMonthlyPremium = 0;
	private double maxMonthlyPremium = 0;

	public double getMinYearlyPremium() {
		return minYearlyPremium;
	}

	public void setMinYearlyPremium(double minYearlyPremium) {
		this.minYearlyPremium = minYearlyPremium;
	}

	public double getMinFortnightlyPremium() {
		return minFortnightlyPremium;
	}

	public void setMinFortnightlyPremium(double minFortnightlyPremium) {
		this.minFortnightlyPremium = minFortnightlyPremium;
	}

	public double getMinMonthlyPremium() {
		return minMonthlyPremium;
	}

	public void setMinMonthlyPremium(double minMonthlyPremium) {
		this.minMonthlyPremium = minMonthlyPremium;
	}


	public double getMaxYearlyPremium() {
		return maxYearlyPremium;
	}

	public void setMaxYearlyPremium(double maxYearlyPremium) {
		this.maxYearlyPremium = maxYearlyPremium;
	}

	public double getMaxFortnightlyPremium() {
		return maxFortnightlyPremium;
	}

	public void setMaxFortnightlyPremium(double maxFortnightlyPremium) {
		this.maxFortnightlyPremium = maxFortnightlyPremium;
	}

	public double getMaxMonthlyPremium() {
		return maxMonthlyPremium;
	}

	public void setMaxMonthlyPremium(double maxMonthlyPremium) {
		this.maxMonthlyPremium = maxMonthlyPremium;
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
