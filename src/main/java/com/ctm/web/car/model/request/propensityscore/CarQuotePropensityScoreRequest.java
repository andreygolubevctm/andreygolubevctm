package com.ctm.web.car.model.request.propensityscore;

import com.ctm.web.core.model.formData.YesNo;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.io.Serializable;

/**
 * Car quote propensity score request to be send to Data Robot.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class CarQuotePropensityScoreRequest implements Serializable
{

    @JsonProperty(value = "CD_RankPosition", required = true)
    private Integer rankPosition;
    @JsonProperty(value = "CD_PhoneFlag", required = true)
    private YesNo phoneFlag;
    @JsonProperty(value = "CD_CommencementDays", required = true)
    private Long commencementDays;
    @JsonProperty(value = "CD_EmailFlag", required = true)
    private YesNo emailFlag;
    @JsonProperty(value = "CD_Age", required = true)
    private Long age;
    @JsonProperty(value = "CD_DeviceType", required = true)
    private DeviceType deviceType;
    @JsonProperty(value = "CD_Hr", required = true)
    private Integer hourCompleted;
    //Keeping below data types as String to keep it same as `transaction_details` in db.
    @JsonProperty(value = "quote_drivers_regular_ncd", required = true)
    private String driverRegularNcd;
    @JsonProperty(value = "quote_drivers_regular_claims", required = true)
    private String driverRegularClaims;
    @JsonProperty(value = "quote_drivers_regular_employmentStatus", required = true)
    private String driverRegularEmploymentStatus;
    @JsonProperty(value = "quote_riskAddress_state", required = true)
    private String riskAddressState;
    @JsonProperty(value = "quote_vehicle_body", required = true)
    private String vehicleBody;
    @JsonProperty(value = "quote_vehicle_colour", required = true)
    private String vehicleColour;
    @JsonProperty(value = "quote_vehicle_finance", required = true)
    private String vehicleFinance;
    @JsonProperty(value = "quote_vehicle_annualKilometres", required = true)
    private String vehicleAnnualKilometers;
    @JsonProperty(value = "quote_vehicle_use", required = true)
    private String vehicleUse;
    @JsonProperty(value = "quote_vehicle_marketvalue", required = true)
    private String vehicleMarketValue;
    @JsonProperty(value = "quote_vehicle_factoryOptions", required = true)
    private String vehicleFactoryOptions;
    @JsonProperty(value = "quote_vehicle_makeDes", required = true)
    private String vehicleMakeDescription;
    @JsonProperty(value = "quote_vehicle_damage", required = true)
    private String vehicleDamage;

    public Integer getRankPosition() {
        return rankPosition;
    }

    public void setRankPosition(Integer rankPosition) {
        this.rankPosition = rankPosition;
    }

    public YesNo getPhoneFlag() {
        return phoneFlag;
    }

    public void setPhoneFlag(YesNo phoneFlag) {
        this.phoneFlag = phoneFlag;
    }

    public Long getCommencementDays() {
        return commencementDays;
    }

    public void setCommencementDays(Long commencementDays) {
        this.commencementDays = commencementDays;
    }

    public YesNo getEmailFlag() {
        return emailFlag;
    }

    public void setEmailFlag(YesNo emailFlag) {
        this.emailFlag = emailFlag;
    }

    public Long getAge() {
        return age;
    }

    public void setAge(Long age) {
        this.age = age;
    }

    public DeviceType getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(DeviceType deviceType) {
        this.deviceType = deviceType;
    }

    public Integer getHourCompleted() {
        return hourCompleted;
    }

    public void setHourCompleted(Integer hourCompleted) {
        this.hourCompleted = hourCompleted;
    }

    public String getDriverRegularNcd() {
        return driverRegularNcd;
    }

    public void setDriverRegularNcd(String driverRegularNcd) {
        this.driverRegularNcd = driverRegularNcd;
    }

    public String getDriverRegularClaims() {
        return driverRegularClaims;
    }

    public void setDriverRegularClaims(String driverRegularClaims) {
        this.driverRegularClaims = driverRegularClaims;
    }

    public String getDriverRegularEmploymentStatus() {
        return driverRegularEmploymentStatus;
    }

    public void setDriverRegularEmploymentStatus(String driverRegularEmploymentStatus) {
        this.driverRegularEmploymentStatus = driverRegularEmploymentStatus;
    }

    public String getRiskAddressState() {
        return riskAddressState;
    }

    public void setRiskAddressState(String riskAddressState) {
        this.riskAddressState = riskAddressState;
    }

    public String getVehicleBody() {
        return vehicleBody;
    }

    public void setVehicleBody(String vehicleBody) {
        this.vehicleBody = vehicleBody;
    }

    public String getVehicleColour() {
        return vehicleColour;
    }

    public void setVehicleColour(String vehicleColour) {
        this.vehicleColour = vehicleColour;
    }

    public String getVehicleFinance() {
        return vehicleFinance;
    }

    public void setVehicleFinance(String vehicleFinance) {
        this.vehicleFinance = vehicleFinance;
    }

    public String getVehicleAnnualKilometers() {
        return vehicleAnnualKilometers;
    }

    public void setVehicleAnnualKilometers(String vehicleAnnualKilometers) {
        this.vehicleAnnualKilometers = vehicleAnnualKilometers;
    }

    public String getVehicleUse() {
        return vehicleUse;
    }

    public void setVehicleUse(String vehicleUse) {
        this.vehicleUse = vehicleUse;
    }

    public String getVehicleMarketValue() {
        return vehicleMarketValue;
    }

    public void setVehicleMarketValue(String vehicleMarketValue) {
        this.vehicleMarketValue = vehicleMarketValue;
    }

    public String getVehicleFactoryOptions() {
        return vehicleFactoryOptions;
    }

    public void setVehicleFactoryOptions(String vehicleFactoryOptions) {
        this.vehicleFactoryOptions = vehicleFactoryOptions;
    }

    public String getVehicleMakeDescription() {
        return vehicleMakeDescription;
    }

    public void setVehicleMakeDescription(String vehicleMakeDescription) {
        this.vehicleMakeDescription = vehicleMakeDescription;
    }

    public String getVehicleDamage() {
        return vehicleDamage;
    }

    public void setVehicleDamage(String vehicleDamage) {
        this.vehicleDamage = vehicleDamage;
    }
}
