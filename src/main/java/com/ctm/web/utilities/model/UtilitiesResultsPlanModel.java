package com.ctm.web.utilities.model;

import com.ctm.model.AbstractJsonModel;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.math.RoundingMode;

import static com.ctm.logging.LoggingArguments.kv;


public class UtilitiesResultsPlanModel extends AbstractJsonModel {

	private static final Logger LOGGER = LoggerFactory.getLogger(UtilitiesResultsPlanModel.class);

	private String retailerId;
	private String retailerName;
	private int productId;
	private String planName;
	private String offerType;
	private String contractPeriod;
	private String cancellationFees;

	private String payontimeDiscounts = "0";
	private String ebillingDiscounts = "0";
	private String guaranteedDiscounts = "0";
	private String otherDiscounts = "0";
	private String discountDetails = "0";

	private double quarterlyEnergySavings = 0;
	private double quarterlyGasSavings = 0;
	private double percentageElectricitySavings = 0;
	private double percentageGasSavings = 0;
	private double yearlyElectricitySavings = 0;
	private double yearlyGasSavings = 0;
	private double annualPreviousCost = 0;
	private double annualNewCost = 0;

	public UtilitiesResultsPlanModel(){

	}

	public String getRetailerId() {
		return retailerId;
	}

	public void setRetailerId(String retailerId) {
		this.retailerId = retailerId;
	}

	public String getRetailerName() {
		return retailerName;
	}

	public void setRetailerName(String retailerName) {
		this.retailerName = retailerName;
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public String getPlanName() {
		return planName;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	}

	public String getOfferType() {
		return offerType;
	}

	public void setOfferType(String offerType) {
		this.offerType = offerType;
	}

	public String getContractPeriod() {
		return contractPeriod;
	}

	public void setContractPeriod(String contractPeriod) {
		this.contractPeriod = contractPeriod;
	}

	public String getCancellationFees() {
		return cancellationFees;
	}

	public void setCancellationFees(String cancellationFees) {
		this.cancellationFees = cancellationFees;
	}

	public String getPayontimeDiscounts() {
		return payontimeDiscounts;
	}

	public void setPayontimeDiscounts(String payontimeDiscounts) {
		this.payontimeDiscounts = payontimeDiscounts;
	}

	public String getEbillingDiscounts() {
		return ebillingDiscounts;
	}

	public void setEbillingDiscounts(String ebillingDiscounts) {
		this.ebillingDiscounts = ebillingDiscounts;
	}

	public String getGuaranteedDiscounts() {
		return guaranteedDiscounts;
	}

	public void setGuaranteedDiscounts(String guaranteedDiscounts) {
		this.guaranteedDiscounts = guaranteedDiscounts;
	}

	public String getOtherDiscounts() {
		return otherDiscounts;
	}

	public void setOtherDiscounts(String otherDiscounts) {
		this.otherDiscounts = otherDiscounts;
	}

	public String getDiscountDetails() {
		return discountDetails;
	}

	public void setDiscountDetails(String discountDetails) {
		this.discountDetails = discountDetails;
	}

	public double getQuarterlyEnergySavings() {
		return quarterlyEnergySavings;
	}

	public void setQuarterlyEnergySavings(double quarterlyEnergySavings) {
		this.quarterlyEnergySavings = quarterlyEnergySavings;
	}

	public double getQuarterlyGasSavings() {
		return quarterlyGasSavings;
	}

	public void setQuarterlyGasSavings(double quarterlyGasSavings) {
		this.quarterlyGasSavings = quarterlyGasSavings;
	}

	public double getPercentageElectricitySavings() {
		return percentageElectricitySavings;
	}

	public void setPercentageElectricitySavings(double percentageElectricitySavings) {
		this.percentageElectricitySavings = percentageElectricitySavings;
	}

	public double getPercentageGasSavings() {
		return percentageGasSavings;
	}

	public void setPercentageGasSavings(double percentageGasSavings) {
		this.percentageGasSavings = percentageGasSavings;
	}

	public double getYearlyElectricitySavings() {
		return yearlyElectricitySavings;
	}

	public void setYearlyElectricitySavings(double yearlyElectricitySavings) {
		this.yearlyElectricitySavings = yearlyElectricitySavings;
	}

	public double getYearlyGasSavings() {
		return yearlyGasSavings;
	}

	public void setYearlyGasSavings(double yearlyGasSavings) {
		this.yearlyGasSavings = yearlyGasSavings;
	}

	public double getAnnualPreviousCost() {
		return annualPreviousCost;
	}

	public void setAnnualPreviousCost(double annualPreviousCost) {
		this.annualPreviousCost = annualPreviousCost;
	}

	public double getAnnualNewCost() {
		return annualNewCost;
	}

	public void setAnnualNewCost(double annualNewCost) {
		this.annualNewCost = annualNewCost;
	}


	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("available", "Y");

		json.put("planId", getProductId());
		json.put("planName", getPlanName());

		json.put("retailerName", getRetailerName());
		json.put("retailerId", getRetailerId());

		json.put("price", getAnnualNewCost());
		json.put("previousPrice", getAnnualPreviousCost());
		json.put("contractPeriod", getContractPeriod());
		json.put("cancellationFees", getCancellationFees());

		json.put("payontimeDiscounts", getPayontimeDiscounts());
		json.put("ebillingDiscounts", getEbillingDiscounts());
		json.put("guaranteedDiscounts", getGuaranteedDiscounts());
		json.put("otherDiscounts", getOtherDiscounts());
		json.put("discountDetails", getDiscountDetails());

		BigDecimal bd = new BigDecimal(getYearlyElectricitySavings() + getYearlyGasSavings());
		bd = bd.setScale(2, RoundingMode.HALF_UP);

		double yearlySavingsTotal = bd.doubleValue();
		json.put("yearlySavings", yearlySavingsTotal);

		return json;
	}

	public Boolean populateFromThoughtWorldJson(JSONObject json){
		try {

			setCancellationFees(json.getString("cancellation_fees"));
			setContractPeriod(json.getString("contract_period"));
			setOfferType(json.getString("offer_type"));
			setRetailerId(json.getString("retailer_id"));
			setRetailerName(json.getString("retailer_name"));

			setPlanName(json.getString("plan_name"));
			setProductId(json.getInt("product_id"));

			if(json.isNull("payontime_discounts") == false) setPayontimeDiscounts(json.getString("payontime_discounts"));
			if(json.isNull("ebilling_discounts") == false) setEbillingDiscounts(json.getString("ebilling_discounts"));
			if(json.isNull("guaranteed_discounts") == false) setGuaranteedDiscounts(json.getString("guaranteed_discounts"));
			if(json.isNull("other_discounts") == false) setOtherDiscounts(json.getString("other_discounts"));
			if(json.isNull("discount_details") == false) setDiscountDetails(json.getString("discount_details"));

			if(json.isNull("percentage_elec_savings") == false) setPercentageElectricitySavings(json.getDouble("percentage_elec_savings"));
			if(json.isNull("percentage_gas_savings") == false) setPercentageGasSavings(json.getDouble("percentage_gas_savings"));

			if(json.isNull("quartely_elec_savings") == false) setQuarterlyEnergySavings(json.getDouble("quartely_elec_savings"));
			if(json.isNull("quartely_gas_savings") == false) setQuarterlyGasSavings(json.getDouble("quartely_gas_savings"));

			if(json.isNull("yearly_elec_savings") == false) setYearlyElectricitySavings(json.getDouble("yearly_elec_savings"));
			if(json.isNull("yearly_gas_savings") == false) setYearlyGasSavings(json.getDouble("yearly_gas_savings"));

			if(json.isNull("annual_new_cost") == false) setAnnualNewCost(json.getDouble("annual_new_cost"));
			if(json.isNull("annual_prev_cost") == false) setAnnualPreviousCost(json.getDouble("annual_prev_cost"));

		} catch (JSONException e) {
			LOGGER.debug("Failed to populate utilities results plan model {}", kv("json", json), e);
			return false;
		}

		return true;

	}

	@Override
	public String toString() {
		return "UtilitiesResultsPlanModel{" +
				"retailerId='" + retailerId + '\'' +
				", retailerName='" + retailerName + '\'' +
				", productId=" + productId +
				", planName='" + planName + '\'' +
				", offerType='" + offerType + '\'' +
				", contractPeriod='" + contractPeriod + '\'' +
				", cancellationFees='" + cancellationFees + '\'' +
				", payontimeDiscounts='" + payontimeDiscounts + '\'' +
				", ebillingDiscounts='" + ebillingDiscounts + '\'' +
				", guaranteedDiscounts='" + guaranteedDiscounts + '\'' +
				", otherDiscounts='" + otherDiscounts + '\'' +
				", discountDetails='" + discountDetails + '\'' +
				", quarterlyEnergySavings=" + quarterlyEnergySavings +
				", quarterlyGasSavings=" + quarterlyGasSavings +
				", percentageElectricitySavings=" + percentageElectricitySavings +
				", percentageGasSavings=" + percentageGasSavings +
				", yearlyElectricitySavings=" + yearlyElectricitySavings +
				", yearlyGasSavings=" + yearlyGasSavings +
				", annualPreviousCost=" + annualPreviousCost +
				", annualNewCost=" + annualNewCost +
				'}';
	}
}
