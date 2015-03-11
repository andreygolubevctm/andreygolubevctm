package com.ctm.router;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ctm.model.Error;
import com.ctm.services.simples.MessageConfigService;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.exceptions.DaoException;

@WebServlet(urlPatterns = {
		"/health/optin/isInAntiHawkingTimeframe.json"
})
public class HealthRouter extends HttpServlet {

	@SuppressWarnings("unused")
	private static Logger logger = Logger.getLogger(HealthRouter.class.getName());
	private static final long serialVersionUID = 5468545645645645644L;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		// Automatically set content type based on request extension ////////////////////////////////////////

		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		// Route the requests ///////////////////////////////////////////////////////////////////////////////

		if (uri.endsWith("/health/optin/isInAntiHawkingTimeframe.json")) {

			MessageConfigService service = new MessageConfigService();
			JSONObject json = new JSONObject();
			try {
				String state = request.getParameter("state");
				json.put("isInAntiHawkingTimeframe", service.isInAntiHawkingTimeframe(request, state) );

			} catch (DaoException | JSONException e) {
				Error error = new Error("Failed to check Anti Hawking time frame");
				json = error.toJsonObject(true);
				logger.error("/health/optin/isInAntiHawkingTimeframe.json failed: ", e);
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
			writer.print(json.toString());
		}


	}
}
