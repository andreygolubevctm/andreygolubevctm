package com.ctm.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.jsp.PageContext;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import com.ctm.data.PageSettings;
import com.ctm.data.dao.Brand;
import com.ctm.data.dao.ConfigSetting;
import com.ctm.data.dao.Vertical;
import com.ctm.data.exceptions.BrandException;
import com.ctm.data.exceptions.ConfigSettingException;
import com.ctm.data.exceptions.VerticalException;
import com.ctm.services.EnvironmentService.Environment;
import com.disc_au.web.go.Data;

public class ApplicationService {

	private static Logger logger = Logger.getLogger(ApplicationService.class.getName());

	private static ArrayList<Brand> brands = new ArrayList<Brand>(); // Note: always use the getBrands() method so the data is loaded from the DB

	/**
	 * Sets the vertical code for the page request scope and loads the settings object.
	 * This method also checks to see if the vertical is enabled for the brand. (and by extension that the brand code is set)
	 * Call this on vertical start pages like health_quote.jsp
	 *
	 * @param pageContext
	 * @param verticalCode
	 * @return
	 * @throws Exception
	 */
	public static PageSettings setVerticalAndGetSettingsForPage(PageContext pageContext, String verticalCode) throws Exception {

		// Set vertical to request scope. (all other settings requests on this page will be set to this vertical)
		setVerticalCodeOnPageContext(pageContext, verticalCode);

		// Check for the vertical enabled setting for this brand/vertical combination.
		String verticalEnabledSetting = getSetting(pageContext, "status");

		if(verticalEnabledSetting.equals("Y") == false){
			throw new BrandException("Vertical not enabled for brand.");
		}

		return getPageSettings(pageContext);

	}

	/**
	 * Gets the page settings object by determining the current vertical by checking the provided session transaction data.
	 * Call this method on ajax calls where the transaction id is passed through as a parameter.
	 *
	 * @param pageContext
	 * @param transactionData
	 * @return
	 * @throws Exception
	 */
	public static PageSettings getPageSettingsForPage(PageContext pageContext) throws Exception{
		return getPageSettings(pageContext);
	}

	/**
	 * Get the page settings, either from the vertical code in the page context or the provided
	 * @param pageContext
	 * @param transactionData
	 * @return
	 * @throws Exception
	 */
	private static PageSettings getPageSettings(PageContext pageContext) throws Exception{

		PageSettings pageSettings = new PageSettings();
		Brand brand = getBrandFromPageContext(pageContext);
		pageSettings.setBrandCode(brand.getCode());
		pageSettings.setBrandId(brand.getId());

		String verticalCode = getVerticalCodeFromPageContext(pageContext);

		pageSettings.setVertical(brand.getVerticalByCode(verticalCode));
		return pageSettings;
	}


	/**
	 * Looks at the pageContext for the brand code - this should be a param brandCode=xxx set by the F5 server's rewrite rules.
	 * In Localhost and NXI, we have to depend on the data bucket as we don't have rewrite logic on these environments.
	 *
	 * @param pageContext
	 * @return
	 * @throws Exception
	 */
	private static Brand getBrandFromPageContext(PageContext pageContext) throws Exception{


		getBrands();

		Brand brand = null;
		// 1. Look for brand parameter from request scope // #WHITELABEL - enable this for whitelabel support.
		String brandCode = "CTM";// (String) pageContext.getRequest().getParameter("brandCode");

		brand = getBrandByCode(brandCode);

		// If localhost or NXI, the URL writing is not in place, therefore we have fall back logic...
		if(brand == null && (EnvironmentService.getEnvironment() == Environment.LOCALHOST || EnvironmentService.getEnvironment() == Environment.NXI)){

			Data sessionData = (Data) pageContext.getAttribute("data", PageContext.REQUEST_SCOPE);
			if(sessionData == null) return null;

			brandCode = (String) sessionData.get("current/brandCode");
			if(brandCode == null) return null;

			brand = getBrandByCode(brandCode);
		}

		return brand;

	}


	// Look up methods --------------------------------------------------------------------------

	/**
	 * Look up method to find the brand object from the static array.
	 *
	 * @param code
	 * @return
	 */
	private static Brand getBrandByCode(String code){

		for(Brand brand : brands){
			if(brand.getCode().equalsIgnoreCase(code)){
				return brand;
			}
		}

		return null;
	}

	public static String getBrandCodeFromPageContext(PageContext pageContext) throws Exception{
		Brand brand = getBrandFromPageContext(pageContext);
		if(brand == null) return null;
		return brand.getCode();
	}

	public static String getVerticalCodeFromPageContext(PageContext pageContext){
		return (String) pageContext.getAttribute("verticalCode", PageContext.REQUEST_SCOPE);
	}

	public static void setVerticalCodeOnPageContext(PageContext pageContext, String verticalCode){
		pageContext.setAttribute("verticalCode", verticalCode, PageContext.REQUEST_SCOPE);
	}

	public static String getVerticalCodeFromTransactionSessionData(Data data){
		return (String) data.get("current/vertical");
	}

	public static String getSetting(PageContext pageContext, String configCode) throws Exception{

		Brand brand = getBrandFromPageContext(pageContext);

		if(brand == null){
			throw new BrandException("Brand identifier not found.");
		}

		String verticalCode = getVerticalCodeFromPageContext(pageContext);

		if(verticalCode == null){
			throw new VerticalException("Vertical code not set on page context");
		}

		Vertical vertical = brand.getVerticalByCode(verticalCode);

		if(vertical == null){
			throw new VerticalException("Vertical code not found for '"+verticalCode+"'");
		}

		ConfigSetting setting = vertical.getSettingForName(configCode);

		if(setting == null){
			throw new ConfigSettingException("Setting code not found for '"+configCode+"'");
		}

		return setting.getValue();
	}


	/**
	 * Returns the list of brands with their verticals and vertical settings.
	 * On first run the brands, verticals and settings are loaded from the database.
	 * @return
	 * @throws Exception
	 */
	public static ArrayList<Brand> getBrands() throws Exception{

		// If brands array empty -> get content from DB

		if(brands.size() == 0){

			Connection conn = null;

			try{

				Context initCtx = new InitialContext();
				Context envCtx = (Context) initCtx.lookup("java:comp/env");
				DataSource ds = (DataSource) envCtx.lookup("jdbc/ctm");
				PreparedStatement stmt;
				conn = ds.getConnection();


				ArrayList<Brand> brandsList = new ArrayList<Brand>();
				ArrayList<Vertical> verticalsList = new ArrayList<Vertical>();
				ArrayList<ConfigSetting> settingsList = new ArrayList<ConfigSetting>();


				// Get brands

				stmt = conn.prepareStatement(
					"SELECT * " +
					"FROM ctm.stylecodes s " +
					"ORDER BY s.styleCodeId;"
				);

				ResultSet brandResult = stmt.executeQuery();

				while (brandResult.next()) {

					Brand brand = new Brand();
					brand.setId(brandResult.getInt("styleCodeId"));
					brand.setName(brandResult.getString("styleCodeName"));
					brand.setCode(brandResult.getString("styleCode"));
					brandsList.add(brand);

				}

				// Get verticals

				stmt = conn.prepareStatement(
					"SELECT * " +
					"FROM ctm.vertical_master v " +
					"ORDER BY v.verticalCode;"
				);

				ResultSet verticalResult = stmt.executeQuery();

				while (verticalResult.next()) {

					Vertical vertical = new Vertical();
					vertical.setId(verticalResult.getInt("verticalId"));
					vertical.setName(verticalResult.getString("verticalName"));
					vertical.setCode(verticalResult.getString("verticalCode"));
					verticalsList.add(vertical);

				}

				// Get settings

				stmt = conn.prepareStatement(
					"SELECT * " +
					"FROM ctm.configuration c " +
					"WHERE c.environmentCode = ? or c.environmentCode = ? " +
					"ORDER BY c.configCode;"
				);
				stmt.setString(1, ConfigSetting.ALL_ENVIRONMENTS);
				stmt.setString(2, EnvironmentService.getEnvironmentAsString());

				ResultSet result = stmt.executeQuery();

				while (result.next()) {

					ConfigSetting item = new ConfigSetting();
					item.setName(result.getString("configCode"));
					item.setValue(result.getString("configValue"));
					item.setStyleCodeId(result.getInt("styleCodeId"));
					item.setVerticalId(result.getInt("verticalId"));
					item.setEnvironment(result.getString("environmentCode"));
					settingsList.add(item);

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

						brandVerticals.add(brandVertical);
					}
				}

				// Update static variables
				brands = brandsList;

				logger.info("Loaded "+brandsList.size()+" brands and "+verticalsList.size()+" verticals from database");

			} catch (SQLException e) {
				e.printStackTrace();
				throw new BrandException("SQL Error");
			} catch (NamingException e) {
				e.printStackTrace();
				throw new BrandException("SQL Error");
			} finally {
				if(conn != null) {
					try {
						conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
						throw new BrandException("SQL Error");
					}
				}
			}
		}

		return brands;
	}

	public static boolean clearCache(PageContext pageContext) throws Exception{
		brands = new ArrayList<Brand>();
		getBrands();
		return true;
	}



}
