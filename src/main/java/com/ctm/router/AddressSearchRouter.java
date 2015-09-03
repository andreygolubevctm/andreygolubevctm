package com.ctm.router;

import com.ctm.dao.AddressDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Address;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.SettingsService;
import com.ctm.services.elasticsearch.AddressSearchService;
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

import static com.ctm.logging.LoggingArguments.kv;

@WebServlet(urlPatterns = {
		"/address/search.json",
		"/address/get.json"
})
public class AddressSearchRouter extends HttpServlet {
	private static final Logger logger = LoggerFactory.getLogger(AddressSearchRouter.class.getName());
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
				logger.error("Failed to return address search results {}", kv("query", request.getParameter("query")), e);
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
					logger.error("Failed to return address details {}", kv("dpId", dpId), e);
				}
			}

			writer.print(json.toString());
		}

	}
}
