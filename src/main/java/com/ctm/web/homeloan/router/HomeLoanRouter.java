package com.ctm.web.homeloan.router;

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

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Error;
import com.ctm.web.homeloan.model.HomeLoanModel;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.homeloan.services.HomeLoanOpportunityService;
import com.ctm.web.homeloan.services.HomeLoanResultsService;
import com.ctm.web.homeloan.services.HomeLoanService;


@WebServlet(urlPatterns = {
		"/homeloan/results/get.json",
		"/homeloan/opportunity/submit.json",
		"/cron/homeloan/flexOutboundLead.json"
})
public class HomeLoanRouter extends HttpServlet {
	private static final Logger LOGGER = LoggerFactory.getLogger(HomeLoanRouter.class);
	private static final long serialVersionUID = 70L;

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		PrintWriter writer = response.getWriter();


		// Automatically set content type based on request extension ////////////////////////////////////////

		String uri = request.getRequestURI();
		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}


		// Route the requests ///////////////////////////////////////////////////////////////////////////////

		if (uri.endsWith("/homeloan/results/get.json")) {
			JSONObject json = null;

			try {
				SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.HOMELOAN.getCode());

				HomeLoanResultsService homeLoanResultsService = new HomeLoanResultsService();
				json = homeLoanResultsService.getResults(request);

				if (json == null) {
					throw new DaoException("getResults returned null");
				}
			}
			catch (DaoException | ConfigSettingException e) {
				LOGGER.error("Failed getting homeloan results", e);

				Error error = new Error();
				error.addError(new Error("Failed to get results"));
				json = error.toJsonObject(true);

				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}

			writer.print(json.toString());
		}

		else if (uri.endsWith("/homeloan/opportunity/submit.json")) {
			JSONObject json = null;

			try {
				SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.HOMELOAN.getCode());

				HomeLoanOpportunityService oppService = new HomeLoanOpportunityService();
				HomeLoanModel model = HomeLoanService.mapParametersToModel(request);
				json = oppService.submitOpportunity(request, model);

				if (json == null) {
					throw new DaoException("Create opportunity returned null");
				}
			}
			catch (Exception e) {
				LOGGER.error("HomeLoan opportunity apply failed", e);

				Error error = new Error();
				error.addError(new Error("Failed to submit opportunity"));
				json = error.toJsonObject(true);

				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}

			writer.print(json.toString());
		}
	}

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		PrintWriter writer = response.getWriter();

		// Automatically set content type based on request extension ////////////////////////////////////////

		String uri = request.getRequestURI();
		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		// Route the requests ///////////////////////////////////////////////////////////////////////////////
		if (uri.endsWith("/homeloan/flexOutboundLead.json")) {
			JSONObject json = null;
			HomeLoanService service = new HomeLoanService();

			try {
				SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.HOMELOAN.getCode());
				json = service.scheduledLeadGenerator(request);
			} catch (Exception e) {
				LOGGER.error("HomeLoan scheduledLeadGenerator failed", e);

				Error error = new Error();
				error.addError(new Error(e.getMessage()));
				json = error.toJsonObject(true);

				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}

			writer.print(json.toString());
		}

	}
}
