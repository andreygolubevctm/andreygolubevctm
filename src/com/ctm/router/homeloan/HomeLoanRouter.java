package com.ctm.router.homeloan;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.model.homeloan.HomeLoanModel;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.SettingsService;
import com.ctm.services.homeloan.HomeLoanOpportunityService;
import com.ctm.services.homeloan.HomeLoanResultsService;
import com.ctm.services.homeloan.HomeLoanService;


@WebServlet(urlPatterns = {
		"/homeloan/results/get.json",
		"/homeloan/opportunity/submit.json"
})
public class HomeLoanRouter extends HttpServlet {
	private static Logger logger = Logger.getLogger(HomeLoanRouter.class.getName());
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
				logger.error("/homeloan/results/get.json failed: ", e);

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
				logger.error("HomeLoan opportunity apply failed", e);

				Error error = new Error();
				error.addError(new Error("Failed to submit opportunity"));
				json = error.toJsonObject(true);

				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}

			writer.print(json.toString());
		}

	}
}
