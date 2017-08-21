package com.ctm.web.core.web;

import com.ctm.web.core.dao.TouchDao;
import com.ctm.web.core.email.services.EmailServiceHandler;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.services.EnvironmentService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class Utils {

	private static final Logger LOGGER = LoggerFactory.getLogger(Utils.class);
	private static final TouchDao touchDao = new TouchDao();

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

	public static void createBPTouches(Long transactionId, Touch.TouchType touchType, String email, boolean isxml) {

		try {
			if(isxml){
				email = getEmailAddress(email);
			}
			boolean istest = EmailServiceHandler.isTestEmailAddress(email);
			if(istest) return;
			Touch touch = new Touch();
			touch.setType(touchType);
			touch.setTransactionId(transactionId);
			touch.setDatetime(new Date());
			touchDao.record(touch);
		} catch (Exception e) {
			// Failing to write the touch shouldn't be fatal - let's just log an error
			LOGGER.warn("Failed to record {} {}", kv("touch", touchType), kv("transactionId", transactionId));
		}
	}

	public static void createBPTouches(String transactionId, Touch.TouchType touchType, String email, boolean isxml) {
		createBPTouches(Long.parseLong(transactionId),touchType,email,isxml);
	}

	public static String getEmailAddress(String xmlcontent){
		int start = xmlcontent.indexOf("<EmailAddress>".trim());
		int end = xmlcontent.indexOf("</EmailAddress>".trim());
		String email = xmlcontent.substring(start + 14,end);
		return email;
	}

}
