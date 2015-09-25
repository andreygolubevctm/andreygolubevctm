package com.ctm.services;

import com.ctm.cache.ApplicationCacheManager;
import com.ctm.cache.ContentControlCache;
import com.ctm.dao.ContentDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.content.Content;
import com.ctm.model.settings.PageSettings;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import static com.ctm.logging.LoggingArguments.kv;

public class ContentService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ContentService.class.getName());

	private static ContentService contentService = new ContentService();
	private ContentControlCache contentControlCache;
	private ContentDao contentDao;

	public ContentService(ContentDao contentDao, ContentControlCache contentControlCache) {
		this.contentDao = contentDao;
		this.contentControlCache = contentControlCache;
	}

	public ContentService() {
	}

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
		Date serverDate = ApplicationService.getApplicationDateIfSet(request);

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
	 * @param effectiveDate if null will get from cache is available otherwise will get content from datasource
	 * @param includeSupplementary
	 * @return
	 * @throws DaoException if getting from database and query fails
	 */
	public Content getContent(String contentKey, int brandId, int verticalId, Date effectiveDate, boolean includeSupplementary ) throws DaoException {
        Content content;

        // Only use cache when a specific date is NOT provided
        if(effectiveDate == null){

            // Create a 'key' for the cache - this is based on the values used to call the DAO (excluding date)
            String cacheKey = contentKey + "_" + brandId + "_" + verticalId + "_" + includeSupplementary;

			if(this.contentControlCache == null) {
				this.contentControlCache = ApplicationCacheManager.getContentControlCache();
			}

			content = contentControlCache.get(cacheKey);
			if(content == null) {
				LOGGER.debug("Key does not exist in cache retrieving from data source. {}", kv("cacheKey", cacheKey));
                content = getContentFromDataSource(contentKey, brandId, verticalId, new Date(), includeSupplementary);
                contentControlCache.put(cacheKey, content);
            }

        }else{
            content = getContentFromDataSource(contentKey, brandId, verticalId, effectiveDate, includeSupplementary);
        }

		return content;

	}

    private Content getContentFromDataSource(String contentKey, int brandId, int verticalId, Date effectiveDate, boolean includeSupplementary) throws DaoException{
        if(contentDao == null) {
			contentDao = new ContentDao();
		}
        return contentDao.getByKey(contentKey, brandId, verticalId, effectiveDate, includeSupplementary);
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
