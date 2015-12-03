package com.ctm.web.core.router;

import com.ctm.web.core.model.Address;
import com.ctm.web.core.dao.AddressDao;
import com.ctm.web.core.elasticsearch.services.AddressSearchService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.services.SettingsService;
import org.json.JSONArray;
import org.json.JSONException;
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

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@WebServlet(urlPatterns = {
		"/address/search.json",
		"/address/get.json"
})
public class AddressSearchRouter extends HttpServlet {
	private static final Logger LOGGER = LoggerFactory.getLogger(AddressSearchRouter.class);
	private static final long serialVersionUID = 71L;

	private AddressSearchService searchService;

	@Override
	public void init() throws ServletException {
		searchService = new AddressSearchService();
	}

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
		 * Set content-type header based on uri extension.
		 */
		String uri = request.getRequestURI();
		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		// Extra security to reduce chances someone can hotlink our end point.
		response.setHeader("Access-Control-Allow-Origin", "*");

		if (uri.endsWith("/address/search.json")) {
			JSONArray output = null;

			try {
				PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.GENERIC.getCode());
				String indexName = pageSettings.getSetting("elasticSearchAddressIndex");
				output = searchService.suggest(request.getParameter("query"), indexName, "address");
			} catch (JSONException | ConfigSettingException | DaoException e) {
				LOGGER.error("Address search failed {}", kv("query", request.getParameter("query")), e);
			}

			if(output != null)
				writer.print(output.toString());
		} else if (uri.endsWith("/address/get.json")) {
			JSONObject json = new JSONObject();

			if(request.getParameter("dpId") != null && !request.getParameter("dpId").isEmpty()) {
				AddressDao addressDao = new AddressDao();
				String dpId = request.getParameter("dpId");

				try {
					Address address = addressDao.getAddressDetails(dpId);
					json = address.toJSONObject();
				} catch (DaoException e) {
					LOGGER.error("Address details failed {}", kv("dpId", dpId), e);
				}
			}

			writer.print(json.toString());
		}

	}
}
