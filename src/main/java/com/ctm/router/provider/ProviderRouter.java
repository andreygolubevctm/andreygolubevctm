package com.ctm.router.provider;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONObject;

import com.ctm.model.Error;
import com.ctm.model.Provider;
import com.ctm.services.SettingsService;
import com.ctm.services.provider.ProviderService;
import com.fasterxml.jackson.databind.ObjectMapper;


@WebServlet(urlPatterns = {
		"/provider/list.json"
})
public class ProviderRouter extends HttpServlet {

	private static final Logger LOGGER = LoggerFactory.getLogger(ProviderRouter.class);
	private static final long serialVersionUID = 72L;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		// Automatically set content type based on request extension ////////////////////////////////////////

		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		try {

			ObjectMapper objectMapper;
			// Set the vertical in the request object - required for loading of Settings and Config.
			SettingsService.setVerticalAndGetSettingsForPage(request, request.getParameter("verticalCode"));

			// Route the requests ////////////////

			if (uri.endsWith("/provider/list.json")) {
				ArrayList<Provider> providers = ProviderService.fetchProviders(request);
				objectMapper = new ObjectMapper();
				objectMapper.writeValue(writer, providers);
			}

		}catch (Exception e) {

			LOGGER.error("Provider listing failed", e);

			JSONObject json = null;
			Error error = new Error();
			error.addError(new Error("An error occurred fetching providers."));
			json = error.toJsonObject(true);

			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

			writer.print(json.toString());
		}

	}

}
