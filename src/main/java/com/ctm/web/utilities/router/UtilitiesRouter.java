package com.ctm.web.utilities.router;

import com.ctm.web.core.model.Error;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.services.SettingsService;
import com.ctm.web.utilities.model.*;
import com.ctm.web.utilities.services.UtilitiesProductService;
import com.ctm.web.utilities.services.UtilitiesProviderService;
import com.ctm.web.utilities.services.UtilitiesResultsService;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

import static com.ctm.web.core.logging.LoggingArguments.kv;


@WebServlet(urlPatterns = {
		"/utilities/providers/get.json",
		"/utilities/results/get.json",
		"/utilities/moreinfo/get.json",
		"/utilities/application/submit.json"
})
public class UtilitiesRouter extends HttpServlet {
	private static final Logger LOGGER = LoggerFactory.getLogger(UtilitiesRouter.class);
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
			LOGGER.error("Failed to retrieve utilities results {}", kv("requestUri", request.getRequestURI()), e);

			JSONObject json = null;
			Error error = new Error();
			error.addError(new Error("Failed to get results"));
			json = error.toJsonObject(true);

			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

			writer.print(json.toString());
		}

	}

}
