package com.ctm.services.tracking;

import com.ctm.exceptions.SessionException;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.security.StringEncryption;
import com.ctm.services.ContentService;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.disc_au.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.List;

public class TrackingKeyService {

	private static final Logger logger = LoggerFactory.getLogger(TrackingKeyService.class.getName());

	public TrackingKeyService(){}

	/**
	 * Generates a hash based on defined xpath values.
	 *
	 * @param request
	 * @param transactionId
	 * @return key
	 */
	public static String generate(HttpServletRequest request,  long transactionId) throws Exception {
		PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
		VerticalType vertical = pageSettings.getVertical().getType();
		StringBuilder keyBuilder = new StringBuilder();
		String key = null;
		String strXpaths = ContentService.getContentValue(request, "trackingKeyXpaths");

		if(!strXpaths.isEmpty()) {
			try {
				final SessionDataService sessionDataService = new SessionDataService();
				final Data data = sessionDataService.getDataForTransactionId(request, String.valueOf(transactionId), false);

				List<String> trackingKeyXpaths = Arrays.asList(strXpaths.split("\\s*,\\s*"));;
				String xpathRoot = null;

				switch (vertical) {
					case CAR:
						xpathRoot = "quote";
						break;
					default:
						xpathRoot = vertical.toString().toLowerCase();
						break;
				}

				for (String xpath : trackingKeyXpaths) {
					keyBuilder.append(data.get(xpath));
				}

				if(keyBuilder.length() > 0) {
					key = StringEncryption.hash(keyBuilder.toString().replaceAll("\\P{Alnum}", ""));
					data.put(xpathRoot + "/trackingKey", key);
				}

			} catch (SessionException e) {
				throw new Exception(e.getMessage());
			}
		} else {
			throw new Exception("No TrackingKeyXpaths defined to create tracking key.");
		}

		logger.info("trackingKey={}",key);
		return key;
	}
}