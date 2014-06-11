package com.ctm.services;

import java.util.ArrayList;
import java.util.Date;

import javax.servlet.jsp.PageContext;

import com.ctm.model.content.Content;
import com.ctm.model.settings.PageSettings;
import com.ctm.dao.ContentDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;

public class ContentService {


	/**
	 * Returns the value of the content key (as a string) this is the one that should be called by the JSP page.
	 *
	 * @param pageContext
	 * @param contentCode
	 * @return
	 * @throws DaoException
	 * @throws ConfigSettingException
	 */
	public static String getContentValue(PageContext pageContext, String contentCode) throws DaoException, ConfigSettingException {

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
	 * @throws ConfigSettingException
	 */
	public static Content getContent(PageContext pageContext, String contentCode) throws DaoException, ConfigSettingException{

		PageSettings pageSettings = SettingsService.getPageSettingsForPage(pageContext);
		int brandId = pageSettings.getBrandId();
		int verticalId = pageSettings.getVertical().getId();
		Date serverDate = ApplicationService.getServerDate();
		return getContent(contentCode, brandId, verticalId, serverDate, false);

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
	public static Content getContent(String contentKey, int brandId, int verticalId, Date effectiveDate, boolean includeSupplementary ) throws DaoException {

		ContentDao contentDao = new ContentDao();
		Content content = contentDao.getByKey(contentKey, brandId, verticalId, effectiveDate, includeSupplementary);

		return content;

	}


	/**
	 * Return a list of content items with the same key mapped to a provider id.
	 *
	 * @param pageContext
	 * @param contentCode
	 * @param providerId
	 * @return
	 * @throws DaoException
	 */
	public static ArrayList<Content> getMultipleContentValuesForProvider(PageContext pageContext, String contentCode, int providerId) throws DaoException{
		int brandId = ApplicationService.getBrandFromPageContext(pageContext).getId();
		Date serverDate = ApplicationService.getServerDate();
		return getMultipleContentValuesForProvider(contentCode, providerId, brandId, serverDate, true);
	}

	/**
	 * Low level get content method for a list of content items with the same key mapped to a provider.
	 * This method supports duplicate keys and returns a list of matching items.
	 *
	 * @param pageContext
	 * @param contentCode
	 * @param providerId
	 * @param brandId
	 * @param effectiveDate
	 * @param includeSupplementary
	 * @return
	 * @throws DaoException
	 */
	public static ArrayList<Content> getMultipleContentValuesForProvider(String contentCode, int providerId, int brandId, Date effectiveDate, boolean includeSupplementary) throws DaoException{

		ContentDao contentDao = new ContentDao();
		ArrayList<Content> contents = contentDao.getMultipleByKeyAndProvider(contentCode, providerId, brandId, effectiveDate, includeSupplementary);

		return contents;

	}
}
