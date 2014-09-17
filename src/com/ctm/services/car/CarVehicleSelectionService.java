package com.ctm.services.car;

import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.ctm.dao.car.CarBodyDao;
import com.ctm.dao.car.CarFuelDao;
import com.ctm.dao.car.CarMakeDao;
import com.ctm.dao.car.CarModelDao;
import com.ctm.dao.car.CarTransmissionDao;
import com.ctm.dao.car.CarTypeDao;
import com.ctm.dao.car.CarYearDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.model.car.CarBody;
import com.ctm.model.car.CarFuel;
import com.ctm.model.car.CarMake;
import com.ctm.model.car.CarModel;
import com.ctm.model.car.CarTransmission;
import com.ctm.model.car.CarType;
import com.ctm.model.car.CarYear;
import com.ctm.model.formatter.JsonUtils;

public class CarVehicleSelectionService {
	private static Logger logger = Logger.getLogger(CarVehicleSelectionService.class.getName());

	/**
	 * Build up a full dataset to populate vehicle selection.
	 *
	 * @param makeCode Make code e.g. HOLD
	 * @param modelCode Model code e.g. FORESTE
	 * @param yearCode Year code e.g. 2005
	 * @param bodyCode Body code e.g. 2CPE
	 * @param transmissionCode Transmission code e.g. M
	 * @param fuelCode Fuel code e.g. P
	 * @return JSON string
	 */
	public static JSONObject getVehicleSelection(String makeCode, String modelCode, String yearCode, String bodyCode, String transmissionCode, String fuelCode) {
		JSONObject json = new JSONObject();

		ArrayList<CarMake> carMakes = new ArrayList<CarMake>();
		ArrayList<CarModel> carModels = new ArrayList<CarModel>();
		ArrayList<CarYear> carYears = new ArrayList<CarYear>();
		ArrayList<CarBody> carBodies = new ArrayList<CarBody>();
		ArrayList<CarTransmission> carTrans = new ArrayList<CarTransmission>();
		ArrayList<CarFuel> carFuels = new ArrayList<CarFuel>();
		ArrayList<CarType> carTypes = new ArrayList<CarType>();

		carMakes = getAllMakes();

		// Go through the chain of arguments and stop if any is empty.
		if (makeCode.length() > 0) {
			carModels = getModels(makeCode);

			if (modelCode.length() > 0) {
				carYears = getYears(makeCode, modelCode);

				if (yearCode.length() > 0) {
					carBodies = getBodies(makeCode, modelCode, yearCode);

					if (bodyCode.length() > 0) {
						carTrans = getTransmissions(makeCode, modelCode, yearCode, bodyCode);

						if (transmissionCode.length() > 0) {
							carFuels = getFuels(makeCode, modelCode, yearCode, bodyCode, transmissionCode);

							if (fuelCode.length() > 0) {
								carTypes = getTypes(makeCode, modelCode, yearCode, bodyCode, transmissionCode, fuelCode);
							}
						}
					}
				}
			}
		}

		JsonUtils.addListToJsonObject(json, CarMake.JSON_COLLECTION_NAME, carMakes);
		JsonUtils.addListToJsonObject(json, CarModel.JSON_COLLECTION_NAME, carModels);
		JsonUtils.addListToJsonObject(json, CarYear.JSON_COLLECTION_NAME, carYears);
		JsonUtils.addListToJsonObject(json, CarBody.JSON_COLLECTION_NAME, carBodies);
		JsonUtils.addListToJsonObject(json, CarTransmission.JSON_COLLECTION_NAME, carTrans);
		JsonUtils.addListToJsonObject(json, CarFuel.JSON_COLLECTION_NAME, carFuels);
		JsonUtils.addListToJsonObject(json, CarType.JSON_COLLECTION_NAME, carTypes);

		return json;
	}

	/**
	 * Get all car makes.
	 */
	public static ArrayList<CarMake> getAllMakes() {
		ArrayList<CarMake> carMakes = new ArrayList<CarMake>();
		CarMakeDao carMakeDao = new CarMakeDao();

		try {

			carMakes = carMakeDao.getAll();

		}
		catch (DaoException e) {
			logger.error("Could not get makes", e);

			CarMake carMake = new CarMake();

			Error error = new Error();
			error.setMessage(e.getMessage());
			carMake.addError(error);

			carMakes.add(carMake);
		}

		return carMakes;
	}

	/**
	 * Get all models for a particular make.
	 * @param makeCode Make code e.g. HOLD
	 */
	public static ArrayList<CarModel> getModels(String makeCode) {
		ArrayList<CarModel> carModels = new ArrayList<CarModel>();
		CarModelDao carModelDao = new CarModelDao();

		try {

			carModels = carModelDao.getByMakeCode(makeCode);

		}
		catch (DaoException e) {
			logger.error("Could not get models for make:"+makeCode, e);

			CarModel carModel = new CarModel();

			Error error = new Error();
			error.setMessage(e.getMessage());
			carModel.addError(error);

			carModels.add(carModel);
		}

		return carModels;
	}

	/**
	 * Get all years for a particular make and model.
	 * @param makeCode Make code e.g. HOLD
	 * @param modelCode Model code e.g. FORESTE
	 */
	public static ArrayList<CarYear> getYears(String makeCode, String modelCode) {
		ArrayList<CarYear> carYears = new ArrayList<CarYear>();
		CarYearDao carYearDao = new CarYearDao();

		try {

			carYears = carYearDao.getByMakeCodeAndModelCode(makeCode, modelCode);

		}
		catch (DaoException e) {
			logger.error("Could not get years for make:"+makeCode + " + model:"+modelCode, e);

			CarYear carYear = new CarYear();

			Error error = new Error();
			error.setMessage(e.getMessage());
			carYear.addError(error);

			carYears.add(carYear);
		}

		return carYears;
	}

	/**
	 * Get all bodies for a particular make, model and year.
	 * @param makeCode Make code e.g. HOLD
	 * @param modelCode Model code e.g. FORESTE
	 * @param yearCode Year code e.g. 2005
	 */
	public static ArrayList<CarBody> getBodies(String makeCode, String modelCode, String yearCode) {
		ArrayList<CarBody> carBodies = new ArrayList<CarBody>();
		CarBodyDao carBodyDao = new CarBodyDao();

		try {

			carBodies = carBodyDao.getByMakeModelYear(makeCode, modelCode, yearCode);

		}
		catch (DaoException e) {
			logger.error("Could not get bodies for make:"+makeCode + " + model:"+modelCode + " + year:"+yearCode, e);

			CarBody carBody = new CarBody();

			Error error = new Error();
			error.setMessage(e.getMessage());
			carBody.addError(error);

			carBodies.add(carBody);
		}

		return carBodies;
	}

	/**
	 * Get all transmissions for a particular make, model, year and body.
	 * @param makeCode Make code e.g. HOLD
	 * @param modelCode Model code e.g. FORESTE
	 * @param yearCode Year code e.g. 2005
	 * @param bodyCode Body code e.g. 2CPE
	 */
	public static ArrayList<CarTransmission> getTransmissions(String makeCode, String modelCode, String yearCode, String bodyCode) {
		ArrayList<CarTransmission> carTrans = new ArrayList<CarTransmission>();
		CarTransmissionDao carTransmissionDao = new CarTransmissionDao();

		try {

			carTrans = carTransmissionDao.getByMakeModelYearBody(makeCode, modelCode, yearCode, bodyCode);

		}
		catch (DaoException e) {
			logger.error("Could not get transmissions for make:"+makeCode + " + model:"+modelCode + " + year:"+yearCode + " + body:"+bodyCode, e);

			CarTransmission carTransmission = new CarTransmission();

			Error error = new Error();
			error.setMessage(e.getMessage());
			carTransmission.addError(error);

			carTrans.add(carTransmission);
		}

		return carTrans;
	}

	/**
	 * Get all fuels for a particular make, model, year, body and transmission.
	 * @param makeCode Make code e.g. HOLD
	 * @param modelCode Model code e.g. FORESTE
	 * @param yearCode Year code e.g. 2005
	 * @param bodyCode Body code e.g. 2CPE
	 * @param transmissionCode Transmission code e.g. M
	 */
	public static ArrayList<CarFuel> getFuels(String makeCode, String modelCode, String yearCode, String bodyCode, String transmissionCode) {
		ArrayList<CarFuel> carFuels = new ArrayList<CarFuel>();
		CarFuelDao carFuelDao = new CarFuelDao();

		try {

			carFuels = carFuelDao.getByMakeModelYearBodyTransmission(makeCode, modelCode, yearCode, bodyCode, transmissionCode);

		}
		catch (DaoException e) {
			logger.error("Could not get fuels for make:"+makeCode + " + model:"+modelCode + " + year:"+yearCode + " + body:"+bodyCode + " + trans:"+transmissionCode, e);

			CarFuel carFuel = new CarFuel();

			Error error = new Error();
			error.setMessage(e.getMessage());
			carFuel.addError(error);

			carFuels.add(carFuel);
		}

		return carFuels;
	}

	/**
	 * Get all types for a particular make, model, year, body, transmission and fuel.
	 * @param makeCode Make code e.g. HOLD
	 * @param modelCode Model code e.g. FORESTE
	 * @param yearCode Year code e.g. 2005
	 * @param bodyCode Body code e.g. 2CPE
	 * @param transmissionCode Transmission code e.g. M
	 * @param fuelCode Fuel code e.g. P
	 */
	public static ArrayList<CarType> getTypes(String makeCode, String modelCode, String yearCode, String bodyCode, String transmissionCode, String fuelCode) {
		ArrayList<CarType> carTypes = new ArrayList<CarType>();
		CarTypeDao carTypeDao = new CarTypeDao();

		try {

			carTypes = carTypeDao.getByMakeModelYearBodyTransmissionFuel(makeCode, modelCode, yearCode, bodyCode, transmissionCode, fuelCode);

		}
		catch (DaoException e) {
			logger.error("Could not get types for make:"+makeCode + " + model:"+modelCode + " + year:"+yearCode + " + body:"+bodyCode + " + trans:"+transmissionCode + " + fuel:"+fuelCode, e);

			CarType carType = new CarType();

			Error error = new Error();
			error.setMessage(e.getMessage());
			carType.addError(error);

			carTypes.add(carType);
		}

		return carTypes;
	}

}
