package com.ctm.services;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.dao.EmailMasterDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Unsubscribe;
import com.ctm.model.settings.PageSettings;

public class UnsubscribeService {

	private EmailMasterDao hashedEmailDao;

	public UnsubscribeService() {
		hashedEmailDao = new EmailMasterDao();
	}

	@SuppressWarnings("unused")
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

}
