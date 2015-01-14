package com.ctm.dao.health;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthPricePremium;
import com.ctm.model.health.HealthPricePremiumRange;
import com.ctm.model.health.HealthPriceRequest;
import com.ctm.model.health.HealthPriceResult;
import com.ctm.model.health.ProductStatus;

public class HealthPriceDao {
	private static final String DISC_PREFIX = "disc";
	private static final String GROSS_PREFIX = "gross";
	private static Logger logger = Logger.getLogger(HealthPriceDao.class.getName());
	private SimpleDatabaseConnection dbSource;

	public HealthPriceDao() {
		this.dbSource = new SimpleDatabaseConnection();
	}

	public HealthPricePremiumRange getHealthPricePremiumRange(HealthPriceRequest healthPriceRequest) throws DaoException {

		HealthPricePremiumRange healthPricePremiumRange = new HealthPricePremiumRange();
		Date searchDate = new java.sql.Date(healthPriceRequest.getSearchDateValue().getTime());

		try {

			StringBuilder sqlBuilder = new StringBuilder()
					.append("SELECT ")
					.append("MIN(NULLIF(premiums.yearlyPremium, 0)) minYearlyPremium, ")
					.append("Max(premiums.yearlyPremium) maxYearlyPremium, ")
					.append("MIN(NULLIF(premiums.fortnightlyPremium, 0)) as minFortnightlyPremium, ")
					.append("Max(premiums.fortnightlyPremium) as maxFortnightlyPremium, ")
					.append("MIN(NULLIF(premiums.monthlyPremium, 0)) as minMonthlyPremium, ")
					.append("MAX(premiums.monthlyPremium) as maxMonthlyPremium ")
					.append("FROM ( ")
					.append("SELECT ")
					.append("search.ProductId ")
					.append("FROM ctm.product_properties_search search ")
					.append("INNER JOIN ctm.stylecode_products product ON search.ProductId = product.ProductId ")
					.append(getFilterLevelOfCover(healthPriceRequest))
					.append("WHERE ")
					.append("? BETWEEN product.EffectiveStart AND product.EffectiveEnd ")
					.append("AND product.Status NOT IN(")
					.append(questionMarksBuilder(healthPriceRequest.getExcludeStatus().size()))
					.append(") ")
					.append("AND product.styleCodeId = ? ");
			if (healthPriceRequest.getProviderId() != 0) {
				sqlBuilder
					.append("AND product.providerId = ? ");
			}
				sqlBuilder
					.append("AND product.providerId NOT IN(")
					.append(questionMarksBuilder(healthPriceRequest.getExcludedProvidersList().size()))
					.append(") ")
					.append("AND product.productCat = 'HEALTH' ")
					.append("AND search.state = ? ")
					.append("AND search.membership = ? ")
					.append("AND search.productType = ? ")
					.append("AND search.excessAmount >= ? and search.excessAmount <=  ? ");
			if (!healthPriceRequest.getHospitalSelection().equals("BOTH")) {
				sqlBuilder
					.append("AND search.hospitalType = ? ");
			}
				sqlBuilder
					.append("GROUP BY search.ProductId " + ") as results ")
					.append("INNER JOIN ctm.product_properties_premiums premiums ")
					.append("ON premiums.productID = results.productID");

			PreparedStatement stmt = dbSource.getConnection().prepareStatement(sqlBuilder.toString());

			int i = 1;

			if (healthPriceRequest.getTierHospital() > 0) {
				stmt.setInt(i++, healthPriceRequest.getTierHospital());
			}
			if (healthPriceRequest.getTierExtras() > 0) {
				stmt.setInt(i++, healthPriceRequest.getTierExtras());
			}

			stmt.setDate(i++, searchDate);

			for(ProductStatus excludeStatus : healthPriceRequest.getExcludeStatus()){
				stmt.setString(i++, excludeStatus.getCode());
			}

			stmt.setInt(i++, healthPriceRequest.getStyleCodeId());
			if (healthPriceRequest.getProviderId() != 0) {
				stmt.setInt(i++, healthPriceRequest.getProviderId());
			}

			for(Integer providerId :  healthPriceRequest.getExcludedProvidersList()){
				stmt.setInt(i++, providerId);
			}
			stmt.setString(i++, healthPriceRequest.getState());
			stmt.setString(i++, healthPriceRequest.getMembership());
			stmt.setString(i++, healthPriceRequest.getProductType());

			stmt.setInt(i++, healthPriceRequest.getExcessMin());
			stmt.setInt(i++, healthPriceRequest.getExcessMax());

			if (!healthPriceRequest.getHospitalSelection().equals("BOTH")) {
				stmt.setString(i++, healthPriceRequest.getHospitalSelection());
			}

			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				healthPricePremiumRange.setMinYearlyPremium(result
						.getDouble("minYearlyPremium"));
				healthPricePremiumRange.setMinFortnightlyPremium(result
						.getDouble("minFortnightlyPremium"));

				healthPricePremiumRange.setMinMonthlyPremium(result
						.getDouble("minMonthlyPremium"));
				healthPricePremiumRange.setMaxMonthlyPremium(result
						.getDouble("maxMonthlyPremium"));

				healthPricePremiumRange.setMaxYearlyPremium(result
						.getDouble("maxYearlyPremium"));
				healthPricePremiumRange.setMaxFortnightlyPremium(result
						.getDouble("maxFortnightlyPremium"));
			}

		} catch (SQLException | NamingException e) {
			logger.error("failed to get health price premium range" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}
		return healthPricePremiumRange;
	}

	public ArrayList<HealthPriceResult> fetchHealthResults(HealthPriceRequest healthPriceRequest) throws DaoException {

		ArrayList<HealthPriceResult> healthResults = new ArrayList<HealthPriceResult>();
		List<String> excludedProductIds = new ArrayList<String>();
		int limit = 4;

		try {
			// First Fetch, get first 4 products from different providers
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(getFetchSQL(healthPriceRequest, null, limit));
			populateParamsToFetchAll(healthPriceRequest, null, stmt);
			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				healthResults.add(getHealthPriceResult(result));
				excludedProductIds.add(result.getString("ProductId"));
			}

			if (!healthResults.isEmpty()) {

				limit = healthPriceRequest.getSearchResults() - limit;
				List<String> excludedProductIds2 = new ArrayList<String>(excludedProductIds);

				//second fetch, not going into the final results list, just to fill the second exclude productId list
				stmt = dbSource.getConnection().prepareStatement(getFetchSQL(healthPriceRequest, excludedProductIds, limit));
				populateParamsToFetchAll(healthPriceRequest, excludedProductIds, stmt);
				result = stmt.executeQuery();

				while (result.next()) {
					excludedProductIds2.add(result.getString("ProductId"));
				}

				//Third fetch, get the rest of products from different providers, exclude the productIds from first and second fetch, then union
				limit = healthPriceRequest.getSearchResults() - healthResults.size();
				String sql = getFetchSQL(healthPriceRequest, excludedProductIds, 0)
							+ "UNION "
							+ getFetchSQL(healthPriceRequest, excludedProductIds2, 0)
							+ "ORDER BY rank DESC, factoredPrice ASC "
							+ "LIMIT " + limit;

				stmt = dbSource.getConnection().prepareStatement(sql);

				int index = populateParamsToFetchAll(healthPriceRequest, excludedProductIds, stmt);
				populateParamsToFetchAll(healthPriceRequest, excludedProductIds2, stmt, index);

				result = stmt.executeQuery();

				excludedProductIds2 = new ArrayList<String>(excludedProductIds);

				while (result.next()) {
					healthResults.add(getHealthPriceResult(result));
					excludedProductIds2.add(result.getString("ProductId"));
				}

				//4th fetch, if list not full (e.g. less than 12), fetch the rest
				limit = healthPriceRequest.getSearchResults() - healthResults.size();
				if (limit > 0) {
					sql = getFetchSQL(healthPriceRequest, excludedProductIds2)
						+ "LIMIT " + limit;
					stmt = dbSource.getConnection().prepareStatement(sql);
					populateParamsToFetchAll(healthPriceRequest, excludedProductIds2, stmt, 1);
					result = stmt.executeQuery();

					while (result.next()) {
						healthResults.add(getHealthPriceResult(result));
					}
				}
			}

		} catch (SQLException | NamingException e) {
			logger.error("failed to fetch health results" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return healthResults;
	}

	public ArrayList<HealthPriceResult> fetchSavedHealthResults(HealthPriceRequest healthPriceRequest) throws DaoException {

		ArrayList<HealthPriceResult> savedHealthResults = new ArrayList<HealthPriceResult>();
		Date searchDate = new java.sql.Date(healthPriceRequest.getSearchDateValue().getTime());

		try{
			StringBuilder sqlBuilder = new StringBuilder()
					.append("SELECT ")
					.append("search.ProductId, ")
					.append("product.LongTitle, ")
					.append("product.ShortTitle, ")
					.append("product.ProviderId, ")
					.append("product.ProductCat, ")
					.append("product.ProductCode, ")
					.append("search.excessAmount, ");

			if (healthPriceRequest.getPreferences() == null || healthPriceRequest.getPreferences().isEmpty()){
				sqlBuilder
					.append("0 AS rank, ");
			} else {
				sqlBuilder
					.append("(SELECT SUM(value) FROM ctm.product_properties m ")
					.append("WHERE m.productid = search.productid ")
					.append("AND m.propertyid COLLATE latin1_bin IN (")
					.append(questionMarksBuilder(healthPriceRequest.getPreferences().size()))
					.append(") ")
					.append("GROUP BY ProductID) AS rank, ");
			}
				sqlBuilder
					.append("rd.RankPosition, ")
					.append("search.monthlyPremium + (search.monthlyLhc * 10) as factoredPrice, ")
					.append("(? BETWEEN product.EffectiveStart AND product.EffectiveEnd ")
					.append("AND product.Status NOT IN (")
					.append(questionMarksBuilder(healthPriceRequest.getExcludeStatus().size()))
					.append(")) as isValid ")
					.append("FROM ctm.product_properties_search search ")
					.append("INNER JOIN ctm.stylecode_products product ")
					.append("ON search.ProductId = product.ProductId ")
					.append("INNER JOIN aggregator.ranking_details rd ")
					.append("ON (rd.Property = 'productid' AND product.ProductId = rd.Value) ")
					.append("WHERE product.styleCodeId = ? ")
					.append("AND rd.TransactionId = ? ")
					.append("AND rd.CalcSequence = 1 ")
					.append("ORDER BY rd.RankPosition asc ");

			PreparedStatement stmt = dbSource.getConnection().prepareStatement(sqlBuilder.toString());

			int index = 1;

			if (healthPriceRequest.getPreferences() != null || !healthPriceRequest.getPreferences().isEmpty()){
				for(String preference : healthPriceRequest.getPreferences()){
					stmt.setString(index++, preference);
				}
			}

			stmt.setDate(index++, searchDate);

			for(ProductStatus excludeStatus : healthPriceRequest.getExcludeStatus()){
				stmt.setString(index++, excludeStatus.getCode());
			}

			stmt.setInt(index++, healthPriceRequest.getStyleCodeId());
			stmt.setLong(index++, healthPriceRequest.getSavedTransactionId());

			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				HealthPriceResult healthResult = getHealthPriceResult(result);
				boolean isValid = false;
				if (result.getInt("isValid") == 1) {
					isValid = true;
				}
				healthResult.setValid(isValid);
				savedHealthResults.add(healthResult);
			}

		} catch (SQLException | NamingException e) {
			logger.error("failed to fetch saved health results" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return savedHealthResults;
	}

	public HealthPriceResult fetchSingleHealthResult(HealthPriceRequest healthPriceRequest) throws DaoException {
		/*
		 * When searching for a single product ignore the product ID force comparison of excess
		 * amount as insurance against multiple products with the same name (eg NIB).
		 * This may need to be expanded if it turns out that there are other
		 * properties needed to differentiate between common products.
		 */
		HealthPriceResult singleHealthResult = new HealthPriceResult();

		try{
			StringBuilder sqlBuilder = new StringBuilder()
				.append("SELECT results.* FROM ( ")
					.append("SELECT ")
					.append("search.ProductId, ")
					.append("product.LongTitle, ")
					.append("product.ShortTitle, ")
					.append("product.ProviderId, ")
					.append("product.ProductCat, ")
					.append("product.ProductCode, ")
					.append("search.excessAmount, ");
			if (healthPriceRequest.getPreferences() == null || healthPriceRequest.getPreferences().isEmpty()){
				sqlBuilder
					.append("0 AS rank, ");
			} else {
				sqlBuilder
					.append("(SELECT SUM(value) FROM ctm.product_properties m ")
					.append("WHERE m.productid = search.productid ")
					.append("AND m.propertyid COLLATE latin1_bin IN (")
					.append(questionMarksBuilder(healthPriceRequest.getPreferences().size()))
					.append(") ")
					.append("GROUP BY ProductID) AS rank, ");
			}
				sqlBuilder
					.append("search.monthlyPremium + (search.monthlyLhc * ?) as factoredPrice ")
					.append("FROM ctm.product_properties_search search ")
					.append("INNER JOIN ctm.stylecode_products product ON search.ProductId = product.ProductId ");
			if (healthPriceRequest.getPriceMinimum() > 0) {
				sqlBuilder
					.append("INNER JOIN ctm.product_properties_premiums premiums ")
					.append("ON premiums.ProductId = product.ProductId ");
			}
				sqlBuilder
					.append(getFilterLevelOfCover(healthPriceRequest))
					.append("WHERE ")
					.append("? BETWEEN product.EffectiveStart AND product.EffectiveEnd ")
					.append("AND product.Status NOT IN(")
					.append(questionMarksBuilder(healthPriceRequest.getExcludeStatus().size()))
					.append(") ")
					.append("AND (product.ShortTitle = ? OR product.LongTitle = ?) ")
					.append("AND product.styleCodeId = ? ")
					.append("AND (? = 0 OR product.providerId = ?) ")
					.append("AND product.providerId NOT IN(")
					.append(questionMarksBuilder(healthPriceRequest.getExcludedProvidersList().size()))
					.append(") ")
					.append("AND product.productCat = 'HEALTH' ");
			if (healthPriceRequest.getPriceMinimum() > 0) {
				switch(healthPriceRequest.getPaymentFrequency()) {
					case FORTNIGHTLY :
				sqlBuilder
					.append("AND premiums.fortnightlyPremium >= ? ");
						break;
					case ANNUALLY :
				sqlBuilder
					.append("AND premiums.yearlyPremium >= ? ");
						break;
					default :
				sqlBuilder
					.append("AND premiums.monthlyPremium >= ? ");
				}
			}
				sqlBuilder
					.append("AND search.state = ? ")
					.append("AND search.membership = ? ")
					.append("AND search.productType = ? ")
					.append("AND search.excessAmount = ")
					.append(	"(SELECT Value FROM ctm.product_properties ")
					.append(	"WHERE ProductId = ? ")
					.append(	"AND PropertyId = 'excessAmount') ")
					.append( "AND (? = 'Both' OR search.hospitalType = ?) ")
					.append( "GROUP BY search.ProductId ")
					.append( "ORDER BY rank DESC, factoredPrice ASC ")
					.append( "LIMIT 1) results ")
					.append( "GROUP by ProviderID ")
					.append( "ORDER BY rank DESC, factoredPrice ASC ")
					.append( "LIMIT 1 ");

			PreparedStatement stmt = dbSource.getConnection().prepareStatement(sqlBuilder.toString());
			populateParamsToFetchSingle(healthPriceRequest, stmt);
			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				singleHealthResult = getHealthPriceResult(result);
			}

		} catch (SQLException | NamingException e) {
			logger.error("failed to fetch single health result" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return singleHealthResult;
	}

	private String getFetchSQL(HealthPriceRequest healthPriceRequest, List<String> excludedProductIds) {

		StringBuilder sqlBuilder = new StringBuilder()
				.append("SELECT ")
				.append("search.ProductId, ")
				.append("product.LongTitle, ")
				.append("product.ShortTitle, ")
				.append("product.ProviderId, ")
				.append("product.ProductCat, ")
				.append("product.ProductCode, ")
				.append("search.excessAmount, ");
		if (healthPriceRequest.getPreferences() == null || healthPriceRequest.getPreferences().isEmpty()){
			sqlBuilder
				.append("0 AS rank, ");
		} else {
			sqlBuilder
				.append("(SELECT SUM(value) FROM ctm.product_properties m ")
				.append("WHERE m.productid = search.productid ")
				.append("AND m.propertyid COLLATE latin1_bin IN (")
				.append(questionMarksBuilder(healthPriceRequest.getPreferences().size()))
				.append(") ")
				.append("GROUP BY ProductID) AS rank, ");
		}
			sqlBuilder
				.append("search.monthlyPremium + (search.monthlyLhc * ?) as factoredPrice ")
				.append("FROM ctm.product_properties_search search ")
				.append("INNER JOIN ctm.stylecode_products product ON search.ProductId = product.ProductId ");
		if (healthPriceRequest.getPriceMinimum() > 0) {
			sqlBuilder
				.append("INNER JOIN ctm.product_properties_premiums premiums ")
				.append("ON premiums.ProductId = product.ProductId ");
		}
			sqlBuilder
				.append(getFilterLevelOfCover(healthPriceRequest))
				.append("WHERE ")
				.append("? BETWEEN product.EffectiveStart AND product.EffectiveEnd ")
				.append("AND product.Status NOT IN(")
				.append(questionMarksBuilder(healthPriceRequest.getExcludeStatus().size()))
				.append(") ")
				.append("AND product.styleCodeId = ? ")
				.append("AND (? = 0 OR product.providerId = ?) ")
				.append("AND product.providerId NOT IN(")
				.append(questionMarksBuilder(healthPriceRequest.getExcludedProvidersList().size()))
				.append(") ")
				.append("AND product.productCat = 'HEALTH' ");
		if (healthPriceRequest.getPriceMinimum() > 0) {
			switch(healthPriceRequest.getPaymentFrequency()) {
				case FORTNIGHTLY :
			sqlBuilder
				.append("AND premiums.fortnightlyPremium >= ? ");
					break;
				case ANNUALLY :
			sqlBuilder
				.append("AND premiums.yearlyPremium >= ? ");
					break;
				default :
			sqlBuilder
				.append("AND premiums.monthlyPremium >= ? ");
			}
		}
			sqlBuilder
				.append("AND search.state = ? ")
				.append("AND search.membership = ? ")
				.append("AND search.productType = ? ")
				.append("AND search.excessAmount >= ? ")
				.append("AND search.excessAmount <=  ? ")
				.append("AND (? = 'Both' OR search.hospitalType = ?) ");
		if (excludedProductIds != null && excludedProductIds.isEmpty() == false) {
			sqlBuilder
				.append("AND search.ProductId NOT IN (")
				.append(questionMarksBuilder(excludedProductIds.size()))
				.append(", 0) ");
		}
			sqlBuilder
				.append("GROUP BY search.ProductId ")
				.append("ORDER BY rank DESC, factoredPrice ASC ");

		return sqlBuilder.toString();
	}

	private String getFetchSQL(HealthPriceRequest healthPriceRequest, List<String> excludedProductIds, int limit) {
		String sql =
				"SELECT results.* FROM ( "
				+ getFetchSQL(healthPriceRequest, excludedProductIds)
				+ "LIMIT 120) results "
				+ "GROUP BY ProviderID ";

		if (limit > 0) {
			sql += "ORDER BY rank DESC, factoredPrice ASC "
				+  "LIMIT " + limit + " ";
		}
		return sql;
	}

	private HealthPriceResult getHealthPriceResult(ResultSet result) throws SQLException {

		HealthPriceResult healthResult = new HealthPriceResult();

		healthResult.setProductId(result.getString("ProductId"));
		healthResult.setLongTitle(result.getString("LongTitle"));
		healthResult.setShortTitle(result.getString("ShortTitle"));
		healthResult.setProviderId(result.getInt("ProviderId"));
		healthResult.setProductCat(result.getString("ProductCat"));
		healthResult.setProductCode(result.getString("ProductCode"));
		healthResult.setExcessAmount(result.getInt("excessAmount"));
		healthResult.setRank(result.getInt("rank"));

		return healthResult;
	}

	private String questionMarksBuilder(int length) {
		StringBuilder stringBuilder = new StringBuilder();
		for( int i = 0; i< length; i++){
			stringBuilder.append(" ?");
			if(i != length -1) stringBuilder.append(",");
		}
		return stringBuilder.toString();
	}

	private int populateParamsToFetchAll(HealthPriceRequest healthPriceRequest, List<String> excludedProductIds, PreparedStatement stmt) throws SQLException {
		return populateParamsForMainFetch(healthPriceRequest, excludedProductIds, stmt, 1, false);
	}

	private int populateParamsToFetchAll(HealthPriceRequest healthPriceRequest, List<String> excludedProductIds, PreparedStatement stmt, int index) throws SQLException {
		return populateParamsForMainFetch(healthPriceRequest, excludedProductIds, stmt, index, false);
	}

	private int populateParamsToFetchSingle(HealthPriceRequest healthPriceRequest, PreparedStatement stmt) throws SQLException {
		return populateParamsForMainFetch(healthPriceRequest, null, stmt, 1, true);
	}

	private int populateParamsForMainFetch(HealthPriceRequest healthPriceRequest, List<String> excludedProductIds, PreparedStatement stmt, int index, boolean isSingle) throws SQLException {

		Date searchDate = new java.sql.Date(healthPriceRequest.getSearchDateValue().getTime());

		if (healthPriceRequest.getPreferences() != null || !healthPriceRequest.getPreferences().isEmpty()){
			for(String preference : healthPriceRequest.getPreferences()){
				stmt.setString(index++, preference);
			}
		}

		stmt.setDouble(index++, healthPriceRequest.getLoadingPerc());

		if (healthPriceRequest.getTierHospital() > 0) {
			stmt.setInt(index++, healthPriceRequest.getTierHospital());
		}

		if (healthPriceRequest.getTierExtras() > 0) {
			stmt.setInt(index++, healthPriceRequest.getTierExtras());
		}

		stmt.setDate(index++, searchDate);

		for(ProductStatus excludeStatus : healthPriceRequest.getExcludeStatus()){
			stmt.setString(index++, excludeStatus.getCode());
		}

		if(isSingle){
			stmt.setString(index++, healthPriceRequest.getProductTitle());
			stmt.setString(index++, healthPriceRequest.getProductTitle());
		}

		stmt.setInt(index++, healthPriceRequest.getStyleCodeId());
		stmt.setInt(index++, healthPriceRequest.getProviderId());
		stmt.setInt(index++, healthPriceRequest.getProviderId());

		for(int excludedProvider : healthPriceRequest.getExcludedProvidersList()){
			stmt.setInt(index++, excludedProvider);
		}

		if (healthPriceRequest.getPriceMinimum() > 0) {
			stmt.setDouble(index++, healthPriceRequest.getPriceMinimum());
		}

		stmt.setString(index++, healthPriceRequest.getState());
		stmt.setString(index++, healthPriceRequest.getMembership());
		stmt.setString(index++, healthPriceRequest.getProductType());

		if(isSingle){
			stmt.setString(index++, healthPriceRequest.getSelectedProductId());
		}else{
			stmt.setInt(index++, healthPriceRequest.getExcessMin());
			stmt.setInt(index++, healthPriceRequest.getExcessMax());
		}

		stmt.setString(index++, healthPriceRequest.getHospitalSelection());
		stmt.setString(index++, healthPriceRequest.getHospitalSelection());

		if (excludedProductIds != null && !excludedProductIds.isEmpty()) {
			for(String excludedProductId : excludedProductIds){
				stmt.setString(index++, excludedProductId);
			}
		}

		return index;
}

	private String getFilterLevelOfCover(HealthPriceRequest healthPriceRequest) {
		String filterLevelOfCover = "";
		if (healthPriceRequest.getTierHospital() > 0) {
			filterLevelOfCover = " INNER JOIN ctm.product_properties locPP ON search.ProductId = locPP.ProductId "
					+ "AND locPP.PropertyId = 'TierHospital' AND locPP.SequenceNo = 0 "
					+ "AND locPP.Value >= ? ";
		}
		if (healthPriceRequest.getTierExtras() > 0) {
			filterLevelOfCover += " INNER JOIN ctm.product_properties locPPe ON search.ProductId = locPPe.ProductId "
					+ "AND locPPe.PropertyId = 'TierExtras' AND locPPe.SequenceNo = 0 "
					+ "AND locPPe.Value >= ? ";
		}
		return filterLevelOfCover;
	}

	public HealthPriceResult setUpPremiumAndLhc(HealthPriceResult healthPriceResult, boolean isAlt) throws DaoException {
		String productId;
		if (isAlt && healthPriceResult.getAltProductId() != null && !healthPriceResult.getAltProductId().isEmpty()) {
			productId =  healthPriceResult.getAltProductId();
		} else {
			productId = healthPriceResult.getProductId();
		}
		HealthPricePremium pricePremium =  getPremiumAndLhc(productId, healthPriceResult.isDiscountRates());
		if (isAlt) {
			healthPriceResult.setAltHealthPricePremium(pricePremium);
		} else {
			healthPriceResult.setHealthPricePremium(pricePremium);
		}

		return healthPriceResult;
	}


	public HealthPricePremium getPremiumAndLhc(String productId, boolean isDiscountRates) throws DaoException {
		HealthPricePremium pricePremium = new HealthPricePremium();
		try{
			String propName = GROSS_PREFIX;
			if (isDiscountRates){
				propName = DISC_PREFIX;
			}

			StringBuilder sqlBuilder = new StringBuilder()
					.append("SELECT props.value, props.text, props.PropertyId ")
					.append("FROM ctm.product_properties props ")
					.append("WHERE props.productid = ? ")
					.append("AND props.PropertyId in ( ")
					.append("'grossAnnualLhc', ")
					.append("'grossFortnightlyLhc', ")
					.append("'grossMonthlyLhc', ")
					.append("'grossQuarterlyLhc', ")
					.append("'grossWeeklyLhc', ")
					.append("'grossHalfYearlyLhc', ")
					.append("'" + propName + "AnnualPremium', ")
					.append("'" + propName + "FortnightlyPremium', ")
					.append("'" + propName + "MonthlyPremium', ")
					.append("'" + propName + "QuarterlyPremium', ")
					.append("'" + propName + "WeeklyPremium', ")
					.append("'" + propName + "HalfYearlyPremium' ");

			if (isDiscountRates) {
				sqlBuilder
					.append(", ")
					.append("'grossAnnualPremium', ")
					.append("'grossFortnightlyPremium', ")
					.append("'grossMonthlyPremium', ")
					.append("'grossQuarterlyPremium', ")
					.append("'grossWeeklyPremium', ")
					.append("'grossHalfYearlyPremium' ");
			}
				sqlBuilder
					.append(") ")
					.append("ORDER BY props.PropertyId ");

			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(sqlBuilder.toString());
			stmt.setString(1, productId);

			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				String propertyId = result.getString("PropertyId");
				double value = result.getDouble("value");
				populatePremium(propertyId, value, pricePremium, isDiscountRates);
			}

		} catch (SQLException | NamingException e) {
			logger.error("failed to set up premium and Lhc" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return pricePremium;
	}


	private void populatePremium(String propertyId, double value, HealthPricePremium pricePremium, boolean isDiscountRates) {
		switch(propertyId){
			case "grossAnnualLhc":
				pricePremium.setAnnualLhc(value);
				break;
			case  "grossAnnualPremium":
				if (!isDiscountRates){pricePremium.setAnnualPremium(value);}
				pricePremium.setGrossAnnualPremium(value);
				break;
			case "discAnnualPremium":
				pricePremium.setAnnualPremium(value);
				break;
			case "grossFortnightlyLhc":
				pricePremium.setFortnightlyLhc(value);
				break;
			case "grossFortnightlyPremium":
				if (!isDiscountRates){pricePremium.setFortnightlyPremium(value);}
				pricePremium.setGrossFortnightlyPremium(value);
				break;
			case "discFortnightlyPremium":
				pricePremium.setFortnightlyPremium(value);
				break;
			case "grossMonthlyLhc":
				pricePremium.setMonthlyLhc(value);
				break;
			case "grossMonthlyPremium":
				if (!isDiscountRates){pricePremium.setMonthlyPremium(value);}
				pricePremium.setGrossMonthlyPremium(value);
				break;
			case "discMonthlyPremium":
				pricePremium.setMonthlyPremium(value);
				break;
			case "grossQuarterlyLhc":
				pricePremium.setQuarterlyLhc(value);
				break;
			case "grossQuarterlyPremium":
				if (!isDiscountRates){pricePremium.setQuarterlyPremium(value);}
				pricePremium.setGrossQuarterlyPremium(value);
				break;
			case "discQuarterlyPremium":
				pricePremium.setQuarterlyPremium(value);
				break;
			case "grossWeeklyLhc":
				pricePremium.setWeeklyLhc(value);
				break;
			case "grossWeeklyPremium":
				if (!isDiscountRates){pricePremium.setWeeklyPremium(value);}
				pricePremium.setGrossWeeklyPremium(value);
				break;
			case "discWeeklyPremium":
				pricePremium.setWeeklyPremium(value);
				break;
			case "grossHalfYearlyLhc":
				pricePremium.setHalfYearlyLhc(value);
				break;
			case "grossHalfYearlyPremium":
				if (!isDiscountRates){pricePremium.setHalfYearlyPremium(value);}
				pricePremium.setGrossHalfYearlyPremium(value);
				break;
			case "discHalfYearlyPremium":
				pricePremium.setHalfYearlyPremium(value);
				break;
		}
	}

	public HealthPriceResult setUpFundCodeAndName(HealthPriceResult healthPriceResult) throws DaoException {

		try {
			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(
					"SELECT m.Name, p.Text "
					+ "FROM ctm.provider_master m "
					+ "JOIN ctm.provider_properties p ON p.providerId=m.providerId "
					+ "WHERE m.providerId = ? "
					+ "AND p.propertyId = 'FundCode'"
			);
			stmt.setInt(1, healthPriceResult.getProviderId());

			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				healthPriceResult.setFundCode(result.getString("Text"));
				healthPriceResult.setFundName(result.getString("Name"));
			}

		} catch (SQLException | NamingException e) {
			logger.error("failed to set up fundCode and name" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return healthPriceResult;
	}

	public List<String> getDualPricingDisabledFunds() throws DaoException {

		List<String> disableFunds = new ArrayList<String>();

		try {
			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(
					"SELECT Description FROM  aggregator.general "
					+ "WHERE type like 'healthSettings' "
					+ "AND code like 'dual-pricing-disabledfunds'"
			);

			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				for(String fundCode : result.getString("Description").split(",")) {
					if(!fundCode.isEmpty()){
						disableFunds.add(fundCode);
					}
				}
			}

		} catch (SQLException | NamingException e) {
			logger.error("failed to get dual pricing disabled funds" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return disableFunds;
	}

	public HealthPriceResult setUpAltProductId(HealthPriceRequest healthPriceRequest, HealthPriceResult healthPriceResult) throws DaoException {

		Date searchDate = new java.sql.Date(healthPriceRequest.getSearchDateValue().getTime());

		try {
			PreparedStatement stmt;
			/*
			 * When searching for alternate pricing I removed the check the effectiveStart
			 * was after the current date as we're now ordering by effectiveStart DESC and
			 * limiting to 1 record so no need to. This was to ensure we still retained
			 * premium details when the product was not scheduled to expire as soon as
			 * other products and consequently treated as not having a product after a date.
			 *
			 * Also modified so the excessAmount to match exactly with original search.
			 */
			stmt = dbSource.getConnection().prepareStatement(
					"SELECT search.ProductId "
					+ "FROM ctm.product_properties_search search "
					+ "INNER JOIN ctm.product_master product ON search.ProductId = product.ProductId "
					+ "WHERE ( product.EffectiveStart <= DATE_ADD(?, INTERVAL 60 DAY) "
					+ "AND product.EffectiveEnd >= DATE_ADD(?, INTERVAL 60 DAY) "
					+ "AND (product.Status != 'N' AND product.Status != 'X') ) "
					+ "AND product.productCat = 'HEALTH' "
					+ "AND search.state = ? "
					+ "AND search.membership = ? "
					+ "AND search.productType = ? "
					+ "AND search.excessAmount = ? "
					+ "AND (? = 'Both' OR search.hospitalType = ? ) "
					+ "AND product.longTitle = ? "
					+ "AND product.providerId = ? "
					+ "GROUP BY search.ProductId "
					+ "ORDER BY product.effectiveStart DESC "
					+ "LIMIT 1;"
			);
			stmt.setDate(1, searchDate);
			stmt.setDate(2, searchDate);
			stmt.setString(3, healthPriceRequest.getState());
			stmt.setString(4, healthPriceRequest.getMembership());
			stmt.setString(5, healthPriceRequest.getProductType());
			stmt.setInt(6, healthPriceResult.getExcessAmount());
			stmt.setString(7, healthPriceRequest.getHospitalSelection());
			stmt.setString(8, healthPriceRequest.getHospitalSelection());
			stmt.setString(9, healthPriceResult.getLongTitle());
			stmt.setInt(10, healthPriceResult.getProviderId());

			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				healthPriceResult.setAltProductId(result.getString("ProductId"));
			}

		} catch (SQLException | NamingException e) {
			logger.error("failed to set up alt productId" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return healthPriceResult;
	}

	public HealthPriceResult setUpExtraName(HealthPriceResult healthPriceResult) throws DaoException {

		try {
			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(
					"SELECT props.text, props.PropertyId "
					+ "FROM ctm.product_properties props "
					+ "WHERE props.productid = ? "
					+ "AND props.PropertyId = 'extrasCoverName' "
					+ "LIMIT 1"
			);
			stmt.setString(1, healthPriceResult.getProductId());

			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				healthPriceResult.setExtrasName(result.getString("text"));
			}

		} catch (SQLException | NamingException e) {
			logger.error("failed to set up Extra name" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return healthPriceResult;
	}

	public HealthPriceResult setUpHospitalName(HealthPriceResult healthPriceResult) throws DaoException {

		try {
			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(
					"SELECT props.text, props.PropertyId "
					+ "FROM ctm.product_properties props "
					+ "WHERE props.productid = ? "
					+ "AND props.PropertyId = 'hospitalCoverName' "
					+ "LIMIT 1"
			);
			stmt.setString(1, healthPriceResult.getProductId());

			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				healthPriceResult.setHospitalName(result.getString("text"));
			}

		} catch (SQLException | NamingException e) {
			logger.error("failed to set up hospital name" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return healthPriceResult;
	}

	public HealthPriceResult setUpPhioData(HealthPriceResult healthPriceResult) throws DaoException {

		try {
			PreparedStatement stmt;
			stmt = dbSource.getConnection().prepareStatement(
					"SELECT text "
					+ "FROM ctm.product_properties_ext "
					+ "WHERE productid = ? "
					+ "AND type = 'M'"
			);
			stmt.setString(1, healthPriceResult.getProductId());

			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				healthPriceResult.setPhioData(result.getString("text"));
			}

		} catch (SQLException | NamingException e) {
			logger.error("failed to set up phio data" , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return healthPriceResult;
	}

}