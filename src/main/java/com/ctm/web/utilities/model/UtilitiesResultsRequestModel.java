package com.ctm.web.utilities.model;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.web.core.model.AbstractJsonModel;
import com.ctm.web.core.utils.FormDateUtils;
import com.ctm.web.core.utils.NGram;

public class UtilitiesResultsRequestModel  extends AbstractJsonModel {

	public enum FuelType  {
		Electricity, Gas, Dual
	}

	public enum HouseholdType  {
		Low, Medium, High
	}

	public enum ElectricityMeterType  {
		Single ("Single","S"),
		TwoRate ("Two-rate","T"),
		TimeOfUse ("Time of Use","M");

		private final String label, code;

		ElectricityMeterType(String label, String code) {
			this.label = label;
			this.code = code;
		}

		public String getLabel() {
			return label;
		}
		public String getCode() {
			return code;
		}

		public static ElectricityMeterType findByCode(String code) {
			for (ElectricityMeterType t : ElectricityMeterType.values()) {
				if (code.equals(t.getCode())) {
					return t;
				}
			}
			return null;
		}
	}

	private String postcode; // postcode
	private String suburb; // suburb
	private boolean isConnection; // is_connection - true if moving to the property
	private Date connectionDate; // connection_date - date moving to the property
	private FuelType fuelType; // fuel_type

	private boolean hasElectricityBill; // el_bill_available - true if has electricity bill
	private boolean hasGasBill; // gas_bill_available - true if has gas bill
	private boolean solarPanels; // solar_panels

	// The following is only required if the user is not moving

	private String currentElectricitySupplier; // current_elec_supplier
	private HouseholdType electricityHouseholdType; // el_house_hold_type

	private String currentGasSupplier; // current_gas_supplier
	private HouseholdType gasHouseholdType; // gas_house_hold_type

	private float electricityBillAmount = 0; // el_bill_amount
	private float gasBillAmount = 0; // gas_bill_amount

	private Integer electricityBillDays = 0; // el_bill_days
	private Integer gasBillDays = 0; // gas_bill_days

	private ElectricityMeterType electricityMeterType;


	// The following are only required if customer chooses to enter usage
	private float electricityPeakUsage = 0; // el_peak_usage
	private float electricityOffpeakUsage = 0; // el_controlled_load_usage
	private float electricityShoulderUsage = 0; // el_shoulder_usage

	private float gasPeakUsage = 0; // gas_peak_usage
	private float gasOffpeakUsage = 0; // gas_offpeak_usage

	private boolean preferEBilling;
	private boolean preferNoContract;
	private boolean preferPayBillsOntime;
	private boolean preferRenewableEnergy;

	private String tariff;

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

	public boolean getHasElectricityBill() { return hasElectricityBill; }
	public void setHasElectricityBill(boolean hasElectricityBill) { this.hasElectricityBill = hasElectricityBill; }

	public boolean getHasGasBill() { return hasGasBill; }
	public void setHasGasBill(boolean hasGasBill) { this.hasGasBill = hasGasBill; }

	public boolean getSolarPanels() { return solarPanels; }
	public void setSolarPanels(boolean solarPanels) { this.solarPanels = solarPanels; }

	public String getCurrentElectricitySupplier() { return currentElectricitySupplier; }
	public void setCurrentElectricitySupplier(String currentElectricitySupplier) { this.currentElectricitySupplier = currentElectricitySupplier; }

	public String getCurrentGasSupplier() { return currentGasSupplier; }
	public void setCurrentGasSupplier(String currentGasSupplier) { this.currentGasSupplier = currentGasSupplier; }

	public HouseholdType getElectricityHouseholdType() { return electricityHouseholdType; }
	public void setElectricityHouseholdType(HouseholdType electricityHouseholdType) { this.electricityHouseholdType = electricityHouseholdType; }

	public HouseholdType getGasHouseholdType() { return gasHouseholdType; }
	public void setGasHouseholdType(HouseholdType gasHouseholdType) { this.gasHouseholdType = gasHouseholdType; }

	public float getElectricityBillAmount() { return electricityBillAmount; }
	public void setElectricityBillAmount(float electricityBillAmount) { this.electricityBillAmount = electricityBillAmount; }

	public float getGasBillAmount() { return gasBillAmount; }
	public void setGasBillAmount(float gasBillAmount) { this.gasBillAmount = gasBillAmount; }

	public Integer getElectricityBillDays() { return electricityBillDays; }
	public void setElectricityBillDays(Integer electricityBillDays) { this.electricityBillDays = electricityBillDays; }

	public Integer getGasBillDays() { return gasBillDays; }
	public void setGasBillDays(Integer gasBillDays) { this.gasBillDays = gasBillDays; }

	public ElectricityMeterType getElectricityMeterType() { return electricityMeterType; }
	public void setElectricityMeterType(ElectricityMeterType electricityMeterType) { this.electricityMeterType = electricityMeterType; }

	public float getElectricityPeakUsage() { return electricityPeakUsage; }
	public void setElectricityPeakUsage(float electricityPeakUsage) { this.electricityPeakUsage = electricityPeakUsage; }

	public float getElectricityOffpeakUsage() { return electricityOffpeakUsage; }
	public void setElectricityOffpeakUsage(float electricityOffpeakUsage) { this.electricityOffpeakUsage = electricityOffpeakUsage; }

	public float getElectricityShoulderUsage() { return electricityShoulderUsage; }
	public void setElectricityShoulderUsage(float electricityShoulderUsage) { this.electricityShoulderUsage = electricityShoulderUsage; }

	public float getGasPeakUsage() { return gasPeakUsage; }
	public void setGasPeakUsage(float gasPeakUsage) { this.gasPeakUsage = gasPeakUsage; }

	public float getGasOffpeakUsage() { return gasOffpeakUsage; }
	public void setGasOffpeakUsage(float gasOffpeakUsage) { this.gasOffpeakUsage = gasOffpeakUsage; }

	public boolean getPreferEBilling() { return preferEBilling; }
	public void setPreferEBilling(boolean preferEBilling) { this.preferEBilling = preferEBilling; }

	public boolean getPreferNoContract() { return preferNoContract; }
	public void setPreferNoContract(boolean preferNoContract) { this.preferNoContract = preferNoContract; }

	public boolean getPreferPayBillsOntime() { return preferPayBillsOntime; }
	public void setPreferPayBillsOntime(boolean preferPayBillsOntime) { this.preferPayBillsOntime = preferPayBillsOntime; }

	public boolean getPreferRenewableEnergy() { return preferRenewableEnergy; }
	public void setPreferRenewableEnergy(boolean preferRenewableEnergy) { this.preferRenewableEnergy = preferRenewableEnergy; }

	public String getTariff() { return tariff; }
	public void setTariff(String tariff) { this.tariff = tariff; }


	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("postcode", getPostcode());
		json.put("suburb", getSuburb());
		json.put("is_connection", convertBooleanToString(isConnection(), "Yes", "No"));
		if(isConnection) {
			json.put("connection_date", FormDateUtils.convertDateToString(getConnectionDate(), "yyyy-MM-dd"));
		} else {
			json.put("connection_date", "0000-00-00");
		}
		json.put("fuel_type", getFuelType());

		if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Electricity) {
			json.put("el_bill_available", convertBooleanToString(getHasElectricityBill(), "Yes", "No"));
		}

		if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Electricity) {
			json.put("gas_bill_available", convertBooleanToString(getHasGasBill(), "Yes", "No"));
		}

		json.put("solar_panels", convertBooleanToString(getSolarPanels(), "Yes", "No"));

		json.put("el_house_hold_type", getElectricityHouseholdType());
		json.put("gas_house_hold_type", getGasHouseholdType());

		if(getHasElectricityBill()) {

			json.put("el_bill_amount", getElectricityBillAmount());
			json.put("el_bill_days", getElectricityBillDays());
			ElectricityMeterType meterType = getElectricityMeterType();
			json.put("el_meter_type", meterType.getLabel());

			json.put("el_peak_usage", getElectricityPeakUsage());
			if(getElectricityMeterType() == ElectricityMeterType.TwoRate || getElectricityMeterType() == ElectricityMeterType.TimeOfUse) {
				json.put("el_controlled_load_usage", getElectricityOffpeakUsage());
			} else {
				json.put("el_controlled_load_usage", 0);
			}
			if(getElectricityMeterType() == ElectricityMeterType.TimeOfUse) {
				json.put("el_shoulder_usage", getElectricityShoulderUsage());
			} else {
				json.put("el_shoulder_usage", 0);
			}
		}

		if(getHasGasBill()) {

			json.put("gas_bill_amount", getGasBillAmount());
			json.put("gas_bill_days", getGasBillDays());

			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Gas) {
				json.put("gas_peak_usage", getGasPeakUsage());
				json.put("gas_offpeak_usage", getGasOffpeakUsage());
			} else {
				json.put("gas_peak_usage", 0);
				json.put("gas_offpeak_usage", 0);
			}
		}


			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Electricity){
				json.put("current_elec_supplier", getCurrentElectricitySupplier());
			}

			if(getFuelType() == FuelType.Dual || getFuelType() == FuelType.Gas){
				json.put("current_gas_supplier", getCurrentGasSupplier());
			}

		json.put("ebilling", convertBooleanToString(getPreferEBilling(), "Yes", "No"));
		json.put("no_contract", convertBooleanToString(getPreferNoContract(), "Yes", "No"));
		json.put("pay_bills_ontime", convertBooleanToString(getPreferPayBillsOntime(), "Yes", "No"));
		json.put("renewable_energy", convertBooleanToString(getPreferRenewableEnergy(), "Important", "Not important"));


		json.put("tariff", getTariff());

		if(getReferenceNumber() != null){
			json.put("title", "Mr");
			json.put("first_name", getFirstName());

			if(getPhoneNumber() != null){
				json.put("phone", getPhoneNumber());
				json.put("phone1_rating", getPhoneRating());
			}
			json.put("reference_number", getReferenceNumber());
		}

		return json;
	}

	private String convertBooleanToString(boolean value, String trueString, String falseString){
		if(value) return trueString;
		return falseString;
	}

	private boolean convertStringToBoolean(String value){
		if(value != null && value.equalsIgnoreCase("Y")) return true;
		return false;
	}

	private Integer convertStringToInteger(String value){
		if(value == null || value.equals("")) return 0;
		return Integer.parseInt(value);
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

		setPreferEBilling(convertStringToBoolean(request.getParameter("utilities_resultsDisplayed_preferEBilling")));
		setPreferNoContract(convertStringToBoolean(request.getParameter("utilities_resultsDisplayed_preferNoContract")));
		setPreferPayBillsOntime(convertStringToBoolean(request.getParameter("utilities_resultsDisplayed_preferPayBillsOntime")));
		setPreferRenewableEnergy(convertStringToBoolean(request.getParameter("utilities_resultsDisplayed_preferRenewableEnergy")));


		if(request.getParameter("utilities_householdDetails_movingInDate")!= null){
			setConnectionDate(FormDateUtils.parseDateFromForm(request.getParameter("utilities_householdDetails_movingInDate")));
		}

		setHasElectricityBill(convertStringToBoolean(request.getParameter("utilities_householdDetails_recentElectricityBill")));
		setHasGasBill(convertStringToBoolean(request.getParameter("utilities_householdDetails_recentGasBill")));

		setSolarPanels(convertStringToBoolean(request.getParameter("utilities_householdDetails_solarPanels")));

		String householdType;
		householdType = request.getParameter("utilities_estimateDetails_electricity_usage");
		if(householdType != null) {
			if (householdType.equals("Low")) {
				setElectricityHouseholdType(HouseholdType.Low);
			} else if (householdType.equals("Medium")) {
				setElectricityHouseholdType(HouseholdType.Medium);
			} else if (householdType.equals("High")) {
				setElectricityHouseholdType(HouseholdType.High);
			}
		} else {
			setElectricityMeterType(ElectricityMeterType.findByCode(request.getParameter("utilities_estimateDetails_electricity_meter")));
		}

		householdType = request.getParameter("utilities_estimateDetails_gas_usage");
		if(householdType != null) {
			if (householdType.equals("Low")) {
				setGasHouseholdType(HouseholdType.Low);
			} else if (householdType.equals("Medium")) {
				setGasHouseholdType(HouseholdType.Medium);
			} else if (householdType.equals("High")) {
				setGasHouseholdType(HouseholdType.High);
			}
		}

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

		setElectricityBillAmount(convertStringToFloat(request.getParameter("utilities_estimateDetails_spend_electricity_amount")));
		setElectricityBillDays(convertStringToInteger(request.getParameter("utilities_estimateDetails_spend_electricity_days")));

		setGasBillAmount(convertStringToFloat(request.getParameter("utilities_estimateDetails_spend_gas_amount")));
		setGasBillDays(convertStringToInteger(request.getParameter("utilities_estimateDetails_spend_gas_days")));

		setElectricityPeakUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_usage_electricity_peak_amount")));

		if(getElectricityMeterType() == ElectricityMeterType.TwoRate || getElectricityMeterType() == ElectricityMeterType.TimeOfUse) {
			setElectricityOffpeakUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_usage_electricity_offpeak_amount")));
		}
		if (getElectricityMeterType() == ElectricityMeterType.TimeOfUse) {
			setElectricityShoulderUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_usage_electricity_shoulder_amount")));
		}

		setGasPeakUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_usage_gas_peak_amount")));
		setGasOffpeakUsage(convertStringToFloat(request.getParameter("utilities_estimateDetails_usage_gas_offpeak_amount")));

			if (request.getParameter("utilities_resultsDisplayed_optinPhone").equals("Y")) {
				setFirstName(request.getParameter("utilities_resultsDisplayed_firstName"));
				setPhoneNumber(request.getParameter("utilities_resultsDisplayed_phone"));
			setReferenceNumber(request.getParameter("transactionId"));
		}

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
