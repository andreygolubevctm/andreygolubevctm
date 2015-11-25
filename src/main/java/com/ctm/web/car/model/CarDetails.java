package com.ctm.web.car.model;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.LinkedHashMap;
import java.util.Map;

public class CarDetails {
    public static final String JSON_COLLECTION_NAME = "cardetails";

    private static ObjectMapper objectMapper = new ObjectMapper();

    private CarMake carMake;
    private CarModel carModel;
    private CarYear carYear;
    private CarBody carBody;
    private CarTransmission carTransmission;
    private CarFuel carFuel;
    private CarType carType;

    public Map<String, Object> get() {
        Map<String, Object> details = new LinkedHashMap<>();
        details.put(CarMake.JSON_SINGLE_NAME, carMake);
        details.put(CarModel.JSON_SINGLE_NAME, carModel);
        details.put(CarYear.JSON_SINGLE_NAME, carYear);
        details.put(CarBody.JSON_SINGLE_NAME, carBody);
        details.put(CarTransmission.JSON_SINGLE_NAME, carTransmission);
        details.put(CarFuel.JSON_SINGLE_NAME, carFuel);
        details.put(CarType.JSON_SINGLE_NAME, carType);
        return details;
    }

    public Map<String, Object> getSimple() {
        Map<String, Object> details = new LinkedHashMap<>();
        details.put(CarMake.JSON_COLLECTION_NAME, carMake.getCode());
        details.put(CarMake.JSON_DESCRIPTION_NAME, carMake.getLabel());
        details.put(CarModel.JSON_COLLECTION_NAME, carModel.getCode());
        details.put(CarModel.JSON_DESCRIPTION_NAME, carModel.getLabel());
        details.put(CarYear.JSON_COLLECTION_NAME, carYear.getCode());
        details.put(CarYear.JSON_ALT_COLLECTION_NAME, carYear.getCode());
        details.put(CarBody.JSON_COLLECTION_NAME, carBody.getCode());
        details.put(CarTransmission.JSON_COLLECTION_NAME, carTransmission.getCode());
        details.put(CarFuel.JSON_COLLECTION_NAME, carFuel.getCode());
        details.put(CarType.JSON_COLLECTION_NAME, carType.getCode());
        details.put(CarType.JSON_MARKETVALUE_NAME, Integer.toString(carType.getMarketValue()));
        details.put(CarType.JSON_VARIANT_NAME, carType.getLabel());
        return details;
    }

    public CarMake getMake() {
        return carMake;
    }
    public void setMake(CarMake carMake) {
        this.carMake = carMake;
    }

    public CarModel getModel() {
        return carModel;
    }
    public void setModel(CarModel carModel) {
        this.carModel = carModel;
    }

    public CarYear getYear() {
        return carYear;
    }
    public void setYear(CarYear carYear) {
        this.carYear = carYear;
    }

    public CarBody getBody() {
        return carBody;
    }
    public void setBody(CarBody carBody) {
        this.carBody = carBody;
    }

    public CarTransmission getTransmission() {
        return carTransmission;
    }
    public void setTransmission(CarTransmission carTransmission) {
        this.carTransmission = carTransmission;
    }

    public CarFuel getFuel() {
        return carFuel;
    }
    public void setFuel(CarFuel carFuel) {
        this.carFuel = carFuel;
    }

    public CarType getType() {
        return carType;
    }
    public void setType(CarType carType) {
        this.carType = carType;
    }
}
