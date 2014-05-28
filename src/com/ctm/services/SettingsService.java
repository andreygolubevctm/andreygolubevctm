package com.ctm.services;

import javax.servlet.jsp.PageContext;

import org.apache.log4j.Logger;

import com.ctm.exceptions.BrandException;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.PageSettings;

public class SettingsService {
	private static Logger logger = Logger.getLogger(SettingsService.class.getName());
	/**
	 * Sets the vertical code for the page request scope and loads the settings object.
	 * This method also checks to see if the vertical is enabled for the brand. (and by extension that the brand code is set)
	 * Call this on vertical start pages like health_quote.jsp
	 *
	 * @param pageContext
	 * @param verticalCode
	 * @return
	 * @throws DaoException
	 * @throws ConfigSettingException
	 * @throws Exception
	 */
	public static PageSettings setVerticalAndGetSettingsForPage(PageContext pageContext, String verticalCode) throws DaoException, ConfigSettingException {

		// Check for the vertical enabled setting for this brand/vertical combination.
		if(ApplicationService.isVerticalEnabledForBrand(pageContext, verticalCode) == false){
			throw new BrandException("Vertical not enabled for brand.");
		}

		// Set vertical to request scope. (all other settings requests on this page will be set to this vertical)
		ApplicationService.setVerticalCodeOnPageContext(pageContext, verticalCode);

		return getPageSettingsForPage(pageContext);

	}

	/**
	 * Gets the page settings object by determining the current vertical by checking the provided session transaction data.
	 * Call this method on ajax calls where the transaction id is passed through as a parameter.
	 *
	 * @param pageContext
	 * @param transactionData
	 * @return
	 * @throws DaoException
	 * @throws ConfigSettingException
	 * @throws Exception
	 */
	public static PageSettings getPageSettingsForPage(PageContext pageContext) throws DaoException, ConfigSettingException {
		Brand brand = ApplicationService.getBrandFromPageContext(pageContext);
		PageSettings pageSettings = new PageSettings();
		pageSettings.setBrand(brand);
		String verticalCode = ApplicationService.getVerticalCodeFromPageContext(pageContext);
		if(verticalCode == null || verticalCode.equals("")){
			throw new ConfigSettingException("No vertical set on page context");
		}

		pageSettings.setVertical(brand.getVerticalByCode(verticalCode));
		return pageSettings;
	}



	/**
	 *
	 * @param brandCode
	 * @param verticalCode
	 * @return
	 */
	public static PageSettings getPageSettingsByCode(String brandCode, String verticalCode){

		Brand brand = ApplicationService.getBrandByCode(brandCode);
		PageSettings pageSettings = new PageSettings();
		pageSettings.setBrand(brand);
		pageSettings.setVertical(brand.getVerticalByCode(verticalCode));

		return pageSettings;
	}

	/**
	 *
	 * @param brandId
	 * @param verticalCode
	 * @return
	 */
	public static PageSettings getPageSettings(int brandId, String verticalCode){

		Brand brand = ApplicationService.getBrandById(brandId);
		PageSettings pageSettings = new PageSettings();
		pageSettings.setBrand(brand);
		pageSettings.setVertical(brand.getVerticalByCode(verticalCode));

		return pageSettings;
	}
}
