package com.ctm.router.health;

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

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.services.simples.ProviderContentService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@WebServlet(urlPatterns = {
		"/health/provider/content/get.json"
})
public class HealthRouter extends HttpServlet {

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(HealthRouter.class.getName());
	private static final long serialVersionUID = 5468545645645645644L;
	private final ObjectMapper objectMapper = new ObjectMapper();
	JSONObject json = new JSONObject();
	PrintWriter writer;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();
		writer = response.getWriter();

		// Automatically set content type based on request extension ////////////////////////////////////////

		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		// Route the requests ///////////////////////////////////////////////////////////////////////////////
		if (uri.endsWith("/health/provider/content/get.json")) {
			getProviderContent(request, response);
		}
	}


	private void getProviderContent(HttpServletRequest request, HttpServletResponse response) throws IOException {
		ProviderContentService providerContentService = new ProviderContentService();
		try {
			json.put("providerContentText", providerContentService.getProviderContentText(request));
		} catch (final DaoException | JSONException | ConfigSettingException e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			objectMapper.writeValue(writer, errors(e));
		}
		writer.print(json.toString());
	}

	private ObjectNode errors(final Exception e) {
		final Error error = new Error(e.getMessage());
		return jsonObjectNode("errors", error);
	}

	private <T> ObjectNode jsonObjectNode(final String name, final T value) {
		final ObjectNode objectNode = objectMapper.createObjectNode();
		objectNode.putPOJO(name, value);
		return objectNode;
	}
}