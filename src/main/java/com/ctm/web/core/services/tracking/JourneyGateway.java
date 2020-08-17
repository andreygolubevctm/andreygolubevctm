package com.ctm.web.core.services.tracking;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.ServiceException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.SettingsService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

import static java.util.Collections.emptyList;

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

	public static final String J_PARAMETER = "j";
	public static final String LABEL_PREFIX = "splitTest_";
	public static final String LABEL_SUFFIX_ACTIVE = "_active";
	public static final String LABEL_SUFFIX_COUNT = "_count";
	public static final String LABEL_SUFFIX_RANGE = "_range";
	public static final String LABEL_SUFFIX_JVAL = "_jVal";

	static final String COOKIE_LABEL_PREFIX = "ctmJourneyGateway";

	private static final Logger LOGGER = LoggerFactory.getLogger(JourneyGateway.class.getName());
	public static final String DEFAULT_JOURNEY = "1";

	public JourneyGateway(){}

	/**
	 * getJourney returns the URL the page should be redirected to if applicable (otherwise null).
	 *
	 * If a split test has been defined in the verticals configuration then determine
	 * the correct j value to be included in the URL and append/replace the value and
	 * return the new URL.
	 *
	 * @param request
	 * @param splitTestRef
	 * @return
	 * @throws Exception
	 */
	public static String getJourney(HttpServletRequest request, String splitTestRef, HttpServletResponse response) {

		String activeLabel = LABEL_PREFIX + splitTestRef + LABEL_SUFFIX_ACTIVE;
		try {
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
			String vertical = pageSettings.getVertical().getCode();
			// Stop now if no split test active
			final String jValue;
			if (pageSettings.hasSetting(activeLabel) && pageSettings.getSetting(activeLabel).equals("Y")) {
				jValue = getRequestJValue(request)
						.orElseGet(() -> getCookieJValue(request, splitTestRef, vertical)
								.orElseGet(() -> calculateJValue(pageSettings, splitTestRef)));
			} else {
				jValue = getRequestJValue(request).orElse(DEFAULT_JOURNEY);
			}

			final Cookie cookie = new Cookie(COOKIE_LABEL_PREFIX + splitTestRef + vertical, jValue);
			cookie.setMaxAge(30*24*60*60);
			response.addCookie(cookie);

			if (!hasRequestJParameterNotEmpty(request)) {
				StringBuilder url = getURLWithoutJParam(request, pageSettings);
				url.append("j=").append(jValue);
				return url.toString();
			}

		} catch (Exception e) {
			LOGGER.debug("[JourneyGateway] JourneyGateway.getJourney() threw an exception", e);
		}

		return null;
	}

	public static String calculateJValue(PageSettings pageSettings, String splitTestRef) {
		try {
			String nameLabel = LABEL_PREFIX + splitTestRef;
			String countLabel = nameLabel + LABEL_SUFFIX_COUNT;
			// Generate random number between 1 & 100 to test winning journey
			Random r = new Random();
			int flag = r.nextInt(99) + 1;
			int count = Integer.parseInt(pageSettings.getSetting(countLabel));
			// Iterate journey variations and stop when we have a winner
			for (int i = 1; i <= count; i++) {
				String rangeLabel = nameLabel + "_" + i + LABEL_SUFFIX_RANGE;
				String valueLabel = nameLabel + "_" + i + LABEL_SUFFIX_JVAL;
				int testLimit = Integer.parseInt(pageSettings.getSetting(rangeLabel));
				if (flag <= testLimit) {
					return pageSettings.getSetting(valueLabel);
				}
			}
			throw new ConfigSettingException("No J value was found");
		} catch (ConfigSettingException e) {
			throw new ServiceException("Error while calculating J value ", e);
		}
	}

	private static Optional<String> getCookieJValue(HttpServletRequest request, String splitTestRef, String vertical) {
		return Optional.ofNullable(request.getCookies())
					.map(Arrays::asList)
					.orElse(emptyList())
					.stream()
					.filter(c -> c.getName().equals(COOKIE_LABEL_PREFIX + splitTestRef + vertical))
					.map(Cookie::getValue)
					.findFirst();
	}

	private static Optional<String> getRequestJValue(HttpServletRequest request) {
		if (hasRequestJParameter(request)) {
			return Optional.of(StringUtils.defaultIfBlank(request.getParameter(J_PARAMETER), DEFAULT_JOURNEY));
		} else {
			return Optional.empty();
		}
	}

	private static boolean hasRequestJParameter(HttpServletRequest request) {
		return request.getParameterMap().containsKey(J_PARAMETER);
	}

	private static boolean hasRequestJParameterNotEmpty(HttpServletRequest request) {
		return StringUtils.isNotBlank(request.getParameter(J_PARAMETER));
	}

	private static StringBuilder getURLWithoutJParam(HttpServletRequest request, PageSettings pageSettings) throws ConfigSettingException {
		StringBuilder url = new StringBuilder(pageSettings.getBaseUrl()+"health_quote_v4.jsp");
		url.append("?");
		Map<String, String> qstr = getQueryMap(request.getQueryString());
		for (Map.Entry<String, String> entry : qstr.entrySet()) {
			// Add all query string entries back to the URL except for J
			if(!entry.getKey().equalsIgnoreCase("j")) {
				url.append(entry.getKey() + "=" + entry.getValue() + "&");
			}
		}
		return url;
	}

	/**
	 * getQueryMap converts a querystring to a collection
	 * @param query
	 * @return
	 */
	public static Map<String, String> getQueryMap(String query)	{
		Map<String, String> map = new HashMap<>();
		if(query != null && !query.isEmpty()) {
			String[] params = query.split("&");
			for (String param : params) {
				final String[] nameValue = param.split("=");
				String name = nameValue[0];
				String value = nameValue.length > 1 ? nameValue[1] : "";
				map.put(name, value);
			}
		}
		return map;
	}

}
