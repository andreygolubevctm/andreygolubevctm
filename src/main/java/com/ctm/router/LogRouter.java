package com.ctm.router;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONObject;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.services.FormValidationService;
import com.ctm.services.SessionDataService;
import com.disc_au.web.go.Data;

/**
 * To handle writing and retrieving of quotes.
 * fatal/nonfatal could be implemented later.
 * @author bthompson
 *
 */
@WebServlet(urlPatterns = {
		"/logging/validation.json",
		"/logging/fatal.json",
		"/logging/nonfatal.json"
})
public class LogRouter extends HttpServlet {
	private static final Logger LOGGER = LoggerFactory.getLogger(LogRouter.class);
	private static final long serialVersionUID = 71L;

	private final SessionDataService sessionDataService = new SessionDataService();

	/**
	 * Captures the URL and calls the appropriate service.
	 *
	 * @param request The incoming request
	 * @param response The outgoing response
	 *
	 */
	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		PrintWriter writer = response.getWriter();
			/**
		 * Get the transactionId from the request.
		 */
		Long transactionId = null;
		if (request.getParameter("transactionId") != null) {
			transactionId = Long.parseLong(request.getParameter("transactionId"));
		}
		/**
		 * Set content-type header based on uri extension.
		 */
		String uri = request.getRequestURI();
		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		/**
		 * Retrieve the current sessions data bucket
		 */
		@SuppressWarnings("unused")
		Data dataBucket = null;
		try {
			dataBucket = sessionDataService.getDataForTransactionId(request, String.valueOf(transactionId), false);

			/**
			 * Route the requests.
			 */
			if (uri.endsWith("/logging/validation.json")) {
				FormValidationService service = new FormValidationService();
				service.logValidationMessage(request, transactionId);
				writer.print(new JSONObject().toString());
			}
			/**
			 * Example code of how fatal error logging could be implemented here
			 */
			/*else if (uri.endsWith("/logging/fatal.json")) {
				FatalErrorDao formValidationDao = new FatalErrorDao();
				FatalErrorService service = new FatalErrorService();
				//int styleCodeId, String page , String sessionId, boolean isFatal, String message, String description, String transactionId

				writer.print(service.logFatalError(request, transactionId, dataBucket,
						pageSettings));
			}*/

			else {
				writer.print(new JSONObject().toString());
			}
		} catch (DaoException | SessionException e) {
			LOGGER.error("Failed to log form validation errors", e);
		}

	}
}
