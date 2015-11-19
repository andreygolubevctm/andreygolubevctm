/**
 * Source: https://github.com/HaraldWalker/user-agent-utils
 */
package com.ctm.web.core.services;

import com.ctm.web.core.content.services.ContentService;
import eu.bitwalker.useragentutils.Browser;
import eu.bitwalker.useragentutils.OperatingSystem;
import eu.bitwalker.useragentutils.UserAgent;
import eu.bitwalker.useragentutils.Version;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;


public class UserAgentSniffer {


	/**
	 * Retrieve the browser's top level name e.g. CHROME, OPERA, IE, SAFARI,
	 * @param userAgent
	 * @return
	 */
	public static String getBrowserName(String userAgent) {
		Browser ua = Browser.parseUserAgentString(userAgent);
		String browserName = "";
		if(ua != null) {
			browserName = ua.getGroup().toString();
		}

		return browserName;
	}
	/**
	 * Retrieve the browser version
	 * @param userAgent
	 * @return
	 */
	public static Integer getBrowserVersion(String userAgent) {
		UserAgent ua = UserAgent.parseUserAgentString(userAgent);
		int majVersion = 0;
		if(ua != null ) {
			Version browserVersion = ua.getBrowserVersion();
			if(browserVersion != null) {
				majVersion = Integer.parseInt(browserVersion.getMajorVersion());
			}
		}

		return majVersion;
	}
	/**
	 * Retrieves the operating system e.g. WINDOWS, MAC, IOS
	 * @param userAgent
	 * @return
	 */
	public static String getOperatingSystem(String userAgent) {
		OperatingSystem ua = OperatingSystem.parseUserAgentString(userAgent);
		String group = ua.getGroup().toString();

		return group;
	}
	/**
	 * Retrieves the device type, COMPUTER, MOBILE, TABLET, etc.
	 * @param userAgent
	 * @return
	 */
	public static String getDeviceType(String userAgent) {
		OperatingSystem ua = OperatingSystem.parseUserAgentString(userAgent);
		String deviceType = "";
		if(ua != null) {
			deviceType = ua.getDeviceType().toString();
		}

		return deviceType;
	}
	/**
	 * Determine if the user agent is supported from > browser version
	 * contentValue should take the format: {"FIREFOX": 33,"SAFARI": 8,"IE": 11,"CHROME": 37}
	 * @param request
	 * @param contentKey e.g. minimumSupportedBrowsers, userTrackingBrowserRules
	 * @return
	 */
	public static Boolean isSupportedBrowser(HttpServletRequest request, String contentKey) {
		String contentValue = "";
		try {
			contentValue = ContentService.getContentValue(request, contentKey);
		} catch (Exception e1) {
		}

		if(contentValue == "")
			return true;

		try {
			String userAgent = request.getHeader("user-agent");
			JSONObject json = new JSONObject(contentValue);
			String browserName = UserAgentSniffer.getBrowserName(userAgent);
			if(json.has(browserName)) {
				int browserVersion = UserAgentSniffer.getBrowserVersion(userAgent);
				if(browserVersion < json.getInt(browserName)) {
					return false;
				}
			}
		} catch (Exception e) {
		}

		return true;
	}

	/**
	 * Determine if the device, COMPUTER, MOBILE, TABLET is supported
	 * contentValue should take the format: {"COMPUTER": true,"TABLET": false,"MOBILE": false}
	 * @param request
	 * @return
	 */
	public static Boolean isSupportedDevice(HttpServletRequest request, String contentKey) {
		String contentValue = "";
		try {
			contentValue = ContentService.getContentValue(request, contentKey);
		} catch (Exception e1) {
		}

		if(contentValue == "")
			return true;

		try {
			String userAgent = request.getHeader("user-agent");
			JSONObject json = new JSONObject(contentValue);
			String deviceType = UserAgentSniffer.getDeviceType(userAgent);
			if(json.has(deviceType) && json.getBoolean(deviceType) == true) {
				return true;
			}
		} catch (Exception e) {
		}

		return true;
	}

}