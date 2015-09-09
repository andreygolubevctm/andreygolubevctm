package com.ctm.services;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.ctm.cache.ApplicationCacheManager;

import com.ctm.dao.BrandsDao;
import com.ctm.dao.ConfigSettingsDao;
import com.ctm.dao.VerticalsDao;
import com.ctm.exceptions.BrandException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.Vertical;
import com.ctm.services.elasticsearch.AddressSearchService;
import com.disc_au.web.go.Data;

public class ApplicationService {

	private static final Logger logger = LoggerFactory.getLogger(ApplicationService.class.getName());

	private static ArrayList<Brand> brands = new ArrayList<Brand>(); // Note: always use the getBrands() method so the data is loaded from the DB
	private static final String applicationDateSessionKey = "applicationDate";


	/**
	 * Check if a vertical is enabled for the brand associated with the request.
	 * @throws BrandException if there is no brand code
	 **/
	public static boolean isVerticalEnabledForBrand(HttpServletRequest request, String verticalCode) throws DaoException {

		// Check for the vertical enabled setting for this brand/vertical combination.
		Brand brand = getBrandFromRequest(request);
		if(brand == null){
			throw new BrandException("Unable to find valid brand code");
		}
		Vertical vertical = brand.getVerticalByCode(verticalCode);

		if(vertical == null){
			return false;
		}
		ConfigSetting verticalEnabledSetting = vertical.getSettingForName("status");

		return verticalEnabledSetting != null && verticalEnabledSetting.getValue().equals("Y");
		}

	/**
	 * Returns an array of brands which are enabled for the specified vertical code.
	 * @param verticalCode
	 * @return
	 * @throws DaoException
	 */
	public static ArrayList<Brand> getEnabledBrandsForVertical(String verticalCode) throws DaoException{

		ArrayList<Brand> brands = getBrands();
		ArrayList<Brand> enabledBrands = new ArrayList<Brand>();

		for(Brand brand : brands){
			Vertical vertical = brand.getVerticalByCode(verticalCode);
			if(vertical != null){
				ConfigSetting verticalEnabledSetting = vertical.getSettingForName("status");
				if(verticalEnabledSetting != null && verticalEnabledSetting.getValue().equals("Y") == true){
					enabledBrands.add(brand);
				}
			}
		}

		return enabledBrands;
	}




	/**
	 * Looks at the pageContext for the brand code - this should be a param brandCode=xxx set by the F5 server's rewrite rules.
	 * In Localhost and NXI, we have to depend on the data bucket as we don't have rewrite logic on these environments.
	 *
	 * @param request
	 */
	public static Brand getBrandFromRequest(HttpServletRequest request) throws DaoException {

		getBrands();

		HttpSession session = request.getSession();

		Brand brand = null;

		// Look for brand parameter (query string or form data)
		String brandCode = (String) request.getParameter("brandCode");

		brand = getBrandByCode(brandCode);

		// If localhost or NXI, the URL writing is not in place, therefore we have fall back logic...
		if (brand == null && EnvironmentService.needsManuallyAddedBrandCodeParam()) {

			Data sessionData = (Data) request.getAttribute("data");
			if (sessionData != null) {
				brandCode = (String) sessionData.get("current/brandCode");
			}

			if (brandCode == null || brandCode.equals("")) {
				// Try and use the last used brand code.
				brandCode = (String) session.getAttribute("lastUsedBrandCode");
			}

			if (brandCode == null || brandCode.equals("")) {
				brandCode = "CTM";
			}

			brand = getBrandByCode(brandCode);

		}

		if (EnvironmentService.needsManuallyAddedBrandCodeParam()) {
			session.setAttribute("lastUsedBrandCode", brand.getCode());
		}

		return brand;
	}

	/**
	 * Look up method to find the brand object from the static array.
	 *
	 * @param code
	 * @return
	 */
	public static Brand getBrandByCode(String code){

		for(Brand brand : brands){
			if(brand.getCode().equalsIgnoreCase(code)){
				return brand;
			}
		}

		return null;
	}

	/**
	 * Look up method to find the brand object from the static array.
	 *
	 * @param id
	 * @return
	 */
	public static Brand getBrandById(int id){

		for(Brand brand : brands){
			if(brand.getId() == id){
				return brand;
			}
		}

		return null;
	}

	/**
	 * Returns the brand code from the page context - has fall back logic for test environments.
	 *
	 * @param request
	 * @return Brand code
	 */
	public static String getBrandCodeFromRequest(HttpServletRequest request) throws DaoException {
		Brand brand = getBrandFromRequest(request);
		if (brand == null) return null;
		return brand.getCode();
	}

	/**
	 * Get vertical code from Request attribute.
	 * @param request
	 * @return Vertical code
	 */
	public static String getVerticalCodeFromRequest(ServletRequest request) {
		return (String) request.getAttribute("verticalCode");
	}

	/**
	 * Set vertical code as an attribute on a Request.
	 * @param request
	 * @param verticalCode
	 */
	public static void setVerticalCodeOnRequest(ServletRequest request, String verticalCode) {
		request.setAttribute("verticalCode", verticalCode);
	}

	/**
	 *
	 * @param data
	 * @return
	 */
	public static String getVerticalCodeFromTransactionSessionData(Data data){
		return (String) data.get("current/verticalCode");
	}

	/**
	 *
	 * @param data
	 * @return
	 */
	public static String getBrandCodeFromTransactionSessionData(Data data){
		return (String) data.get("current/brandCode");
	}


	/**
	 * Returns the list of brands with their verticals and vertical settings.
	 * On first run the brands, verticals and settings are loaded from the database.
	 *
	 * @return
	 * @throws DaoException
	 * @throws Exception
	 */
	public static ArrayList<Brand> getBrands() throws DaoException {

		// If brands array empty -> get content from DB

		if(brands.size() == 0){

			// Get data...
			BrandsDao brandsDao = new BrandsDao();
			ArrayList<Brand> brandsList = brandsDao.getBrands();

			VerticalsDao verticalsDao = new VerticalsDao();
			ArrayList<Vertical> verticalsList = verticalsDao.getVerticals();

			ConfigSettingsDao configSettingsDao = new ConfigSettingsDao();
			ArrayList<ConfigSetting> settingsList = configSettingsDao.getConfigSettings();

			if(brandsList.size() == 0 || verticalsList.size() == 0 || settingsList.size() == 0){
				throw new BrandException("Brand/Vertical/Settings missing from DB");
			}

			// Populate each brand's vertical objects.
			for(Brand brand : brandsList){

				ArrayList<Vertical> brandVerticals = brand.getVerticals();

				for(Vertical vertical : verticalsList){

					Vertical brandVertical = vertical.clone();

					for(ConfigSetting setting : settingsList){


						if( (setting.getStyleCodeId() == ConfigSetting.ALL_BRANDS || setting.getStyleCodeId() == brand.getId()) &&
							(setting.getVerticalId() == ConfigSetting.ALL_VERTICALS || setting.getVerticalId() == brandVertical.getId()) ){

							brandVertical.addSetting(setting.clone());

						}
					}

					if(brandVertical.isEnabled()){
						brandVerticals.add(brandVertical);
					}
				}
			}

			// Update static variables
			brands = brandsList;

			logger.info("Loaded "+brandsList.size()+" brands and "+verticalsList.size()+" verticals from database");

		}

		return brands;
	}

	/**
	 * Get the server's current date/time.
	 * @return
	 */
	public static Date getServerDate() {
		return getApplicationDate(null);
	}

	/**
	 * Get the application's current date/time, or check if the request session contains an override.
	 * @return Server's datetime, or configured override datetime.
	 */
	public static Date getApplicationDate(HttpServletRequest request) {
		Date date = getApplicationDateIfSet(request);
		if(date == null){
			return new Date();
		}
		else {
			return date;
		}
	}

	/**
	 * Get  the request session contains an override. Don't return a default
	 * @return configured override datetime.
	 */
	public static Date getApplicationDateIfSet(HttpServletRequest request) {
		if (request != null) {
			// Check if the session contains an override of the server's date
			HttpSession session = request.getSession();
			if (session != null) {
				Object attribute = session.getAttribute(applicationDateSessionKey);
				if (attribute != null) {
					logger.debug("Application date override retrieved: " + ((Date)attribute).toString());
					return (Date) attribute;
				}
			}
		}
		return null;
	}

	/**
	 * Set an attribute on the session to override the application's date (accessed via getApplicationDate())
	 * @param request
	 * @param dateString Date in format "2014-09-08 17:15:00"
	 */
	public static void setApplicationDateOnSession(HttpServletRequest request, String dateString) throws ParseException {
		if (request != null) {
			HttpSession session = request.getSession();
			if (session != null) {
				// Remove session entry
				if (dateString == null || dateString.length() == 0) {
					session.removeAttribute(applicationDateSessionKey);
					logger.debug("Removed application date from session");
				}
				// Add session entry
				else {
					SimpleDateFormat parser = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date date = parser.parse(dateString);
					session.setAttribute(applicationDateSessionKey, date);
					logger.debug("Application date set on session: " + date.toString());
				}
			}
		}
	}

	/**
	 * Clear the cached brands and settings and refreshes from DAO.
	 */
	public static boolean clearCache() throws DaoException {
		brands = new ArrayList<Brand>();
		getBrands();
		ServiceConfigurationService.clearCache();
		AddressSearchService.destroy();
		AddressSearchService.init();
        ApplicationCacheManager.clearAll();
		return true;
	}

}
