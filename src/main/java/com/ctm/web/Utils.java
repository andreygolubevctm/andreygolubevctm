package com.ctm.web;

import com.ctm.services.EnvironmentService;

public class Utils {

	/**
	 * Append the SCM build revision (available in NXI onwards) to a URL.
	 * @param url
	 * @return URL with appended parameter in format "rev=1234"
	 */
	public static String addBuildRevisionToUrl(String url) {
		// Check if the URL is in the format xxx.js? or xxx.js (add a ? or a &
		// appropriately)
		String separator = (url.indexOf("?") > -1) ? "&" : "?";
		StringBuffer sb = new StringBuffer(url);

		sb.append(separator).append(buildRevisionAsQuerystringParam());
		return sb.toString();
	}

	/**
	 * Get the SCM build revision as a querystring parameter
	 * @return String in format "rev=1234"
	 */
	public static String buildRevisionAsQuerystringParam() {
		return "rev=" + EnvironmentService.getBuildRevision();
	}

}
