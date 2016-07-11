package com.ctm.web.health.router;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceException;
import com.ctm.web.core.model.Error;
import com.ctm.web.health.services.ProviderContentService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(urlPatterns = {
		"/health/provider/content/get.json"
})
public class HealthRouter extends HttpServlet {

	private static final long serialVersionUID = 5468545645645645644L;
	private final ObjectMapper objectMapper = new ObjectMapper();

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		// Automatically set content type based on request extension ////////////////////////////////////////

		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		// Route the requests ///////////////////////////////////////////////////////////////////////////////
		if (uri.endsWith("/health/provider/content/get.json")) {
			getProviderContent(request, response, writer);
		}
	}
	
	
	private void getProviderContent(HttpServletRequest request, HttpServletResponse response, PrintWriter writer) throws IOException {
		ProviderContentService providerContentService = new ProviderContentService();
		JSONObject json = new JSONObject();
		try {
			json.put("providerContentText", providerContentService.getProviderContentText(request));
		} catch (final ServiceException | JSONException e) {
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
