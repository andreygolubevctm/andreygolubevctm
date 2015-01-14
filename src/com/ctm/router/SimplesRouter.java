package com.ctm.router;

import com.ctm.dao.UserDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.Error;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.model.simples.Message;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.services.TransactionService;
import com.ctm.services.simples.SimplesMessageService;
import com.ctm.services.simples.SimplesUserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import static com.ctm.services.PhoneService.makeCall;
import static java.lang.Integer.parseInt;
import static java.util.Arrays.asList;
import static javax.servlet.http.HttpServletResponse.*;

@WebServlet(urlPatterns = {
		"/simples/comments/list.json",
		"/simples/messages/get.json",
		"/simples/messages/next.json",
		"/simples/messages/postponed.json",
		"/simples/tickle.json",
		"/simples/transactions/details.json",
		"/simples/users/list_online.json",
		"/simples/users/stats_today.json",
		"/simples/phones/call"
})
public class SimplesRouter extends HttpServlet {
	private static final long serialVersionUID = 13L;
	private static Logger logger = Logger.getLogger(SimplesRouter.class.getName());
	private final ObjectMapper objectMapper = new ObjectMapper();
	private final SessionDataService sessionDataService;

	@SuppressWarnings("UnusedDeclaration")
	public SimplesRouter() {
		this(new SessionDataService());
	}

	public SimplesRouter(SessionDataService sessionDataService) {
		this.sessionDataService = sessionDataService;
		objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
	}

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		// Automatically set content type based on request extension ////////////////////////////////////////

		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}


		// Get common parameters ////////////////////////////////////////////////////////////////////////////

		Long transactionId = null;
		if (request.getParameter("transactionId") != null) {
			// throws NumberFormatException
			transactionId = Long.parseLong(request.getParameter("transactionId"));
		}

		AuthenticatedData authenticatedData = null;
		if (request.getSession() != null) {
			authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
		} else {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			return;
		}


		// Route the requests ///////////////////////////////////////////////////////////////////////////////

		if (uri.endsWith("/simples/comments/list.json")) {
			writer.print(TransactionService.getCommentsForTransactionId(transactionId));
		}

		else if (uri.endsWith("/simples/messages/next.json")) {
			getNextMessage(writer, request, response, authenticatedData);
			}

		else if (uri.endsWith("/simples/messages/get.json")) {
			getMessage(writer, request, response);
		}

		else if (uri.endsWith("/simples/messages/postponed.json")) {
			postponedMessages(writer, authenticatedData);
		}

		else if (uri.endsWith("/simples/tickle.json")) {
			response.setHeader("Cache-Control", "no-cache, max-age=0");
			response.setHeader("Pragma","no-cache");
			response.setHeader("Expires","-1");

			try {
				SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.SIMPLES.getCode());

				// Keep the transaction fresh in user's session
				sessionDataService.getDataForTransactionId(request, transactionId.toString(), false);

				// Keep user fresh
				final int simplesUid = authenticatedData.getSimplesUid();
				final UserDao userDao = new UserDao();
				userDao.tickleUser(simplesUid);

				objectMapper.writeValue(writer, jsonObjectNode("status", "OK"));
			}
			catch (ConfigSettingException | DaoException | SessionException e) {
				throw new ServletException(e);
			}
		}

		else if (uri.endsWith("/simples/transactions/details.json")) {
			objectMapper.writeValue(writer, TransactionService.getMoreDetailsOfTransaction(transactionId));
		}

		else if (uri.endsWith("/simples/users/list_online.json")) {
			PageSettings settings = SettingsService.getPageSettingsByCode("CTM", VerticalType.SIMPLES.getCode());
			final SimplesUserService simplesUserService = new SimplesUserService();
			writer.print(simplesUserService.getUsersWhoAreLoggedIn(settings));
		}

		else if (uri.endsWith("/simples/users/stats_today.json")) {
			int simplesUid = authenticatedData.getSimplesUid();
			userStatsForToday(writer, simplesUid);
	}

		else if (uri.endsWith("/simples/phones/call")) {
			if (authenticatedData != null) {
				final String ext = authenticatedData.getExtension();
				final String phone = request.getParameter("phone");

				if (phone != null && !phone.isEmpty() && ext != null) {
					if (makeCall(settings(), ext, phone)) {
						response.setStatus(SC_OK);
					} else {
						response.sendError(SC_INTERNAL_SERVER_ERROR);
	}
				} else {
					response.sendError(SC_BAD_REQUEST);
				}
			}
		}

		else {
			response.sendError(SC_NOT_FOUND);
		}

	}

	private void postponedMessages(final PrintWriter writer, final AuthenticatedData authenticatedData) throws IOException {
		try {
			final int simplesUid = authenticatedData.getSimplesUid();
			final SimplesMessageService simplesMessageService = new SimplesMessageService();
			final List<Message> messages = simplesMessageService.postponedMessages(simplesUid);
			objectMapper.writeValue(writer, jsonObjectNode("messages", messages));
		}
		catch (final DaoException e) {
			objectMapper.writeValue(writer, errors(e));
		}
	}

	private void getMessage(final PrintWriter writer, final HttpServletRequest request, final HttpServletResponse response) throws IOException {
		try {
			final int messageId = parseInt(request.getParameter("messageId"));
			final SimplesMessageService simplesMessageService = new SimplesMessageService();
			objectMapper.writeValue(writer, simplesMessageService.getMessage(messageId));
		}
		catch (final DaoException e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			objectMapper.writeValue(writer, errors(e));
		}
		catch (final NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			objectMapper.writeValue(writer, errors(new Exception("messageId was not provided or is invalid.")));
		}
	}

	private void getNextMessage(final PrintWriter writer, final HttpServletRequest request, final HttpServletResponse response, final AuthenticatedData authenticatedData) throws IOException {
		int simplesUid = authenticatedData.getSimplesUid();
		try {
			SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.SIMPLES.getCode());

			final SimplesMessageService simplesMessageService = new SimplesMessageService();
			objectMapper.writeValue(writer, simplesMessageService.getNextMessageForUser(request, simplesUid));
		}
		catch (final DaoException | ConfigSettingException e) {
			logger.error("Could not get next message for user '"+simplesUid+"'", e);
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			objectMapper.writeValue(writer, errors(e));
		}
	}

	private void userStatsForToday(final PrintWriter writer, int userId) throws IOException {
		final SimplesUserService simplesUserService = new SimplesUserService();
		objectMapper.writeValue(writer, simplesUserService.getUserStatsForToday(userId));
	}

	private ObjectNode errors(final Exception e) {
		final Error error = new Error(e.getMessage());
		return jsonObjectNode("errors", asList(error));
	}

	private <T> ObjectNode jsonObjectNode(final String name, final T value) {
		final ObjectNode objectNode = objectMapper.createObjectNode();
		objectNode.putPOJO(name, value);
		return objectNode;
	}

	private PageSettings settings() {
		return SettingsService.getPageSettingsByCode("CTM", VerticalType.SIMPLES.getCode());
}
}
