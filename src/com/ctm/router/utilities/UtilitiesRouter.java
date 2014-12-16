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

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.model.utilities.UtilitiesLeadfeedModel;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.SettingsService;
import com.ctm.services.utilities.UtilitiesLeadfeedService;


@WebServlet(urlPatterns = {
		"/utilities/leadfeed/submit.json"
})
public class UtilitiesRouter extends HttpServlet {
	private static Logger logger = Logger.getLogger(UtilitiesRouter.class.getName());
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

		if (uri.endsWith("/utilities/leadfeed/submit.json")) {
			JSONObject json = null;

			try {
				SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.UTILITIES.getCode());

				UtilitiesLeadfeedService service = new UtilitiesLeadfeedService();
				UtilitiesLeadfeedModel model = UtilitiesLeadfeedService.mapParametersToModel(request);
				json = service.submit(request, model);

				if (json == null) {
					throw new DaoException("Create opportunity returned null");
				}
			}
			catch (Exception e) {
				logger.error("Utiltilies leadfeed submit failed", e);

				Error error = new Error();
				error.addError(new Error("Failed to submit leadfeed"));
				json = error.toJsonObject(true);

				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}

			writer.print(json.toString());
		}

	}
}
