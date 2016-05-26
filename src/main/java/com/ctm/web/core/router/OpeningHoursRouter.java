package com.ctm.web.core.router;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.openinghours.model.OpeningHours;
import com.ctm.web.core.openinghours.services.OpeningHoursService;
import com.ctm.web.core.services.ApplicationService;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@WebServlet(urlPatterns = {
		"/openinghours/all.json",
		"/openinghours/today.json",
		"/openinghours/tomorrow.json"
})

public class OpeningHoursRouter extends HttpServlet {

	private enum RequestType {
		ALL {
			public String toString() {
				return "all";
			}
		},
		TODAY {
			public String toString() {
				return "today";
			}
		},
		TOMORROW {
			public String toString() {
				return "tomorrow";
			}
		}
	}

	private static final Logger LOGGER = LoggerFactory.getLogger(OpeningHoursRouter.class);

	private static final long serialVersionUID = 666L;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();
		JSONObject responseJson = null;
		HashMap<String, Object> responseData = null;
		RequestType requestType = null;

		// Set default responseData
		responseData = new HashMap<>();
		responseData.put("success",Boolean.FALSE);
		responseData.put("content", null);

		// Determine the request type
		if (uri.toLowerCase().contains(RequestType.ALL.toString())) {
			requestType = RequestType.ALL;
		} else if (uri.toLowerCase().contains(RequestType.TODAY.toString())) {
			requestType = RequestType.TODAY;
		} else if (uri.toLowerCase().contains(RequestType.TOMORROW.toString())) {
			requestType = RequestType.TOMORROW;
		}

		if(requestType != null) {
			try {
				// Need to set the vertical in the request before using OpeningHoursService
				ApplicationService.setVerticalCodeOnRequest(request, Vertical.VerticalType.HEALTH.getCode());
				OpeningHoursService openingHoursService = new OpeningHoursService();
				if(requestType.equals(RequestType.ALL)) {
					// Get the raw opening hours data
					List<OpeningHours> contentSrc = openingHoursService.getAllOpeningHoursForDisplay(request, false);
					// Create a object with only a subset of valid data to return
					ArrayList<HashMap<String,String>> content = new ArrayList<HashMap<String,String>>();
					for(OpeningHours obj : contentSrc) {
						HashMap<String,String> item = new HashMap<String,String>();
						item.put("day",obj.description);
						item.put("open",obj.startTime);
						item.put("close",obj.endTime);
						content.add(item);
					}
					if(content != null && !content.isEmpty()) {
						responseData.put("success",Boolean.TRUE);
						responseData.put("content", content);
					}
				} else {
					// get
					String content = openingHoursService.getOpeningHoursForDisplay(request, requestType.toString());
					if(content != null && !content.isEmpty()) {
						responseData.put("success",Boolean.TRUE);
						responseData.put("content", content);
					}
				}
			// On failure, write to log and update content with error message
			} catch (DaoException | ConfigSettingException e) {
				LOGGER.error(e.getMessage(), e);
				responseData.put("content", e.getMessage());
			}
		}

		// Create a JSON object with data to return
		responseJson = new JSONObject(responseData);
		if (responseJson != null) {
			response.setContentType("application/json");
			writer.print(responseJson.toString());
		}
	}
}
