package com.ctm.services;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.dao.EmailMasterDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.exceptions.VerticalException;
import com.ctm.model.EmailDetails;
import com.ctm.model.Unsubscribe;
import com.ctm.model.settings.PageSettings;

public class UnsubscribeService {

	private EmailMasterDao hashedEmailDao;

	public UnsubscribeService() {
		hashedEmailDao = new EmailMasterDao();
	}

	private static Logger logger = Logger.getLogger(UnsubscribeService.class.getName());

	/**
	 * Sets the vertical code for the page request scope and loads the settings object.
	 * This method also checks to see if the vertical is enabled for the brand. (and by extension that the brand code is set)
	 * Call this on vertical start pages like health_quote.jsp
	 *
	 * @param pageContext
	 * @param verticalCode
	 * @return mapping including boolean is the details are valid
	 */
	public Unsubscribe getUnsubscribeDetails(String vertical,
			String hashedEmail, boolean isDisc, PageSettings pageSettings, HttpServletRequest request) {
		Unsubscribe unsubscribe = new Unsubscribe();
		unsubscribe.setVertical(vertical);
		if (!isDisc) {
			try {
				unsubscribe.setEmailDetails(hashedEmailDao.decrypt(hashedEmail, pageSettings.getBrandId()));
			} catch (DaoException e) {
				FatalErrorService.logFatalError(e, pageSettings.getBrandId(), request.getRequestURI(), request.getSession().getId(), true);
			}
		}
		return unsubscribe;
	}


	public static String getUnsubscribeUrl(PageSettings pageSettings, EmailDetails emailDetails) {
		try {
			return pageSettings.getBaseUrl() + "unsubscribe.jsp?unsubscribe_email=" + emailDetails.getHashedEmail() + "&vertical=" + pageSettings.getVertical().getType().getCode();
		} catch (EnvironmentException | VerticalException | ConfigSettingException e) {
			logger.error("Failed to get unsubsribe url" , e);
		}
		return null;
	}

}
