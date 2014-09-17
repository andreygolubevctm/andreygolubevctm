package com.ctm.model.email;

/**
 * TODO: this is partialy implemented
 * @author lbuchanan
 *
 */
public class CarBestPriceEmailModel extends EmailModel {

	private String firstName;
	private String lastName;
	private String optIn;
	private String callcentreHoursText;
	private String callcentreHours;
	private String vehicleYear;
	private String vehicleMake;
	private String vehicleModel;
	private String vehicleVariant;
	private String validateDate;
	private String address;
	private String premiumFrequency;

	public String getFirstName() {
		return firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public String getOptIn() {
		return optIn;
	}

	public String getCallcentreHoursText() {
		return callcentreHoursText;
	}

	public String getCallcentreHours() {
		return callcentreHours;
	}

	public String getVehicleYear() {
		return vehicleYear;
	}

	public String getVehicleMake() {
		return vehicleMake;
	}

	public String getVehicleModel() {
		return vehicleModel;
	}

	public String getVehicleVariant() {
		return vehicleVariant;
	}

	public String getValidateDate() {
		return validateDate;
	}

	public String getAddress() {
		return address;
	}

	public String getPremiumFrequency() {
		return premiumFrequency;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public void setOptIn(String optIn) {
		this.optIn = optIn;
	}

	public void setCallcentreHoursText(String callcentreHoursText) {
		this.callcentreHoursText = callcentreHoursText;
	}

	public void setCallcentreHours(String callcentreHours) {
		this.callcentreHours = callcentreHours;
	}

	public void setVehicleYear(String vehicleYear) {
		this.vehicleYear = vehicleYear;
	}

	public void setVehicleMake(String vehicleMake) {
		this.vehicleMake = vehicleMake;
	}

	public void setVehicleModel(String vehicleModel) {
		this.vehicleModel = vehicleModel;
	}

	public void setVehicleVariant(String vehicleVariant) {
		this.vehicleVariant = vehicleVariant;
	}

	public void setValidateDate(String validateDate) {
		this.validateDate = validateDate;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public void setPremiumFrequency(String premiumFrequency) {
		this.premiumFrequency = premiumFrequency;
	}

}
