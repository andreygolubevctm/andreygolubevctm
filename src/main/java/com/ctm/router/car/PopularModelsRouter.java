package com.ctm.router.car;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.services.car.PopularModelsService;

import static com.ctm.logging.LoggingArguments.kv;


@WebServlet(urlPatterns = {
	"/car/execute/popularModels.json"
})
public class PopularModelsRouter extends HttpServlet {
	private static final long serialVersionUID = 66L;
	private static final Logger logger = LoggerFactory.getLogger(PopularModelsRouter.class.getName());

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		// Instantiate and call service to update the popular models table
		PopularModelsService popularModelsService = new PopularModelsService();
		String lastUpdated = popularModelsService.execute();

		// Helpers to write out response
		PrintWriter writer = response.getWriter();
		JSONObject json = new JSONObject();

		// Stop our response from caching
		response.setHeader("Cache-Control","no-cache, max-age=0");
		response.setHeader("Pragma","no-cache");
		response.setHeader("Expires","-1");

		response.setContentType("application/json");

		// Add the last updated date to the json
		try {
			json.append("updated", lastUpdated);
		} catch (JSONException e) {
			logger.error("Failed create popular models json response {}", kv("lastUpdated", lastUpdated), e);
		}

		// Write json to response
		writer.print(json.toString());
	}
}
