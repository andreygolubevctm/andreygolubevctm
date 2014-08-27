package com.ctm.router;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ctm.dao.UserDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.services.SimplesService;
import com.ctm.services.TransactionService;

@WebServlet(urlPatterns = {
		"/simples/comments/list.json",
		"/simples/messages/next.json",
		"/simples/tickle",
		"/simples/transactions/details.json",
		"/simples/users/list_online.json"
})
public class SimplesRouter extends HttpServlet {
	private static final long serialVersionUID = 13L;

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
			authenticatedData = SessionDataService.getAuthenticatedSessionData(request);
			//authenticatedData = SessionDataService.getAuthenticatedSessionData(request.getSession());
		}


		// Route the requests ///////////////////////////////////////////////////////////////////////////////

		if (uri.endsWith("/simples/comments/list.json")) {
			writer.print(TransactionService.getCommentsForTransactionId(transactionId));
		}

		else if (uri.endsWith("/simples/messages/next.json")) {
			int simplesUid = authenticatedData.getSimplesUid();
			try {
				writer.print(SimplesService.getNextMessageForUser(request, simplesUid));
			}
			catch (ConfigSettingException e) {
				throw new ServletException(e);
			}
		}

		else if (uri.endsWith("/simples/tickle")) {
			response.setHeader("Cache-Control","no-cache, max-age=0");
			response.setHeader("Pragma","no-cache");
			response.setHeader("Expires","-1");

		/*	try {
				SettingsService.setVerticalAndGetSettingsForPage(request.getSession(), request, SimplesService.VERTICAL_CODE);

				// Keep the transaction fresh in user's session
				String transactionIdParam = request.getParameter("transactionId");
				SessionDataService.getDataForTransactionId(request.getSession(), request, transactionIdParam, false);

				// Keep user fresh
				int simplesUid = authenticatedData.getSimplesUid();
				UserDao userDao = new UserDao();
				userDao.tickleUser(simplesUid);

				writer.print("OK");
			}
			catch (DaoException | ConfigSettingException e) {
				throw new ServletException(e);
			}*/
		}

		else if (uri.endsWith("/simples/transactions/details.json")) {
			writer.print(TransactionService.getMoreDetailsOfTransaction(transactionId).toJson());
		}

		else if (uri.endsWith("/simples/users/list_online.json")) {
			PageSettings settings = SettingsService.getPageSettingsByCode("CTM", Vertical.SIMPLES_CODE);
			writer.print(SimplesService.getUsersWhoAreLoggedIn(settings));
		}

	}
}
