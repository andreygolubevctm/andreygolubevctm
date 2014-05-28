package com.ctm.services;

import java.util.Date;

import javax.servlet.jsp.PageContext;

import com.ctm.model.content.Content;
import com.ctm.dao.ContentDao;
import com.ctm.exceptions.DaoException;

public class ContentService {


	/**
	 * Returns the value of the content key (as a string) this is the one that should be called by the JSP page.
	 *
	 * @param pageContext
	 * @param contentCode
	 * @return
	 * @throws DaoException
	 */
	public static String getContentValue(PageContext pageContext, String contentCode) throws DaoException {

		Content content = getContent(pageContext, contentCode);

		if(content != null){
			return content.getContentValue();
		}

		return "";
	}

	/**
	 * Returns the Content model if you need to work with the entire model and not just get hold of the value.
	 * Uses the pageContext to automatically detect current brand id.
	 *
	 * @param pageContext
	 * @param contentCode
	 * @return
	 * @throws DaoException
	 */
	public static Content getContent(PageContext pageContext, String contentCode) throws DaoException{

		int brandId = ApplicationService.getBrandFromPageContext(pageContext).getId();
		Date serverDate = ApplicationService.getServerDate();
		return getContent(contentCode, brandId, serverDate, false);

	}

	/**
	 * Low level get content method, provide all parameters manually.
	 *
	 * @param contentKey
	 * @param brandId
	 * @param effectiveDate
	 * @param includeSupplementary
	 * @return
	 * @throws DaoException
	 */
	public static Content getContent(String contentKey, int brandId, Date effectiveDate, boolean includeSupplementary ) throws DaoException {

		ContentDao contentDao = new ContentDao();
		Content content = contentDao.getByKey(contentKey, brandId, effectiveDate, includeSupplementary);

		return content;

	}
}
