package com.ctm.router.utilities;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.ctm.model.Error;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.model.utilities.UtilitiesProductModel;
import com.ctm.model.utilities.UtilitiesProductRequestModel;
import com.ctm.model.utilities.UtilitiesProviderServiceModel;
import com.ctm.model.utilities.UtilitiesProviderServiceRequest;
import com.ctm.model.utilities.UtilitiesResultsModel;
import com.ctm.model.utilities.UtilitiesResultsRequestModel;
import com.ctm.services.SettingsService;
import com.ctm.services.utilities.UtilitiesProductService;
import com.ctm.services.utilities.UtilitiesProviderService;
import com.ctm.services.utilities.UtilitiesResultsService;


@WebServlet(urlPatterns = {
		"/utilities/providers/get.json",
		"/utilities/results/get.json",
		"/utilities/moreinfo/get.json",
		"/utilities/application/submit.json"
})
public class UtilitiesRouter extends HttpServlet {
	private static Logger logger = Logger.getLogger(UtilitiesRouter.class.getName());
	private static final long serialVersionUID = 70L;

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		// Automatically set content type based on request extension ////////////////////////////////////////

		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		try {

			// Set the vertical in the request object - required for loading of Settings and Config.
			SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.UTILITIES.getCode());

			// Route the requests ///////////////////////////////////////////////////////////////////////////////

			if (uri.endsWith("/utilities/providers/get.json")) {

				/** Get Services and Suppliers available for specified location */

				UtilitiesProviderServiceRequest model = new UtilitiesProviderServiceRequest();
				model.populateFromRequest(request);

				UtilitiesProviderService service = new UtilitiesProviderService();
				UtilitiesProviderServiceModel returnedModel = service.getResults(request, model);

				if (returnedModel == null) {
					throw new Exception("get services and providers returned null");
				}

				writer.print(returnedModel.toJson());

			} else if (uri.endsWith("/utilities/results/get.json")) {

				/** Product results FYI NOT USED */

				UtilitiesResultsRequestModel model = new UtilitiesResultsRequestModel();
				model.populateFromRequest(request);

				UtilitiesResultsService service = new UtilitiesResultsService();

				UtilitiesResultsModel returnedModel = service.getResults(request, model);

				if (returnedModel == null) {
					throw new Exception("getResults returned null");
				}

				writer.print(returnedModel.toJson());

			} else if (uri.endsWith("/utilities/moreinfo/get.json")) {

				/** Moreinfo product details */

				UtilitiesProductRequestModel model = new UtilitiesProductRequestModel();
				model.populateFromRequest(request);

				UtilitiesProductService service = new UtilitiesProductService();

				UtilitiesProductModel returnedModel = service.getResults(request, model);

				if (returnedModel == null) {
					throw new Exception("getResults returned null");
				}

				writer.print(returnedModel.toJson());

			}

		}catch (Exception e) {
			logger.error("/utilities/providers/get.json failed: ", e);

			JSONObject json = null;
			Error error = new Error();
			error.addError(new Error("Failed to get results"));
			json = error.toJsonObject(true);

			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

			writer.print(json.toString());
		}

	}

}
