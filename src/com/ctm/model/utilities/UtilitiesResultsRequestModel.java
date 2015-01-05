package com.ctm.model.utilities;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

public class UtilitiesResultsRequestModel  extends AbstractJsonModel{

	public static enum FuelType  {
		Electricity, Gas, Dual;
	}

	public static enum Duration  {
		Monthly, Quarterly, Yearly;
	}

	private String postcode;
	private String suburb;
	private boolean isConnection; // true if moving to the property
	private FuelType fuelType;
	private String tariff;

	// The following is only required if the user is not moving
	private Duration electricityDuration;
	private Duration gasDuration;
	private String currentElectricitySupplier;
	private String currentGasSupplier;

	// The following are only required if customer chooses 'Use my $ to work out use'
	private float electricitySpend = 0;
	private float gasSpend = 0;

	// The following are only required if customer chooses to enter usage
	private float electrictyPeakUsage = 0;
	private float gasPeakUsage = 0;
	private float electricityOffpeakUsage = 0;
	private float gasOffpeakUsage = 0;

	private String howToEstimate;

	// The following is for their lead feed
	private String firstName;
	private String phoneNumber;
	private String referenceNumber;


	public UtilitiesResultsRequestModel(){

	}

	public String getPostcode() {
		return postcode;
	}

	public void setPostcode(String postCode) {
		this.postcode = postCode;
	}

	public String getSuburb() {
		return suburb;
	}

	public void setSuburb(String suburb) {
		this.suburb = suburb;
	}

	public boolean isConnection() {
		return isConnection;
	}

	public void setConnection(boolean isConnection) {
		this.isConnection = isConnection;
	}

	public FuelType getFuelType() {
		return fuelType;
	}

	public void setFuelType(FuelType fuelType) {
		this.fuelType = fuelType;
	}

	public String getTariff() {
		return tariff;
	}

	public void setTariff(String tariff) {
		this.tariff = tariff;
	}

	public Duration getElectricityDuration() {
		return electricityDuration;
	}

	public void setElectricityDuration(Duration electricityDuration) {
		this.electricityDuration = electricityDuration;
	}

	public Duration getGasDuration() {
		return gasDuration;
	}

	public void setGasDuration(Duration gasDuration) {
		this.gasDuration = gasDuration;
	}

	public String getCurrentElectricitySupplier() {
		return currentElectricitySupplier;
	}

	public void setCurrentElectricitySupplier(String currentElectricitySupplier) {
		this.currentElectricitySupplier = currentElectricitySupplier;
	}

	public String getCurrentGasSupplier() {
		return currentGasSupplier;
	}

	public void setCurrentGasSupplier(String currentGasSupplier) {
		this.currentGasSupplier = currentGasSupplier;
	}

	public float getElectricitySpend() {
		return electricitySpend;
	}

	public void setElectricitySpend(float electricitySpend) {
		this.electricitySpend = electricitySpend;
	}

	public float getGasSpend() {
		return gasSpend;
	}

	public void setGasSpend(float gasSpend) {
		this.gasSpend = gasSpend;
	}

	public float getElectrictyPeakUsage() {
		return electrictyPeakUsage;
	}

	public void setElectrictyPeakUsage(float electrictyPeakUsage) {
		this.electrictyPeakUsage = electrictyPeakUsage;
	}

	public float getGasPeakUsage() {
		return gasPeakUsage;
	}

	public void setGasPeakUsage(float gasPeakUsage) {
		this.gasPeakUsage = gasPeakUsage;
	}

	public float getElectricityOffpeakUsage() {
		return electricityOffpeakUsage;
	}

	public void setElectricityOffpeakUsage(float electricityOffpeakUsage) {
		this.electricityOffpeakUsage = electricityOffpeakUsage;
	}

	public float getGasOffpeakUsage() {
		return gasOffpeakUsage;
	}

	public void setGasOffpeakUsage(float gasOffpeakUsage) {
		this.gasOffpeakUsage = gasOffpeakUsage;
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("postcode", getPostcode());
		json.put("suburb", getSuburb());
		json.put("is_connection", convertBooleanToString(isConnection()));
		json.put("fuel_type", getFuelType());

		if(getHowToEstimate().equals("U")){
			json.put("elec_peak_usage", getElectrictyPeakUsage());
			json.put("gas_peak_usage", getGasPeakUsage());
			json.put("elec_offpeak_usage", getElectricityOffpeakUsage());
			json.put("gas_offpeak_usage", getGasOffpeakUsage());
		} else if(getHowToEstimate().equals("S")){
			json.put("elec_money_spend", getElectricitySpend());
			json.put("gas_money_spend", getGasSpend());
		}

		json.put("elec_duration", getElectricityDuration());
		json.put("gas_duration", getGasDuration());

		if(isConnection() == false  || (isConnection() && getHowToEstimate().equals("U"))){
			json.put("current_elec_supplier", getCurrentElectricitySupplier());
			json.put("current_gas_supplier", getCurrentGasSupplier());
		}

		json.put("tariff", getTariff());

		if(getReferenceNumber() != null){
			json.put("first_name", getFirstName());
			json.put("phone", getPhoneNumber());
			json.put("reference_number", getReferenceNumber());
		}

		return json;
	}

	private String convertBooleanToString(boolean value){
		if(value) return "Yes";
		return "No";
	}

	private boolean convertStringToBoolean(String value){
		if(value.equalsIgnoreCase("Y")) return true;
		return false;
	}

	private float convertStringToFloat(String value){
		if(value == null || value.equals("")) return 0;
		return Float.parseFloat(value);
	}

	private Duration convertStringToDuraction(String value){
		if(value == null || value.equals("")) return null;

		if(value.equals("M")){
			return Duration.Monthly;
		} else if(value.equals("Q")){
			return Duration.Quarterly;
		} else if(value.equals("Y")){
			return Duration.Yearly;
		}

		return null;
	}

	public void populateFromRequest(HttpServletRequest request){


		setPostcode(request.getParameter("utilities_householdDetails_postcode"));
		setSuburb(request.getParameter("utilities_householdDetails_suburb"));
		setTariff(request.getParameter("utilities_householdDetails_tariff"));
		setConnection(convertStringToBoolean(request.getParameter("utilities_householdDetails_movingIn")));

		setCurrentElectricitySupplier(request.getParameter("utilities_estimateDetails_usage_electricity_currentSupplier"));
		setCurrentGasSupplier(request.getParameter("utilities_estimateDetails_usage_gas_currentSupplier"));

		String whatToCompare = request.getParameter("utilities_householdDetails_whatToCompare");
		if(whatToCompare.equals("EG")){
			setFuelType(FuelType.Dual);
		} else if(whatToCompare.equals("E")){
			setFuelType(FuelType.Electricity);
		} else if(whatToCompare.equals("G")){
			setFuelType(FuelType.Gas);
		}

		setElectricitySpend(convertStringToFloat(request.getParameter("utilities_estimateDetails_spend_electricity_amount")));
		setGasSpend(convertStringToFloat(request.getParameter("utilities_estimateDetails_spend_gas_amount")));

		setElectrictyPeakUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_spend_electricity_amount")));
		setElectricityOffpeakUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_usage_electricity_offpeak_amount")));

		setGasPeakUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_usage_gas_peak_amount")));
		setGasOffpeakUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_usage_gas_offpeak_amount")));

		setElectricityDuration(convertStringToDuraction(request.getParameter("utilities_estimateDetails_spend_electricity_period")));
		setGasDuration(convertStringToDuraction(request.getParameter("utilities_estimateDetails_spend_gas_period")));

		setHowToEstimate(request.getParameter("utilities_householdDetails_howToEstimate"));

		if(request.getParameter("utilities_resultsDisplayed_optinPhone").equals("Y")){
			setFirstName(request.getParameter("utilities_resultsDisplayed_firstName"));
			setPhoneNumber(request.getParameter("utilities_resultsDisplayed_phone"));
			setReferenceNumber("CTM");
		}

	}

	public String getHowToEstimate() {
		return howToEstimate;
	}

	public void setHowToEstimate(String howToEstimate) {
		this.howToEstimate = howToEstimate;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public String getReferenceNumber() {
		return referenceNumber;
	}

	public void setReferenceNumber(String referenceNumber) {
		this.referenceNumber = referenceNumber;
	}

}
