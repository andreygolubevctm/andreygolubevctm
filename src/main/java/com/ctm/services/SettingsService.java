package com.ctm.services;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger; import org.slf4j.LoggerFactory;

import com.ctm.exceptions.BrandException;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.PageSettings;

public class SettingsService {

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(SettingsService.class.getName());

	/**
	 * Sets the vertical code for the page request scope and loads the settings object.
	 * This method also checks to see if the vertical is enabled for the brand. (and by extension that the brand code is set)
	 * Call this on vertical start pages like health_quote.jsp
	 *
	 * @param pageContext
	 * @param verticalCode this value is not case sensitive
	 * @return
	 * @throws DaoException
	 * @throws ConfigSettingException
	 * @throws BrandException if there is no brand code or it is not enabled for the vertical
	 */
	public static PageSettings setVerticalAndGetSettingsForPage(HttpServletRequest request, String verticalCode) throws DaoException, ConfigSettingException {

		// Check for the vertical enabled setting for this brand/vertical combination.
		if(ApplicationService.isVerticalEnabledForBrand(request, verticalCode) == false){
			throw new BrandException("Vertical not enabled for brand.");
		}

		// Set vertical to request scope. (all other settings requests on this page will be set to this vertical)
		ApplicationService.setVerticalCodeOnRequest(request, verticalCode);

		return getPageSettingsForPage(request);
	}

	/**
	 * Gets the page settings object by determining the current vertical by checking the provided session transaction data.
	 * Call this method on ajax calls where the transaction id is passed through as a parameter.
	 */
	public static PageSettings getPageSettingsForPage(HttpServletRequest request) throws DaoException, ConfigSettingException {
		Brand brand = ApplicationService.getBrandFromRequest(request);
		PageSettings pageSettings = new PageSettings();
		pageSettings.setBrand(brand);
		String verticalCode = ApplicationService.getVerticalCodeFromRequest(request);
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
