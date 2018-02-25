package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.*;
import com.ctm.web.core.provider.model.Provider;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class ProductDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(ProductDao.class);


		public ProductDao() {

		}

	/**
	 * Returns a product model with provider and properties.
	 *
	 * @param productCode
	 * @param effectiveDate
	 * @param getExtendedProperties Properties from ctm.product_properties_ext (json/xml format)
	 * @param getTextProperties Properties from ctm.product_properties_text (TEXT format)
	 * @return
	 * @throws DaoException
	 */
	public Product getByCode(String verticalCode, String productCode, Date effectiveDate, boolean getExtendedProperties, boolean getTextProperties) throws DaoException {

		ArrayList<Product> products = new ArrayList<Product>();
		products = queryDatabase(verticalCode, SearchType.PRODUCT_CODE, productCode, null, effectiveDate, getExtendedProperties, getTextProperties);
		return products.size() > 0 ? products.get(0) : null;
	}

	/**
	 * Returns a a collection of products by vertical
	 * @param verticalCode
	 * @param effectiveDate
	 * @param getExtendedProperties
	 * @param getTextProperties
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<Product> getByVertical(String verticalCode, Date effectiveDate, boolean getExtendedProperties, boolean getTextProperties) throws DaoException {

		ArrayList<Product> products = new ArrayList<Product>();
		products = queryDatabase(verticalCode, SearchType.FULL_LIST_BY_VERTICAL, verticalCode, null, effectiveDate, getExtendedProperties, getTextProperties);
		return products;
	}

	/**
	 * Get all products for the specified category code (with optional filter on provider code).
	 *
	 * @param categoryCode
	 * @param effectiveDate
	 * @param filterByProviderCode
	 * @param getExtendedProperties
	 * @param getTextProperties
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<Product> getByCategoryCode(String verticalCode, String categoryCode, Date effectiveDate, String filterByProviderCode, boolean getExtendedProperties, boolean getTextProperties) throws DaoException{

		ArrayList<Product> products = new ArrayList<Product>();
		SearchType type = SearchType.CATEGORY_CODE;
		if(filterByProviderCode != null && filterByProviderCode.equals("") == false){
			type = SearchType.CATEGORY_AND_PROVIDER_CODES;
		}
		products = queryDatabase(verticalCode, type, categoryCode, filterByProviderCode, effectiveDate, getExtendedProperties, getTextProperties);
		return products;
	}

	/**
	 * Get all products for the specified provider code.
	 *
	 * @param providerCode
	 * @param effectiveDate
	 * @param getExtendedProperties
	 * @param getTextProperties
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<Product> getByProviderCode(String verticalCode, String providerCode, Date effectiveDate, boolean getExtendedProperties, boolean getTextProperties) throws DaoException{

		ArrayList<Product> products = new ArrayList<Product>();
		products = queryDatabase(verticalCode, SearchType.PROVIDER_CODE, providerCode, null, effectiveDate, getExtendedProperties, getTextProperties);
		return products;
	}

	public static enum SearchType {
		PRODUCT_CODE,
		CATEGORY_CODE,
		PROVIDER_CODE,
		CATEGORY_AND_PROVIDER_CODES,
		FULL_LIST_BY_VERTICAL
	}


	/**
	 * Method to query Database for different types of product searches.
	 *
	 * @param verticalCode
	 * @param searchType
	 * @param primaryValue
	 * @param secondaryValue
	 * @param effectiveDate
	 * @param getExtendedProperties
	 * @param getTextProperties
	 * @return
	 * @throws DaoException
	 */
	private ArrayList<Product> queryDatabase(String verticalCode, SearchType searchType, String primaryValue, String secondaryValue, Date effectiveDate, boolean getExtendedProperties, boolean getTextProperties) throws DaoException{

		ArrayList<Product> products = new ArrayList<Product>();

		SimpleDatabaseConnection dbSource = null;
		java.sql.Date effectiveDateSQL = new java.sql.Date(effectiveDate.getTime());
		Timestamp effectiveDateTime = new Timestamp(effectiveDate.getTime());

		try {

			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			ProductDaoBuilder productDaoBuilder = new ProductDaoBuilder();
			productDaoBuilder.withTimeStamp(effectiveDateTime);

			// Get product and provider data
			//change this to switch
			if(searchType == SearchType.CATEGORY_AND_PROVIDER_CODES){
				productDaoBuilder.withCategoryCode(primaryValue).withProviderCode(secondaryValue);
				productDaoBuilder.withProviderCode(primaryValue);
			}else if(searchType == SearchType.PROVIDER_CODE){
				productDaoBuilder.withProviderCode(primaryValue);
			} else if(searchType == SearchType.CATEGORY_CODE){
				productDaoBuilder.withCategoryCode(primaryValue);
			} else if(searchType == SearchType.PRODUCT_CODE ) {
				productDaoBuilder.withProductCode(primaryValue);
			}

			productDaoBuilder.withProductCat(verticalCode);

			stmt = dbSource.getConnection().prepareStatement(
					generateProductQueryString(searchType, productDaoBuilder)
			);

			productDaoBuilder.buildParams(stmt);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				products.add(mapResultToProduct(results));

			}

			// Get product properties data
			productDaoBuilder.resetParams();

			productDaoBuilder.withTimeStamp(effectiveDateTime);

			if(searchType == SearchType.CATEGORY_AND_PROVIDER_CODES) {
				productDaoBuilder.withCategoryCode(primaryValue).withProviderCode(secondaryValue);
			} else if(searchType == SearchType.PROVIDER_CODE) {
				productDaoBuilder.withProviderCode(primaryValue);
			} else if(searchType == SearchType.CATEGORY_CODE) {
				productDaoBuilder.withCategoryCode(primaryValue);
			} else if(searchType == SearchType.PRODUCT_CODE) {
				productDaoBuilder.withProductCode(primaryValue);
			}

			stmt = dbSource.getConnection().prepareStatement(
					generatePropertiesQueryString(searchType, productDaoBuilder)
			);

			productDaoBuilder.buildParams(stmt);

			results = stmt.executeQuery();

			while (results.next()) {

				Product product = getProductById(products, results.getInt("productId"));

				if(product != null){
					product.addProperty(mapResultToProductProperty(results));
				}

			}

			// Do we want to also retrieve from the product_properties_text table?
			if(getTextProperties) {

				String idList = "";
				for(Product productIdList : products){
					idList += productIdList.getId() + ",";
				}

				if(!idList.equals("")) {

					idList = idList.substring(0,idList.length()-1);

					stmt = dbSource.getConnection().prepareStatement(
							generatePropertiesTextQueryString(searchType)
					);

					stmt.setString(1, idList);
					stmt.setDate(2, effectiveDateSQL);

					results = stmt.executeQuery();

					while (results.next()) {

						Product product = getProductById(products, results.getInt("productId"));

						if(product != null){
							product.addPropertyText(mapResultToProductPropertyText(results));
						}

					}
				}
			}

			// Do we want to also retrieve from the product_properties_ext table?
			if(getExtendedProperties) {
				String idList = "";
				for(Product productIdList : products){
					idList += productIdList.getId() + ",";
				}

				if(!idList.equals("")) {

					idList = idList.substring(0,idList.length()-1);

					stmt = dbSource.getConnection().prepareStatement(
							generatePropertiesExtQueryString(searchType)
					);

					stmt.setString(1, idList);

					results = stmt.executeQuery();

					while (results.next()) {

						Product product = getProductById(products, results.getInt("productId"));

						if(product != null){
							product.addPropertyExt(mapResultToProductPropertyExt(results));
						}

					}
				}
			}

			results.close();
			stmt.close();

			return products;
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	private String generatePropertiesExtQueryString(SearchType searchType) {
		String string = "SELECT productId, Text, Type " +
				"FROM ctm.product_properties_ext " +
				" WHERE productId IN (?)";
		return string;
	}

	private ProductPropertyExt mapResultToProductPropertyExt(ResultSet results)
			throws SQLException {
		ProductPropertyExt propertyExt = new ProductPropertyExt();

		propertyExt.setProductId(results.getInt("productId"));
		propertyExt.setText(results.getString("Text"));
		propertyExt.setType(results.getString("Type"));
		return propertyExt;
	}

	private String generatePropertiesTextQueryString(SearchType searchType) {
		String string = "SELECT ProductId, PropertyId, Text, EffectiveStart, EffectiveEnd" +
				" FROM ctm.product_properties_text " +
				" WHERE productId IN (?) AND ? BETWEEN EffectiveStart and EffectiveEnd" +
				" AND status != 'X'";
		return string;
	}

	private ProductPropertyText mapResultToProductPropertyText(ResultSet results)
			throws SQLException {
		ProductPropertyText propertyText = new ProductPropertyText();
		propertyText.setProductId(results.getInt("ProductId"));
		propertyText.setPropertyId(results.getString("PropertyId"));
		propertyText.setText(results.getString("Text"));
		propertyText.setEffectiveStart(results.getDate("EffectiveStart"));
		propertyText.setEffectiveEnd(results.getDate("EffectiveEnd"));
		return propertyText;
	}

	private ProductProperty mapResultToProductProperty(ResultSet results)
			throws SQLException {
		ProductProperty property = new ProductProperty();

		property.setPropertyId(results.getString("propertyId"));
		property.setBenefitOrder(results.getInt("benefitOrder"));
		property.setDate(results.getDate("date"));
		property.setEffectiveEnd(results.getDate("effectiveEnd"));
		property.setEffectiveStart(results.getDate("effectiveStart"));
		property.setSequenceNumber(results.getInt("sequenceNo"));
		property.setStatus(results.getString("status"));
		property.setText(results.getString("text"));
		double value = results.getDouble("value");
		if(results.wasNull()) {
			property.setValue(null);
		} else {
			property.setValue(value);
		}

		property.setLabel(results.getString("label"));
		property.setLongLabel(results.getString("longLabel"));
		property.setHelpId(results.getInt("helpId"));
		return property;
	}

	private Product mapResultToProduct(ResultSet results) throws SQLException {
		Product product = new Product();

		product.setCode(results.getString("productCode"));
		product.setEffectiveEnd(results.getDate("effectiveEnd"));
		product.setEffectiveStart(results.getDate("effectiveStart"));
		product.setId(results.getInt("productId"));
		product.setLongTitle(results.getString("longTitle"));
		product.setShortTitle(results.getString("shortTitle"));
		product.setStatus(results.getString("status"));
		product.setVerticalCode(results.getString("productCat"));

		Provider provider = new Provider();
		provider.setCode(results.getString("providerCode"));
		provider.setId(results.getInt("providerId"));
		provider.setName(results.getString("name"));
		product.setProvider(provider);
		return product;
	}


	/**
	 * Generate SQL to populate the Product models.
	 *
	 * @param searchType
	 * @param productDaoBuilder
	 * @return
	 */
	private String generateProductQueryString(SearchType searchType, ProductDaoBuilder productDaoBuilder){

		String string = "SELECT pro.productId, pro.productCode, pro.productCat, pro.providerId as providerId, " +
				"pro.shortTitle, pro.longTitle, pro.status, pro.effectiveStart as effectiveStart, " +
				"pro.effectiveEnd as effectiveEnd, providerCode, name " +
				"FROM ctm.product_master pro " +
				"LEFT JOIN ctm.provider_master pm ON pro.providerId = pm.providerId AND " +
				"? BETWEEN pm.effectiveStart AND pm.effectiveEnd AND pm.status <> 'X' ";

		productDaoBuilder.addTimeStampEffectiveDateTimeParam();

		if(searchType == SearchType.CATEGORY_AND_PROVIDER_CODES || searchType == SearchType.CATEGORY_CODE){
			string += "LEFT JOIN ctm.category_product_mapping cm on pro.productId = cm.productId ";
			string += "LEFT JOIN ctm.category_master ccm on ccm.categoryid = cm.categoryid ";
		}

		if(searchType == SearchType.CATEGORY_AND_PROVIDER_CODES || searchType == SearchType.PROVIDER_CODE){
			string += "LEFT JOIN ctm.product_master prom ON pro.productid = prom.productid AND ? BETWEEN prom.effectiveStart AND prom.effectiveEnd ";
			productDaoBuilder.addTimeStampEffectiveDateTimeParam();
		}

		string += "WHERE ";

		if(searchType == SearchType.CATEGORY_AND_PROVIDER_CODES || searchType == SearchType.CATEGORY_CODE){
			string += "ccm.categoryCode = ? AND ";
			productDaoBuilder.addCategoryCodeParam();
		}

		if(searchType == SearchType.CATEGORY_AND_PROVIDER_CODES || searchType == SearchType.PROVIDER_CODE){
			string += "providerCode = ? AND ";
			productDaoBuilder.addProviderCodeParam();
		}

		if(searchType == SearchType.PRODUCT_CODE){
			string += "pro.productCode = ? AND ";
			productDaoBuilder.addProductCodeParam();
		}

		string += "pro.productCat = ? AND ";
		productDaoBuilder.addProductCatParam();

		string += "? BETWEEN pro.effectiveStart AND pro.effectiveEnd";
		productDaoBuilder.addTimeStampEffectiveDateTimeParam();
		return string;


	}

	/**
	 * Generate SQL to populate the Product Property models.
	 *
	 * @param searchType
	 * @param productDaoBuilder
	 * @return
	 */
	private String generatePropertiesQueryString(SearchType searchType, ProductDaoBuilder productDaoBuilder){

		String string = "SELECT pp.productId, pp.propertyId, sequenceNo, value, text, date, pp.effectiveStart, pp.effectiveEnd, pp.status, benefitOrder, "+
				"pm.label, pm.longLabel, pm.helpId " +
				"FROM ctm.product_properties pp " +
				"LEFT JOIN ctm.property_master pm on pp.propertyid = pm.propertyid and ? BETWEEN pm.effectiveStart AND pm.effectiveEnd ";
		productDaoBuilder.addTimeStampEffectiveDateTimeParam();

		if(searchType == SearchType.CATEGORY_AND_PROVIDER_CODES || searchType == SearchType.CATEGORY_CODE){
			string += "LEFT JOIN ctm.category_product_mapping cm on pp.productId = cm.productId ";
			string += "LEFT JOIN ctm.category_master ccm on ccm.categoryid = cm.categoryid ";
		}

		if(searchType == SearchType.CATEGORY_AND_PROVIDER_CODES || searchType == SearchType.PROVIDER_CODE || searchType == SearchType.PRODUCT_CODE){
			string += "LEFT JOIN ctm.product_master prom on pp.productid = prom.productid and ? Between prom.effectiveStart AND prom.effectiveEnd ";
			productDaoBuilder.addTimeStampEffectiveDateTimeParam();
		}

		if(searchType == SearchType.CATEGORY_AND_PROVIDER_CODES || searchType == SearchType.PROVIDER_CODE){
			string += "LEFT JOIN ctm.provider_master pmp on prom.providerId = pmp.providerId and ? Between pmp.effectiveStart AND pmp.effectiveEnd AND pmp.status <> 'X' ";
			productDaoBuilder.addTimeStampEffectiveDateTimeParam();
		}

		string += "WHERE ";

		if(searchType == SearchType.CATEGORY_AND_PROVIDER_CODES || searchType == SearchType.CATEGORY_CODE){
			string += "ccm.categoryCode = ? AND ";
			productDaoBuilder.addCategoryCodeParam();
		}

		if(searchType == SearchType.CATEGORY_AND_PROVIDER_CODES || searchType == SearchType.PROVIDER_CODE){
			string += "providerCode = ? AND ";
			productDaoBuilder.addProviderCodeParam();
		}

		if(searchType == SearchType.PRODUCT_CODE){
			string += "prom.productCode = ? AND ";
			productDaoBuilder.addProductCodeParam();
		}

		string += "? BETWEEN pp.effectiveStart AND pp.effectiveEnd";
		productDaoBuilder.addTimeStampEffectiveDateTimeParam();

		string += " AND pm.productCat = ?";
		productDaoBuilder.addProductCatParam();

		if(searchType == SearchType.CATEGORY_AND_PROVIDER_CODES || searchType == SearchType.PROVIDER_CODE || searchType == SearchType.PRODUCT_CODE){
			string += " AND prom.productCat = ?";
			productDaoBuilder.addProductCatParam();
		}


		return string;
	}

	/**
	 * Quick look up helper method.
	 *
	 * @param products
	 * @param id
	 * @return
	 */
	private Product getProductById(ArrayList<Product> products, int id){
		for(Product product : products){
			if(product.getId() == id){
				return product;
			}
		}

		return null;
	}

	/**
	 * Returns distinct list of all products for a specified provider -
	 *    getActiveAndFutureProducts = true - return names of products that are currently active and names of products available in the future
	 *    getActiveAndFutureProducts = false - return names of products that are currently active only
	 *
	 * @param verticalCode
	 * @param providerId
	 * @param getActiveAndFutureProducts
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<ProductName> getProductNames(String verticalCode, int providerId, Boolean getActiveAndFutureProducts) throws DaoException{
		SimpleDatabaseConnection dbSource = null;

		ArrayList<ProductName> productNames = new ArrayList<>();

		try{
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			String statementSQL = "SELECT DISTINCT ShortTitle, LongTitle " +
				"FROM ctm.product_master " +
				"WHERE ProductCat = ? " +
				"AND ProviderId = ? " +
				"AND (CURDATE() BETWEEN EffectiveStart AND EffectiveEnd ";

			if (getActiveAndFutureProducts) {
				statementSQL += "OR CURDATE() < EffectiveStart ";
			}

			statementSQL += ") AND Status != 'X' ORDER BY ShortTitle ASC";

			stmt = dbSource.getConnection().prepareStatement(statementSQL);

			stmt.setString(1, verticalCode);
			stmt.setInt(2, providerId);

			ResultSet productResult = stmt.executeQuery();

			while (productResult.next()) {

				ProductName productNm = new ProductName();
				productNm.setShortTitle(productResult.getString("ShortTitle"));
				productNm.setLongTitle(productResult.getString("LongTitle"));
				productNames.add(productNm);

			}

		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to retrieve products for vertical {}, {}, {}, {}", kv("verticalCode", verticalCode),
				kv("providerId", providerId), kv("getActiveAndFutureProducts", getActiveAndFutureProducts));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return productNames;
	}
}
