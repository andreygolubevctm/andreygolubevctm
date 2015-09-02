package com.ctm.services;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.ctm.cache.ApplicationCacheManager;
import com.ctm.cache.ContentControlCache;
import com.ctm.dao.ContentDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.content.Content;
import com.ctm.model.settings.PageSettings;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

public class ContentService {

    private static Logger logger = Logger.getLogger(ContentService.class.getName());
	private static ContentService contentService = new ContentService();


    /**
     * Returns the value of the content key (as a string) this is the one that should be called by the JSP page.
     *
     * @param request
     * @param contentKey
     * @return
     * @throws DaoException
     * @throws ConfigSettingException
     */
	public static String getContentValue(HttpServletRequest request, String contentKey) throws DaoException, ConfigSettingException {

		Content content = getContent(request, contentKey);

		if(content != null){
			return content.getContentValue();
		}

		return "";
	}

	/**
	 * Checks a value against a comma separated list in the database `ctm`.`content_control`
	 *
	 * @param request used for get brand and vertical to match in the database
	 * @param contentKey key that will match contentKey column in database must be comma separated list of valid values
	 * @param value value to check against list
	 * @return
	 * @throws DaoException
	 * @throws ConfigSettingException brand or vertical isn't valid in request
	 */
	public static boolean getContentIsValid(HttpServletRequest request, String contentKey, String value) throws DaoException, ConfigSettingException {
		String content = getContentValue(request, contentKey) ;
		List<String> validSources = Arrays.asList(StringUtils.split(content.toUpperCase(), ","));
		return validSources.contains(value.toUpperCase());
	}

	/**
	 * Returns the Content model if you need to work with the entire model and not just get hold of the value.
	 * Uses the pageContext to automatically detect current brand id.
	 * @param request used for get brand and vertical to match in the database
     * @param contentKey key that will match contentKey column in database must be comma separated list of valid values
	 * @return
	 * @throws DaoException
	 * @throws ConfigSettingException
	 */
	public static Content getContent(HttpServletRequest request, String contentKey) throws DaoException, ConfigSettingException{

		return getContentWithOptions(request, contentKey, false);

	}

	/**
	 * Returns the Content model with the supplementary data
     * @param request used for get brand and vertical to match in the database
     * @param contentKey key that will match contentKey column in database must be comma separated list of valid values
	 * @return
	 * @throws DaoException
	 * @throws ConfigSettingException
	 */
	public static Content getContentWithSupplementary(HttpServletRequest request, String contentKey) throws DaoException, ConfigSettingException{

		return getContentWithOptions(request, contentKey, true);

	}

	/**
	 * Private method to get content model with or with out supplementary data
     * @param request used for get brand and vertical to match in the database
     * @param contentKey key that will match contentKey column in database must be comma separated list of valid values
	 * @return
	 * @throws DaoException
	 * @throws ConfigSettingException
	 */
	private static Content getContentWithOptions(HttpServletRequest request, String contentKey, boolean includeSupplementary) throws DaoException, ConfigSettingException{
		PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
		int brandId = pageSettings.getBrandId();
		int verticalId = pageSettings.getVertical().getId();
		Date serverDate = ApplicationService.getApplicationDate(request);
		return getInstance().getContent(contentKey, brandId, verticalId, serverDate, includeSupplementary);

	}

	public static ContentService getInstance() throws DaoException, ConfigSettingException{
		return contentService;
	}

	/**
	 * Low level get content method, provide all parameters manually.
	 *
	 * @param contentKey
	 * @param brandId
     * @param verticalId
	 * @param effectiveDate
	 * @param includeSupplementary
	 * @return
	 * @throws DaoException
	 */
	public Content getContent(String contentKey, int brandId, int verticalId, Date effectiveDate, boolean includeSupplementary ) throws DaoException {

        // Create a 'key' for the cache - this is based on the values used to call the DAO (excluding date)
        String cacheKey = contentKey+"_"+brandId+"_"+verticalId+"_"+includeSupplementary;
        Content content = null;

        ContentControlCache contentControlCache = ApplicationCacheManager.getContentControlCache();

        if(contentControlCache.isKeyInCache(cacheKey)) {
            content = (Content) contentControlCache.get(cacheKey);
        }else{
            ContentDao contentDao = new ContentDao();
            content = contentDao.getByKey(contentKey, brandId, verticalId, effectiveDate, includeSupplementary);
            contentControlCache.put(cacheKey, content);
        }


		return content;

	}


	/**
	 * Return a list of content items with the same key mapped to a provider id.
	 *
     * @param request
	 * @param contentCode
	 * @param providerId
	 * @return
	 * @throws DaoException
	 */
	public static ArrayList<Content> getMultipleContentValuesForProvider(HttpServletRequest request, String contentCode, int providerId) throws DaoException{
		int brandId = ApplicationService.getBrandFromRequest(request).getId();
		Date serverDate = ApplicationService.getApplicationDate(request);
		return getMultipleContentValuesForProvider(contentCode, providerId, brandId, serverDate, true);
	}

	/**
	 * Low level get content method for a list of content items with the same key mapped to a provider.
	 * This method supports duplicate keys and returns a list of matching items.
	 *
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
