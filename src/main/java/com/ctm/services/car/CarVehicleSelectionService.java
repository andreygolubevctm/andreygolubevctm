package com.ctm.services.car;

import com.ctm.dao.car.*;
import com.ctm.exceptions.DaoException;
import com.ctm.model.car.*;
import com.ctm.exceptions.ServiceException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger; import org.slf4j.LoggerFactory;
import org.joda.time.DateTimeFieldType;
import org.joda.time.LocalDate;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.*;

public class CarVehicleSelectionService {
	private static final Logger logger = LoggerFactory.getLogger(CarVehicleSelectionService.class.getName());

	private static ObjectMapper objectMapper = new ObjectMapper();

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
		try {
			return new JSONObject(objectMapper.writeValueAsString(
				getVehicleSelectionMap(makeCode, modelCode, yearCode, bodyCode, transmissionCode, fuelCode)
			));
		} catch (JsonProcessingException | JSONException e) {
			String message = "Could not get VehicleSelection for make:" + makeCode + " + model:" + modelCode + " + year:" + yearCode + " + body:" + bodyCode + " + trans:" + transmissionCode + " + fuel:" + fuelCode;
			logger.error(message, e);
			throw new ServiceException(message, e);
		}
	}

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
	public static Map<String, Object> getVehicleSelectionMap(String makeCode, String modelCode, String yearCode, String bodyCode, String transmissionCode, String fuelCode) {
		Map<String, Object> result = new LinkedHashMap<>();
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

		result.put(CarMake.JSON_COLLECTION_NAME, carMakes);
		result.put(CarModel.JSON_COLLECTION_NAME, carModels);
		result.put(CarYear.JSON_COLLECTION_NAME, carYears);
		result.put(CarBody.JSON_COLLECTION_NAME, carBodies);
		result.put(CarTransmission.JSON_COLLECTION_NAME, carTrans);
		result.put(CarFuel.JSON_COLLECTION_NAME, carFuels);
		result.put(CarType.JSON_COLLECTION_NAME, carTypes);

		return result;
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
			String message = "Could not get makes";
			logger.error(message, e);
			throw new ServiceException(message, e);
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
			String message = "Could not get models for make:" + makeCode;
			logger.error(message, e);
			throw new ServiceException(message, e);
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
			String message = "Could not get years for make:" + makeCode + " + model:" + modelCode;
			logger.error(message, e);
			throw new ServiceException(message, e);
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
			String message = "Could not get bodies for make:" + makeCode + " + model:" + modelCode + " + year:" + yearCode;
			logger.error(message, e);
			throw new ServiceException(message, e);
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
			String message = "Could not get transmissions for make:" + makeCode + " + model:" + modelCode + " + year:" + yearCode + " + body:" + bodyCode;
			logger.error(message, e);
			throw new ServiceException(message, e);
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
			String message = "Could not get fuels for make:" + makeCode + " + model:" + modelCode + " + year:" + yearCode + " + body:" + bodyCode + " + trans:" + transmissionCode;
			logger.error(message, e);
			throw new ServiceException(message, e);
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
			String message = "Could not get types for make:" + makeCode + " + model:" + modelCode + " + year:" + yearCode + " + body:" + bodyCode + " + trans:" + transmissionCode + " + fuel:" + fuelCode;
			logger.error(message, e);
			throw new ServiceException(message, e);
		}

		return carTypes;
	}

	public static JSONObject getVehicleNonStandardsJson() {

		Map<String, List<VehicleNonStandard>> result = new HashMap<>();
		result.put("items", getVehicleNonStandards());

		try {
			return new JSONObject(objectMapper.writeValueAsString(result));
		} catch (JsonProcessingException | JSONException e) {
			logger.error("Could not get vehicle non standards json", e);
		}
		return null;
	}


	public static List<VehicleNonStandard> getVehicleNonStandards() {
		List<VehicleNonStandard> vehicleNonStandards = new ArrayList<VehicleNonStandard>();
		VehicleNonStandardDao dao = new VehicleNonStandardDao();

		try {

			vehicleNonStandards = dao.getVehicleNonStandards();

		}
		catch (DaoException e) {
			String message = "Could not get vehicle non standards";
			logger.error(message, e);
			throw new ServiceException(message, e);
		}

		return vehicleNonStandards;
	}

	public static List<VehicleAccessory> getStandardAccessories(String redBookCode) {
		List<VehicleAccessory> accessories = new ArrayList<>();
		VehicleAccessoryDao dao = new VehicleAccessoryDao();
		try {
			accessories = dao.getStandardAccessories(redBookCode);
		}
		catch (DaoException e) {
			String message = "Could not get vehicle standard accessories";
			logger.error(message, e);
			throw new ServiceException(message, e);
		}
		return accessories;
	}

	public static List<VehicleAccessory> getOptionalAccessories(String redBookCode) {
		List<VehicleAccessory> accessories = new ArrayList<>();
		VehicleAccessoryDao dao = new VehicleAccessoryDao();
		try {
			accessories = dao.getOptionalAccessories(redBookCode);
		}
		catch (DaoException e) {
			String message = "Could not get vehicle optional accessories";
			logger.error(message, e);
			throw new ServiceException(message, e);
		}
		return accessories;
	}

	public static List<VehicleAccessory> getAlarmAccessories(String redBookCode) {
		List<VehicleAccessory> accessories = new ArrayList<>();
		VehicleAccessoryDao dao = new VehicleAccessoryDao();
		try {
			accessories = dao.getAlarmAccessories(redBookCode);
		}
		catch (DaoException e) {
			String message = "Could not get vehicle alarm accessories";
			logger.error(message, e);
			throw new ServiceException(message, e);
		}
		return accessories;
	}

	public static List<VehicleAccessory> getImmobiliserAccessories(String redBookCode) {
		List<VehicleAccessory> accessories = new ArrayList<>();
		VehicleAccessoryDao dao = new VehicleAccessoryDao();
		try {
			accessories = dao.getImmobiliserAccessories(redBookCode);
		}
		catch (DaoException e) {
			String message = "Could not get vehicle immobiliser accessories";
			logger.error(message, e);
			throw new ServiceException(message, e);
		}
		return accessories;
	}

	public static List<VehicleNonStandardMapping> getVehicleNonStandardMappings() {
		List<VehicleNonStandardMapping> mappings = new ArrayList<>();
		VehicleNonStandardDao dao = new VehicleNonStandardDao();

		try {

			mappings = dao.getVehicleNonStandardMappings();

		}
		catch (DaoException e) {
			String message = "Could not get vehicle non standard mappings";
			logger.error(message, e);
			throw new ServiceException(message, e);
		}

		return mappings;
	}

	/**
	 * Check if the redbookCode exist for the year specified, else would look for the previous year
	 * and if still doesn't exist then look for the redbookCode without the year.
	 * @param redbookCode
	 * @param year
	 * @return
	 */
	public static String getGlassesCode(String redbookCode, int year) {

		LocalDate now = new LocalDate();
		int dayOfYear = now.get(DateTimeFieldType.dayOfYear());
		int currentYear = now.getYear();

		GlassesDao dao = new GlassesDao();

		// get the glassesCode for the specified year
		String glassesCode = getGlassesCode(redbookCode, year, dao);

		// if glassesCode is empty from the specified year
		// look for the glassesCode from the previous year only if the year is the current year
		if (StringUtils.isEmpty(glassesCode) && dayOfYear <= 91 && year == currentYear) {
			glassesCode = getGlassesCode(redbookCode, year -1, dao);
		}

		// if the glassesCode is still empty then look for the redbookCode without the year
		if (StringUtils.isEmpty(glassesCode)) {
			try {
				glassesCode = dao.getGlassesCode(redbookCode);

			} catch (DaoException e) {
				String message = "Could not get vehicle non standard mappings for redbookCode:" + redbookCode;
				logger.error(message, e);
				throw new ServiceException(message, e);
			}
		}
		return glassesCode;
	}

	private static String getGlassesCode(String redbookCode, int year, GlassesDao dao) {
		try {
			return dao.getGlassesCode(redbookCode, year);
		} catch (DaoException e) {
			String message = "Could not get vehicle non standard mappings for redbookCode:" + redbookCode + " year:" + year;
			logger.error(message, e);
			throw new ServiceException(message, e);
		}
	}

	public static CarProduct getCarProduct(Date date, String productId, int styleCodeId) {
		CarProductDao dao = new CarProductDao();
		try {
			return dao.getCarProduct(date, productId, styleCodeId);
		} catch (DaoException e) {
			String message = "Could not get CarProduct for productId:" + productId;
			logger.error(message, e);
			throw new ServiceException(message, e);
		}
	}

}
