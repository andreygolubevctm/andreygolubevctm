package com.ctm.services.tracking;

import org.slf4j.Logger; import org.slf4j.LoggerFactory;
import javax.servlet.http.HttpServletRequest;
import com.ctm.services.SettingsService;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.SessionDataService;
import com.ctm.exceptions.SessionException;
import com.disc_au.web.go.Data;

public class SplitTestService {

	private static final Logger logger = LoggerFactory.getLogger(SplitTestService.class.getName());

	static final String FIELD_LABEL = "currentJourney";

	public SplitTestService(){}

	/**
	 * getJourney returns the current applicable split tests (as a string) and adds the
	 * test to the current session.
	 *
	 * @param request
	 * @param transactionId
	 * @return
	 * @throws Exception
	 */
	public static String getJourney(HttpServletRequest request, long transactionId) throws Exception {

		PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
		VerticalType vertical = pageSettings.getVertical().getType();
		String splitTests = null;
		String tempSplitTests = request.getParameter("j");
		if (tempSplitTests != null) {
			splitTests = tempSplitTests.trim();
		}

		try {

			final SessionDataService sessionDataService = new SessionDataService();
			final Data data = sessionDataService.getDataForTransactionId(request, String.valueOf(transactionId), false);
			String xpathRoot = null;

			switch (vertical) {
				case CAR:
					xpathRoot = "quote";
					break;
				default:
					xpathRoot = vertical.toString().toLowerCase();
					break;
			}

			data.put(xpathRoot + "/" + FIELD_LABEL, splitTests == null ? "" : splitTests);

		} catch (SessionException e) {
			throw new Exception(e.getMessage());
		}

		return splitTests;
	}

	/**
	 * isActive enables jsp side checking of the active split test. The journey is
	 * tested against the split tests stored in the session.
	 *
	 * @param request
	 * @param transactionId
	 * @param journey
	 * @return
	 * @throws Exception
	 */
	public static Boolean isActive(HttpServletRequest request, long transactionId, int journey) throws Exception {

		Boolean isActive = false;

		PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
		VerticalType vertical = pageSettings.getVertical().getType();

		try {

			final SessionDataService sessionDataService = new SessionDataService();
			final Data data = sessionDataService.getDataForTransactionId(request, String.valueOf(transactionId), false);

			String xpathRoot = null;

			switch (vertical) {
				case CAR:
					xpathRoot = "quote";
					break;
				default:
					xpathRoot = vertical.toString().toLowerCase();
					break;
			}

			if(xpathRoot != null) {

				String splitTests = data.getString(xpathRoot + "/" + FIELD_LABEL);

				// If not in session then trigger creation
			if(splitTests == null || splitTests.equals("")) {
					splitTests = getJourney(request, transactionId);
				}

				if(splitTests != null && splitTests.equals("") == false) {
					String[] tests = splitTests.split("-");
					for(String test : tests) {
						if(Integer.toString(journey).equals(test)) {
							isActive = true;
						}
					}
				}
			}
		} catch (SessionException e) {
			throw new Exception(e.getMessage());
		}

		return isActive;
	}
}