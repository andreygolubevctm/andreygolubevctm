package com.ctm.web.car.router;

import com.ctm.web.car.model.*;
import com.ctm.web.car.services.CarVehicleSelectionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Path("/car")
public class CarRouter {
	private static final Logger LOGGER = LoggerFactory.getLogger(CarRouter.class);

	@GET
	@Path("/makes/list.json")
	@Produces("application/json")
	public Map<String, List<CarMake>> getMakes(@Context HttpServletRequest request,
											   @Context HttpServletResponse response) {
		addAllowOriginHeader(request, response);

		Map<String, List<CarMake>> result = new HashMap<>();
		result.put(CarMake.JSON_COLLECTION_NAME, CarVehicleSelectionService.getAllMakes());
		return result;
	}

	private void addAllowOriginHeader(@Context HttpServletRequest request, @Context HttpServletResponse response) {
		final Optional<String> origin = Optional.ofNullable(request.getHeader("Origin"))
				.map(String::toLowerCase)
				.filter(s -> s.contains("comparethemarket.com.au"));
		if(origin.isPresent()) {
			LOGGER.debug("Adding Allow-Origin header for: {}", kv("remote address access", origin));
			response.setHeader("Access-Control-Allow-Origin", request.getHeader("Origin"));
		}
	}

	@GET
	@Path("/models/list.json")
	@Produces("application/json")
	public Map<String, List<CarModel>> getModels(@QueryParam("make") String makeCode,
												 @Context HttpServletRequest request,
												 @Context HttpServletResponse response) {
		addAllowOriginHeader(request, response);

		Map<String, List<CarModel>> result = new HashMap<>();
		result.put(CarModel.JSON_COLLECTION_NAME, CarVehicleSelectionService.getModels(makeCode));
		return result;
	}

	@GET
	@Path("/years/list.json")
	@Produces("application/json")
	public Map<String, List<CarYear>> getYears(@QueryParam("make") String makeCode,
											   @QueryParam("model") String modelCode,
											   @Context HttpServletRequest request,
											   @Context HttpServletResponse response) {
		addAllowOriginHeader(request, response);

		Map<String, List<CarYear>> result = new HashMap<>();
		result.put(CarYear.JSON_COLLECTION_NAME, CarVehicleSelectionService.getYears(makeCode, modelCode));
		return result;
	}

	@GET
	@Path("/bodies/list.json")
	@Produces("application/json")
	public Map<String, List<CarBody>> getBodies(@QueryParam("make") String makeCode, @QueryParam("model") String modelCode, @QueryParam("year") String yearCode) {
		Map<String, List<CarBody>> result = new HashMap<>();
		result.put(CarBody.JSON_COLLECTION_NAME, CarVehicleSelectionService.getBodies(makeCode, modelCode, yearCode));
		return result;
	}

	@GET
	@Path("/transmissions/list.json")
	@Produces("application/json")
	public Map<String, List<CarTransmission>> getTransmissions(@QueryParam("make") String makeCode, @QueryParam("model") String modelCode,
															   @QueryParam("year") String yearCode, @QueryParam("body") String bodyCode) {
		Map<String, List<CarTransmission>> result = new HashMap<>();
		result.put(CarTransmission.JSON_COLLECTION_NAME, CarVehicleSelectionService.getTransmissions(makeCode, modelCode, yearCode, bodyCode));
		return result;
	}

	@GET
	@Path("/fuels/list.json")
	@Produces("application/json")
	public Map<String, List<CarFuel>> getFuels(@QueryParam("make") String makeCode, @QueryParam("model") String modelCode,
											   @QueryParam("year") String yearCode, @QueryParam("body") String bodyCode,
											   @QueryParam("transmission") String transmissionCode, @QueryParam("fuel") String fuelCode) {
		Map<String, List<CarFuel>> result = new HashMap<>();
		result.put(CarFuel.JSON_COLLECTION_NAME, CarVehicleSelectionService.getFuels(makeCode, modelCode, yearCode, bodyCode, transmissionCode));
		return result;
	}

	@GET
	@Path("/types/list.json")
	@Produces("application/json")
	public Map<String, List<CarType>> getTypes(@QueryParam("make") String makeCode, @QueryParam("model") String modelCode,
											   @QueryParam("year") String yearCode, @QueryParam("body") String bodyCode,
											   @QueryParam("transmission") String transmissionCode, @QueryParam("fuel") String fuelCode) {
		Map<String, List<CarType>> result = new HashMap<>();
		result.put(CarType.JSON_COLLECTION_NAME, CarVehicleSelectionService.getTypes(makeCode, modelCode, yearCode, bodyCode, transmissionCode, fuelCode));
		return result;
	}

	@GET
	@Path("/colours/list.json")
	@Produces("application/json")
	public Map<String, List<CarColour>> getColours() {
		Map<String, List<CarColour>> result = new HashMap<>();
		result.put(CarColour.JSON_COLLECTION_NAME, CarVehicleSelectionService.getAllColours());
		return result;
	}

	@GET
	@Path("/vehicleNonStandards/list.json")
	@Produces("application/json")
	public Map<String, List<VehicleNonStandard>> getVehicleNonStandards() {
		Map<String, List<VehicleNonStandard>> result = new HashMap<>();
		result.put("items", CarVehicleSelectionService.getVehicleNonStandards());
		return result;
	}

	@GET
	@Path("/vehicleAccessories/list.json")
	@Produces("application/json")
	public Map<String, List<VehicleAccessory>> getVehicleAccessories(@QueryParam("redbookCode")String redbookCode) {
		Map<String, List<VehicleAccessory>> result = new HashMap<>();
		result.put("standard", CarVehicleSelectionService.getStandardAccessories(redbookCode));
		result.put("options", CarVehicleSelectionService.getOptionalAccessories(redbookCode));
		result.put("alarm", CarVehicleSelectionService.getAlarmAccessories(redbookCode));
		result.put("immobiliser", CarVehicleSelectionService.getImmobiliserAccessories(redbookCode));
		return result;
	}
}
