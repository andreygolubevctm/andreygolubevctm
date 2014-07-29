package com.ctm.router;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.ctm.model.car.CarBody;
import com.ctm.model.car.CarFuel;
import com.ctm.model.car.CarMake;
import com.ctm.model.car.CarModel;
import com.ctm.model.car.CarTransmission;
import com.ctm.model.car.CarType;
import com.ctm.model.car.CarYear;
import com.ctm.model.formatter.JsonUtils;
import com.ctm.services.car.CarVehicleSelectionService;

@WebServlet(urlPatterns = {
		"/car/bodies/list.json",
		"/car/fuels/list.json",
		"/car/makes/list.json",
		"/car/models/list.json",
		"/car/transmissions/list.json",
		"/car/types/list.json",
		"/car/years/list.json"
})
public class CarRouter extends HttpServlet {
	private static Logger logger = Logger.getLogger(CarRouter.class.getName());
	private static final long serialVersionUID = 14L;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		// Automatically set content type based on request extension ////////////////////////////////////////

		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}


		// Get common parameters ////////////////////////////////////////////////////////////////////////////

		String makeCode = null;
		String modelCode = null;
		String yearCode = null;
		String bodyCode = null;
		String transmissionCode = null;
		String fuelCode = null;

		if (request.getParameter("make") != null) {
			makeCode = request.getParameter("make");
		}
		if (request.getParameter("model") != null) {
			modelCode = request.getParameter("model");
		}
		if (request.getParameter("year") != null) {
			yearCode = request.getParameter("year");
		}
		if (request.getParameter("body") != null) {
			bodyCode = request.getParameter("body");
		}
		if (request.getParameter("transmission") != null) {
			transmissionCode = request.getParameter("transmission");
		}
		if (request.getParameter("fuel") != null) {
			fuelCode = request.getParameter("fuel");
		}


		// Route the requests ///////////////////////////////////////////////////////////////////////////////

		if (uri.endsWith("/car/bodies/list.json")) {
			JSONObject json = new JSONObject();
			JsonUtils.addListToJsonObject(json, CarBody.JSON_COLLECTION_NAME, CarVehicleSelectionService.getBodies(makeCode, modelCode, yearCode));
			writer.print(json.toString());
		}

		else if (uri.endsWith("/car/fuels/list.json")) {
			JSONObject json = new JSONObject();
			JsonUtils.addListToJsonObject(json, CarFuel.JSON_COLLECTION_NAME, CarVehicleSelectionService.getFuels(makeCode, modelCode, yearCode, bodyCode, transmissionCode));
			writer.print(json.toString());
		}

		else if (uri.endsWith("/car/makes/list.json")) {
			JSONObject json = new JSONObject();
			JsonUtils.addListToJsonObject(json, CarMake.JSON_COLLECTION_NAME, CarVehicleSelectionService.getAllMakes());
			writer.print(json.toString());
		}

		else if (uri.endsWith("/car/models/list.json")) {
			JSONObject json = new JSONObject();
			JsonUtils.addListToJsonObject(json, CarModel.JSON_COLLECTION_NAME, CarVehicleSelectionService.getModels(makeCode));
			writer.print(json.toString());
		}

		else if (uri.endsWith("/car/transmissions/list.json")) {
			JSONObject json = new JSONObject();
			JsonUtils.addListToJsonObject(json, CarTransmission.JSON_COLLECTION_NAME, CarVehicleSelectionService.getTransmissions(makeCode, modelCode, yearCode, bodyCode));
			writer.print(json.toString());
		}

		else if (uri.endsWith("/car/types/list.json")) {
			JSONObject json = new JSONObject();
			JsonUtils.addListToJsonObject(json, CarType.JSON_COLLECTION_NAME, CarVehicleSelectionService.getTypes(makeCode, modelCode, yearCode, bodyCode, transmissionCode, fuelCode));
			writer.print(json.toString());
		}

		else if (uri.endsWith("/car/years/list.json")) {
			JSONObject json = new JSONObject();
			JsonUtils.addListToJsonObject(json, CarYear.JSON_COLLECTION_NAME, CarVehicleSelectionService.getYears(makeCode, modelCode));
			writer.print(json.toString());
		}

	}
}
