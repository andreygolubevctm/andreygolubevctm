package com.ctm.web.utilities.model;

import com.ctm.model.AbstractJsonModel;
import com.ctm.web.core.utils.FormDateUtils;
import com.ctm.web.core.utils.NGram;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

public class UtilitiesResultsRequestModel  extends AbstractJsonModel {

	public static enum FuelType  {
		Electricity, Gas, Dual;
	}

	public static enum Duration  {
		MONTHLY ("Monthly","M"),
		BIMONTHLY ("Bimonthly","B"),
		QUARTERLY ("Quarterly","Q"),
		YEARLY ("Yearly","Y");

		private final String label, code;

		Duration(String label, String code) {
			this.label = label;
			this.code = code;
		}

		public String getLabel() {
			return label;
		}
		public String getCode() {
			return code;
		}

		public static Duration findByCode(String code) {
			for (Duration t : Duration.values()) {
				if (code.equals(t.getCode())) {
					return t;
				}
			}
			return null;
		}
	}

	private String postcode;
	private String suburb;
	private boolean isConnection; // true if moving to the property
	private Date connectionDate; // date moving to the property
	private FuelType fuelType;
	private String tariff;
	private boolean solarPanels;

	// The following is only required if the user is not moving
	private Duration electricityDuration;
	private Duration gasDuration;
	private String currentElectricitySupplier;
	private String currentGasSupplier;

	// The following are only required if customer chooses 'Use my $ to work out use'
	private float electricitySpend = 0;
	private float gasSpend = 0;

	// The following are only required if customer chooses to enter usage
	private float electricityPeakUsage = 0;
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

	public Date getConnectionDate() {
		return connectionDate;
	}

	public void setConnectionDate(Date connectionDate) {
		this.connectionDate = connectionDate;
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

	public boolean getSolarPanels() {
		return solarPanels;
	}

	public void setSolarPanels(boolean solarPanels) {
		this.solarPanels = solarPanels;
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

	public float getElectricityPeakUsage() {
		return electricityPeakUsage;
	}

	public void setElectricityPeakUsage(float electricityPeakUsage) {
		this.electricityPeakUsage = electricityPeakUsage;
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
		if(isConnection) {
			json.put("connection_date", FormDateUtils.convertDateToString(getConnectionDate(), "yyyy-MM-dd"));
		} else {
			json.put("connection_date", "0000-00-00");
		}
		json.put("fuel_type", getFuelType());
		json.put("solar_panels", convertBooleanToString(getSolarPanels()));

		if(getHowToEstimate().equals("U")){

			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Electricity){
				json.put("elec_peak_usage", getElectricityPeakUsage());
				json.put("elec_offpeak_usage", getElectricityOffpeakUsage());
			}else{
				json.put("elec_peak_usage", 0);
				json.put("elec_offpeak_usage", 0);
			}

			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Gas){
				json.put("gas_peak_usage", getGasPeakUsage());
				json.put("gas_offpeak_usage", getGasOffpeakUsage());
			}else{
				json.put("gas_peak_usage", 0);
				json.put("gas_offpeak_usage", 0);
			}

			json.put("elec_money_spend", 0);
			json.put("gas_money_spend", 0);


		} else if(getHowToEstimate().equals("S")){

			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Electricity){
				json.put("elec_money_spend", getElectricitySpend());
			}else{
				json.put("elec_money_spend", 0);
			}

			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Gas){
				json.put("gas_money_spend", getGasSpend());
			}else{
				json.put("gas_money_spend", 0);
			}
		}

		if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Electricity){
			Duration elecDuration = getElectricityDuration();
			json.put("elec_duration", elecDuration.getLabel());
		}


		if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Gas){
			Duration gasDuration = getGasDuration();
			json.put("gas_duration", gasDuration.getLabel());
		}

		if(isConnection() == false  || (isConnection() && getHowToEstimate().equals("U"))){

			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Electricity){
				json.put("current_elec_supplier", getCurrentElectricitySupplier());
			}

			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Gas){
				json.put("current_gas_supplier", getCurrentGasSupplier());
			}
		}

		json.put("tariff", getTariff());

		if(getReferenceNumber() != null){
			json.put("first_name", getFirstName());

			if(getPhoneNumber() != null){
				json.put("phone", getPhoneNumber());
				json.put("phone1_rating", getPhoneRating());
			}
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

	public void populateFromRequest(HttpServletRequest request){


		setPostcode(request.getParameter("utilities_householdDetails_postcode"));
		setSuburb(request.getParameter("utilities_householdDetails_suburb"));
		setTariff(request.getParameter("utilities_householdDetails_tariff"));
		setConnection(convertStringToBoolean(request.getParameter("utilities_householdDetails_movingIn")));

		if(request.getParameter("utilities_householdDetails_movingInDate")!= null){
			setConnectionDate(FormDateUtils.parseDateFromForm(request.getParameter("utilities_householdDetails_movingInDate")));
		}

		setSolarPanels(convertStringToBoolean(request.getParameter("utilities_householdDetails_solarPanels")));

		String whatToCompare = request.getParameter("utilities_householdDetails_whatToCompare");
		if(whatToCompare.equals("EG")){
			setFuelType(FuelType.Dual);
			setCurrentElectricitySupplier(request.getParameter("utilities_estimateDetails_usage_electricity_currentSupplier"));
			setCurrentGasSupplier(request.getParameter("utilities_estimateDetails_usage_gas_currentSupplier"));
		} else if(whatToCompare.equals("E")){
			setFuelType(FuelType.Electricity);
			setCurrentElectricitySupplier(request.getParameter("utilities_estimateDetails_usage_electricity_currentSupplier"));
		} else if(whatToCompare.equals("G")){
			setFuelType(FuelType.Gas);
			setCurrentGasSupplier(request.getParameter("utilities_estimateDetails_usage_gas_currentSupplier"));
		}

		setElectricitySpend(convertStringToFloat(request.getParameter("utilities_estimateDetails_spend_electricity_amount")));
		setGasSpend(convertStringToFloat(request.getParameter("utilities_estimateDetails_spend_gas_amount")));

		setElectricityPeakUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_usage_electricity_peak_amount")));
		setElectricityOffpeakUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_usage_electricity_offpeak_amount")));

		setGasPeakUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_usage_gas_peak_amount")));
		setGasOffpeakUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_usage_gas_offpeak_amount")));

		setHowToEstimate(request.getParameter("utilities_householdDetails_howToEstimate"));

		if(getHowToEstimate().equals("U")){
			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Electricity){
				setElectricityDuration(Duration.findByCode(request.getParameter("utilities_estimateDetails_usage_electricity_peak_period")));
			}
			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Gas){
				setGasDuration(Duration.findByCode(request.getParameter("utilities_estimateDetails_usage_gas_peak_period")));
			}
		}else{
			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Electricity){
				setElectricityDuration(Duration.findByCode(request.getParameter("utilities_estimateDetails_spend_electricity_period")));
			}
			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Gas){
				setGasDuration(Duration.findByCode(request.getParameter("utilities_estimateDetails_spend_gas_period")));
			}
		}

		if(request.getParameter("utilities_resultsDisplayed_optinPhone").equals("Y")){
			setFirstName(request.getParameter("utilities_resultsDisplayed_firstName"));
			setPhoneNumber(request.getParameter("utilities_resultsDisplayed_phone"));
			setReferenceNumber(request.getParameter("transactionId"));
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

	public Integer getPhoneRating() {
		NGram ngram = new NGram(phoneNumber,3);
			
		return ngram.score();
	}

	public String getReferenceNumber() {
		return referenceNumber;
	}

	public void setReferenceNumber(String referenceNumber) {
		this.referenceNumber = referenceNumber;
	}

}
