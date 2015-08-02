package com.ctm.web;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.services.ContentService;
import com.disc_au.web.go.Data;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

public class ReferralTracking {

	private static final Logger logger = Logger.getLogger(ReferralTracking.class.getName());

	public String getAndSetUtmSource(HttpServletRequest request, Data data, String prefix) {
		return getAndSetFromParam(request, data, "utm_source", prefix + "/sourceid");
	}
	public String getAndSetUtmMedium(HttpServletRequest request, Data data, String prefix) {
		return getAndSetFromParam(request, data, "utm_medium", prefix + "/medium");
	}
	public String getAndSetUtmCampaign(HttpServletRequest request, Data data, String prefix) {
		return getAndSetFromParam(request, data, "utm_campaign", prefix + "/cid");
	}

	private String getAndSetFromParam(HttpServletRequest request, Data data, String key, String xpath) {
		String value = data.getString(xpath);
		if(value == null || value.isEmpty()) {
			value = request.getParameter(key);
			boolean valid = false;
			if (value != null && !value.isEmpty()) {
				try {
					value = URLDecoder.decode(value, "UTF-8");
				} catch (UnsupportedEncodingException e) {
					logger.warn(e);
				}
				try {
					valid = ContentService.getContentIsValid(request, key, value);
					if (valid) {
						data.put(xpath, value);
					}
				} catch (DaoException | ConfigSettingException e) {
					logger.warn(e);
				}

				if(valid ){
					logger.info(key + ": '" + value + "' from " + "param");
				} else {
					logger.warn(key + ": '" + value + "' from " + "invalid param - Aborting");
					value = "";
				}
			}
		}
		return value;
	}

}
