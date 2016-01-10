package com.ctm.web.core.services.tracking;

import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.SettingsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.net.*;
import java.util.HashMap;
import java.util.List;
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

	static final String COOKIE_LABEL_PREFIX = "ctmJourneyGateway";

	private static final Logger LOGGER = LoggerFactory.getLogger(JourneyGateway.class.getName());

	private static CookieManager cookieMgr = null;

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
	public static String getJourney(HttpServletRequest request, String splitTestRef) {
		String urlOut = null;
		String journey = null;
		String nameLabel = LABEL_PREFIX + splitTestRef;
		String activeLabel = nameLabel + LABEL_SUFFIX_ACTIVE;
		URL cookieUrl = null;
		try {
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
			String vertical = pageSettings.getVertical().getCode();
			// Stop now if no split test active
			if (pageSettings.hasSetting(activeLabel) && pageSettings.getSetting(activeLabel).equals("Y")) {
				// Stop now if override param in request (no need to check cookie)
				if(!isParamInRequest(request, OVERRIDE_PARAM)) {
					cookieUrl = getCookieUrl(request.getRequestURL().toString());
					String cookieJ = getCookieValue(new URL(cookieUrl.toString() + "/" + pageSettings.getSetting("contextFolder") + "data.jsp"), splitTestRef, vertical);
					// Stop now if override param exists as that means we've already determined the journey
					if (cookieJ != null) {
						journey = cookieJ;
						LOGGER.debug("[JourneyGateway] Using cookie value [" + journey + "] for journey");
					} else {
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
					}
				// Override param exists so just store the journey in a cookie
				} else if(isJParamInRequest(request)) {
					cookieUrl = getCookieUrl(request.getRequestURL().toString());
					setCookieValue(cookieUrl,splitTestRef,vertical,Integer.parseInt(getParamFromRequest(request, "j")));
					LOGGER.debug("[JourneyGateway] New Journey - " + urlOut);
				}
			// If there's no split test but a J value has been passed then let's set it to the default
			} else if(isJParamInRequest(request)) {
				journey="1";
				LOGGER.debug("[JourneyGateway] No split test but J value provided so forcing to default journey");
			}

			// Build the new URL if a journey has been found
			if(journey != null) {
				// Build and add J param to URL
				StringBuffer url = getURLWithoutJParam(request);
				url.append("j=" + journey + "&" + OVERRIDE_PARAM + "=1");
				urlOut = url.toString();

				// Store journey value in cookie
				cookieUrl = getCookieUrl(request.getRequestURL().toString());
				setCookieValue(cookieUrl,splitTestRef,vertical,Integer.parseInt(journey));
				LOGGER.debug("[JourneyGateway] New Journey - " + urlOut);
			}
		} catch(Exception e) {
			LOGGER.debug("[JourneyGateway] JourneyGateway.getJourney() threw an exception", e);
		}

		return urlOut;
	}

	private static StringBuffer getURLWithoutJParam(HttpServletRequest request) {
		StringBuffer url = request.getRequestURL();
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

	private static Boolean isParamInRequest(HttpServletRequest request, String param) {
		return getParamFromRequest(request, param) != null;
	}

	private static Boolean isJParamInRequest(HttpServletRequest request) {
		return isParamInRequest(request, "j");
	}

	private static String getParamFromRequest(HttpServletRequest request, String param) {
		Map<String, String> qstr = getQueryMap(request.getQueryString());
		for (Map.Entry<String, String> entry : qstr.entrySet()) {
			if(entry.getKey().equalsIgnoreCase(param)) {
				return entry.getValue();
			}
		}
		return null;
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

	/**
	 * getCookieUrl returns the URL used for storing the cookie
	 * @param urlIn
	 * @return
	 * @throws Exception
	 */
	public static URL getCookieUrl(String urlIn) throws Exception {
		URL url = new URL(urlIn);
		StringBuilder urlOut = new StringBuilder();
		urlOut.append(url.getProtocol() + "://" + url.getHost());
		if(url.getPort() >= 0) {
			urlOut.append(":" + url.getPort());
		}
		return new URL(urlOut.toString());
	}

	/**
	 * getCookieValue returns the current journey cookie value for a split test
	 * @param url
	 * @param vertical
	 * @return
	 */
	private static String getCookieValue(URL url, String splitTestRef, String vertical) {
		String journey = null;
		try {
			url = new URL(url.toString());
			URLConnection connection = url.openConnection();
			connection.getContent();
			CookieStore cookieJar = getCookieManager().getCookieStore();

			List<HttpCookie> cookies = cookieJar.getCookies();
			for (HttpCookie cookie : cookies) {
				if (cookie.getName().equalsIgnoreCase(COOKIE_LABEL_PREFIX + splitTestRef + vertical)) {
					journey = cookie.getValue();
					LOGGER.debug("[JourneyGateway] Found Cookie [" + cookie.getName() + "] with value [" + cookie.getValue() + "]");
				}
			}
		} catch(Exception e) {
			LOGGER.error("[JourneyGateway] Exception getting cookie value", e);
		}
		return journey;
	}

	/**
	 * setCookieValue sets cookie value to store the journey value
	 * @param url
	 * @param splitTestRef
	 * @param vertical
	 * @param journey
	 */
	private static void setCookieValue(URL url, String splitTestRef, String vertical, int journey) {
		try {
			CookieStore cookieJar =  getCookieManager().getCookieStore();
			HttpCookie cookie = new HttpCookie(COOKIE_LABEL_PREFIX + splitTestRef + vertical, Integer.toString(journey));
			cookieJar.add(url.toURI(), cookie);
			LOGGER.debug("[JourneyGateway] Set cookie [" + cookie.getName() + "] value [" + cookie.getValue() + "]");
		} catch(Exception e) {
			LOGGER.error("[JourneyGateway] Exception setting cookie value", e);
		}
	}

	/**
	 * getCookieManager return a CookieManager object
	 * @return
	 */
	private static CookieManager getCookieManager() {
		try {
			if (cookieMgr == null) {
				cookieMgr = new CookieManager();
				cookieMgr.setCookiePolicy(CookiePolicy.ACCEPT_ORIGINAL_SERVER);
				CookieHandler.setDefault(cookieMgr);
			}
		} catch(Exception e) {
			LOGGER.error("[JourneyGateway] Exception getting the cookie manager", e);
		}
		return cookieMgr;
	}
}