package com.ctm.services;

import javax.servlet.jsp.PageContext;

import org.apache.log4j.Logger;

import com.ctm.dao.EmailMasterDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Unsubscribe;
import com.ctm.model.settings.PageSettings;

public class UnsubscribeService {

	private EmailMasterDao hashedEmailDAO;

	public UnsubscribeService() {
		hashedEmailDAO = new EmailMasterDao();
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
			String hashedEmail, boolean isDisc, PageSettings pageSettings, PageContext pageContext) {
		Unsubscribe unsubscribe = new Unsubscribe();
		unsubscribe.setVertical(vertical);
		if (!isDisc) {
			try {
				unsubscribe.setEmailDetails(hashedEmailDAO.decrypt(hashedEmail, pageSettings.getBrandId()));
			} catch (DaoException e) {
				FatalErrorService.logFatalError(e, pageSettings.getBrandId(), pageContext.getRequest().getRemoteAddr(), pageContext.getSession().getId(), true);
			}
		}
		return unsubscribe;
	}

}
