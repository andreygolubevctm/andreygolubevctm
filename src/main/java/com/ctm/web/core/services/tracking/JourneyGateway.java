package com.ctm.web.core.services.tracking;

import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.SettingsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * JourneyGateway - this class provides a method to determine the correct URL
 * the page should be redirected to if a valid split test is active. The
 * definition of the split test is stored in the ctm.configuration table.
 *
 * The configuration values are:
 * 1] splitTest_xxxx_active - which flags whether the split test is on/off
 * 2] splitTest_xxxx_count - the number of variances in the test
 * 3] splitTest_xxxx_y_jVal - the j value for the specific test variance
 * 4] splitTest_xxxx_y_range - the value used to determine the j value to use
 *
 * Where "xxxx" is an identified/label for the split test (in case multiples
 * need to exist).
 *
 * Where "y" is the index (start from 1) position of the split test
 */
public class JourneyGateway {

	static final String OVERRIDE_PARAM = "jg"; // URL param to flag already processed
	static final String LABEL_PREFIX = "splitTest_";
	static final String LABEL_SUFFIX_ACTIVE = "_active";
	static final String LABEL_SUFFIX_COUNT = "_count";
	static final String LABEL_SUFFIX_RANGE = "_range";
	static final String LABEL_SUFFIX_JVAL = "_jVal";

	private static final Logger LOGGER = LoggerFactory.getLogger(JourneyGateway.class.getName());

	public JourneyGateway(){}

	/**
	 * getJourney returns the URL the page should be redirected to if applicable (otherwise null).
	 *
	 * If a split test has been defined in the verticals configuration then determine
	 * the correct j value to be included in the URL and append/replace the value and
	 * return the new URL.
	 *
	 * @param request
	 * @param label
	 * @return
	 * @throws Exception
	 */
	public static String getJourney(HttpServletRequest request, String label) {
		String urlOut = null;
		String journey = null;
		String nameLabel = LABEL_PREFIX + label;
		String activeLabel = nameLabel + LABEL_SUFFIX_ACTIVE;
		try {
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
			// Stop now if no split test active
			if (pageSettings.hasSetting(activeLabel) && pageSettings.getSetting(activeLabel).equals("Y")) {
				// Stop now if override param exists as that means we've already determined the journey
				if(!request.getQueryString().toString().contains("&" + OVERRIDE_PARAM + "=")) {
					String countLabel = nameLabel + LABEL_SUFFIX_COUNT;
					// Generate random number between 1 & 100 to test winning journey
					int flag = ((int) (Math.random() * 100)) + 1;
					int count = Integer.parseInt(pageSettings.getSetting(countLabel));
					journey = "1";
					// Iterate journey variations and stop when we have a winner
					for (int i = 1; i <= count; i++) {
						String percentLabel = nameLabel + "_" + i + LABEL_SUFFIX_RANGE;
						String valueLabel = nameLabel + "_" + i + LABEL_SUFFIX_JVAL;
						int testLimit = Integer.parseInt(pageSettings.getSetting(percentLabel));
						if (flag <= testLimit) {
							journey = pageSettings.getSetting(valueLabel);
							break;
						}
					}
				} else {
					LOGGER.debug("Journey has already been processed and defined");
				}
			}
		} catch(Exception e) {
			LOGGER.debug("JourneyGateway.getJourney() threw an exception", e);
		}

		// Build the new URL if a journey has been found
		if(journey != null) {
			StringBuffer url = request.getRequestURL();
			url.append("?");
			Map<String, String> qstr = getQueryMap(request.getQueryString());
			for (Map.Entry<String, String> entry : qstr.entrySet()) {
				// Add all query string entries back to the URL except for J
				if(!entry.getKey().equalsIgnoreCase("j")) {
					url.append(entry.getKey() + "=" + entry.getValue() + "&");
				}
			}
			// Add J and the override param to prevent doing this again after redirect
			url.append("j=" + journey + "&" + OVERRIDE_PARAM + "=1");
			urlOut = url.toString();
			LOGGER.debug("New Journey - " + urlOut);
		}

		return urlOut;
	}

	/**
	 * getQueryMap converts a querystring to a collection
	 * @param query
	 * @return
	 */
	public static Map<String, String> getQueryMap(String query)	{
		String[] params = query.split("&");
		Map<String, String> map = new HashMap<String, String>();
		for (String param : params)	{
			String name = param.split("=")[0];
			String value = param.split("=")[1];
			map.put(name, value);
		}
		return map;
	}
}