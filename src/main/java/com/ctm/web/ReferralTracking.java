package com.ctm.web;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.services.ContentService;
import com.disc_au.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

import static com.ctm.logging.LoggingArguments.kv;

public class ReferralTracking {

	private static final Logger LOGGER = LoggerFactory.getLogger(ReferralTracking.class);

	public String getAndSetUtmSource(HttpServletRequest request, Data data, String prefix) {
		return getAndSetFromParam(request, data, "utm_source", prefix + "/sourceid");
	}
	public String getAndSetUtmMedium(HttpServletRequest request, Data data, String prefix) {
		return getAndSetFromParam(request, data, "utm_medium", prefix + "/medium");
	}
	public String getAndSetUtmCampaign(HttpServletRequest request, Data data, String prefix) {
		return getAndSetFromParam(request, data, "utm_campaign", prefix + "/cid");
	}
	public String getRefererUrl(HttpServletRequest request) {
		return request.getHeader("Referer");
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
					LOGGER.warn("Value is not in utf-8. {}", kv("value", value),e);
				}
				try {
					valid = ContentService.getContentIsValid(request, key, value);
					if (valid) {
						data.put(xpath, value);
					}
				} catch (DaoException | ConfigSettingException e) {
					LOGGER.warn("Failed to validate content. {},{}", kv("key", key), kv("value", value),e);
				}

				if(valid ){
					LOGGER.info("Content is valid. {},{}", kv("key", key), kv("value", value));
				} else {
					LOGGER.warn("Content is invalid param - Aborting. {},{}", kv("key", key), kv("value", value));
					value = "";
				}
			}
		}
		return value;
	}

}
