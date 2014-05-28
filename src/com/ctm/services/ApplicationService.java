package com.ctm.services;

import java.util.ArrayList;
import java.util.Date;

import javax.servlet.jsp.PageContext;

import org.apache.log4j.Logger;

import com.ctm.dao.BrandsDao;
import com.ctm.dao.ConfigSettingsDao;
import com.ctm.dao.VerticalsDao;
import com.ctm.exceptions.BrandException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.Vertical;
import com.disc_au.web.go.Data;

public class ApplicationService {

	private static Logger logger = Logger.getLogger(ApplicationService.class.getName());

	private static ArrayList<Brand> brands = new ArrayList<Brand>(); // Note: always use the getBrands() method so the data is loaded from the DB



	/**
	 *
	 * @param pageContext
	 * @param verticalCode
	 * @return
	 * @throws Exception
	 */
	public static boolean isVerticalEnabledForBrand(PageContext pageContext, String verticalCode) throws DaoException {

		// Check for the vertical enabled setting for this brand/vertical combination.
		Brand brand = getBrandFromPageContext(pageContext);
		Vertical vertical = brand.getVerticalByCode(verticalCode);

		if(vertical == null){
			return false;
		}

		ConfigSetting verticalEnabledSetting = vertical.getSettingForName("status");

		if(verticalEnabledSetting == null){
			return false;
		}

		if(verticalEnabledSetting.getValue().equals("Y") == false){
			return false;
		}

		return true;
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
	 * @param pageContext
	 * @return
	 * @throws DaoException
	 */
	public static Brand getBrandFromPageContext(PageContext pageContext) throws DaoException {

		getBrands();

		Brand brand = null;

		// 1. Look for brand parameter from request scope
		String brandCode = (String) pageContext.getRequest().getParameter("brandCode");

		brand = getBrandByCode(brandCode);

		// If localhost or NXI, the URL writing is not in place, therefore we have fall back logic...
		if(brand == null && EnvironmentService.needsManuallyAddedBrandCodeParam()){

			Data sessionData = (Data) pageContext.getAttribute("data", PageContext.REQUEST_SCOPE);
			if(sessionData != null){
				brandCode = (String) sessionData.get("current/brandCode");
			}

			if(brandCode == null || brandCode.equals("")){
				// Try and use the last used brand code.
				brandCode = (String) pageContext.getAttribute("lastUsedBrandCode", PageContext.SESSION_SCOPE);
			}

			if(brandCode == null || brandCode.equals("")){
				brandCode = "CTM";
				logger.warn("Brand code unknown - automatically setting brand to CTM - LOCALHOST, NXI and NXS functionality only - to override, add brandCode=X to your url");
			}else{
				logger.warn("Brand code unknown - using last used brand code: "+brandCode+" - LOCALHOST, NXI and NXS functionality only");
			}


			brand = getBrandByCode(brandCode);

		}

		if(EnvironmentService.needsManuallyAddedBrandCodeParam()){
			pageContext.setAttribute("lastUsedBrandCode", brand.getCode(), PageContext.SESSION_SCOPE);
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
	 * @param pageContext
	 * @return
	 * @throws DaoException
	 * @throws Exception
	 */
	public static String getBrandCodeFromPageContext(PageContext pageContext) throws DaoException {
		Brand brand = getBrandFromPageContext(pageContext);
		if(brand == null) return null;
		return brand.getCode();
	}

	/**
	 *
	 * @param pageContext
	 * @return
	 */
	public static String getVerticalCodeFromPageContext(PageContext pageContext){
		return (String) pageContext.getAttribute("verticalCode", PageContext.REQUEST_SCOPE);
	}

	/**
	 *
	 * @param pageContext
	 * @param verticalCode
	 */
	public static void setVerticalCodeOnPageContext(PageContext pageContext, String verticalCode){
		pageContext.setAttribute("verticalCode", verticalCode, PageContext.REQUEST_SCOPE);
	}

	/**
	 *
	 * @param data
	 * @return
	 */
	public static String getVerticalCodeFromTransactionSessionData(Data data){
		return (String) data.get("current/vertical");
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
	 *
	 * @return
	 */
	public static Date getServerDate(){
		// TODO write overrides for LOCAL/NXI/NXQ testing
		return new Date();
	}

	/**
	 *
	 * @param pageContext
	 * @return
	 * @throws DaoException
	 * @throws Exception
	 */
	public static boolean clearCache(PageContext pageContext) throws DaoException {
		brands = new ArrayList<Brand>();
		getBrands();
		return true;
	}

}
