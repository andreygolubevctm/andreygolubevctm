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

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.session.SessionData;
import com.ctm.services.QuoteService;
import com.ctm.services.SessionDataService;
import com.disc_au.web.go.Data;

/**
 * To handle writing and retrieving of quotes.
 *
 * @author bthompson
 *
 */
@WebServlet(urlPatterns = {
		"/quote/write_lite.json",
		"/quote/write.json",
		"/quote/load.json"
})
public class QuoteRouter extends HttpServlet {
	private static Logger logger = Logger.getLogger(QuoteRouter.class.getName());
	private static final long serialVersionUID = 69L;

	/**
	 * Captures the (e.g. /quote/write.json) URL and calls the service.
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
		 * It is OK to retrieve the transactionId from the request, as we
		 * check further on if its in the data bucket.
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
		Data dataBucket = null;
		try {
			SessionData sessionData = SessionDataService.getSessionDataFromSession(request);
			if (sessionData == null ) {
				throw new SessionException("session has expired");
			}
			dataBucket = sessionData.getSessionDataForTransactionId(String.valueOf(transactionId));

			QuoteService quoteService = new QuoteService();

			/**
			 * Route the requests.
			 */
			// Future functionality to replace write_quote.tag.
			if (uri.endsWith("/quote/write.json")) {
				if (dataBucket == null) {
					dataBucket = SessionDataService.addNewTransactionDataToSession(request);
				}
				writer.print(quoteService.write(request, transactionId, dataBucket));
			}

			else if (uri.endsWith("/quote/write_lite.json")) {
				writer.print(quoteService.writeLite(request, transactionId, dataBucket));
			}

			else {
				writer.print(new JSONObject().toString());
			}

		} catch (DaoException | SessionException e) {
			logger.error(e);
			// Fails silently.
			// Real write quote would need to throw exception
		}

	}
}
