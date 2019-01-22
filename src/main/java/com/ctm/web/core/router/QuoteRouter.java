package com.ctm.web.core.router;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ctm.web.core.exceptions.SessionExpiredException;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.utils.RequestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONObject;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.services.QuoteService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.web.go.Data;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

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
	private static final Logger LOGGER = LoggerFactory.getLogger(QuoteRouter.class);
	private static final long serialVersionUID = 69L;

	private final SessionDataService sessionDataService = new SessionDataService();

	/**
	 * Captures the (e.g. /quote/write.json) URL and calls the service.
	 *
	 * @param request The incoming request
	 * @param response The outgoing response
	 *
	 */
	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();
		long transactionId = RequestUtils.getTransactionIdFromRequest(request);
		if (transactionId < 1) {
			LOGGER.error("Empty Transaction id {}", kv("transactionId", transactionId));
			FatalErrorService.logFatalError(0, "QuoteRouter " + uri, request.getSession().getId(), false, "Empty Transaction id", "", request.getParameter("transactionId"));
		} else {
			/**
			 * Set content-type header based on uri extension.
			 */
			if (uri.endsWith(".json")) {
				response.setContentType("application/json");
			}
			try {
				Data dataBucket = getData(request, transactionId);
				QuoteService quoteService = new QuoteService();
				/**
				 * Route the requests.
				 */
				// Future functionality to replace write_quote.tag.
				if (uri.endsWith("/quote/write.json")) {
					if (dataBucket == null) {
						dataBucket = sessionDataService.addNewTransactionDataToSession(request);
					}
					writer.print(quoteService.write(request, transactionId, dataBucket));
				} else if (uri.endsWith("/quote/write_lite.json")) {
					writer.print(quoteService.writeLite(request, transactionId, dataBucket));
				} else {
					writer.print(new JSONObject().toString());
				}
			} catch(SessionExpiredException e) {
				LOGGER.info(e.getMessage() + " {}", kv("requestUri", request.getRequestURI()), e);
			} catch (DaoException | SessionException e) {
				LOGGER.error("Failed handling quote request {}", kv("requestUri", request.getRequestURI()), e);
				// Fails silently.

				// Real write quote would need to throw exception
			}
		}
	}

	/**
	 * Retrieve the current sessions data bucket
	 */
	private Data getData(HttpServletRequest request, long transactionId) throws SessionException, SessionExpiredException {
		SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
		if (sessionData == null) {
			throw new SessionExpiredException("Session has expired");
		}
		return sessionData.getSessionDataForTransactionId(transactionId);
	}
}
