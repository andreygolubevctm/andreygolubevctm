package com.ctm.dao.health;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import org.apache.commons.lang3.StringUtils;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthPricePremiumRange;
import com.ctm.model.health.HealthPriceRequest;

public class HealthPriceDao {

	public HealthPricePremiumRange getHealthPricePremiumRange(
			HealthPriceRequest healthPriceRequest) throws DaoException {
		HealthPricePremiumRange healthPricePremiumRange = new HealthPricePremiumRange();


		Date searchDate = new java.sql.Date(healthPriceRequest
				.getSearchDateValue().getTime());

		SimpleDatabaseConnection dbSource = null;
		try {

			List<String> excludedProvidersParams = new ArrayList<String>();
			List<Integer> excludedProvidersList = healthPriceRequest.getExcludedProvidersList();
			for (int i = 0; i < excludedProvidersList.size(); i++) {
				excludedProvidersParams.add("?");
			}

			String excludedProvidersSql = StringUtils.join(excludedProvidersParams, ",");

			dbSource = new SimpleDatabaseConnection();
			String sql =
					"SELECT "
					+ "MIN(NULLIF(premiums.yearlyPremium, 0)) minYearlyPremium,  "
					+ "Max(premiums.yearlyPremium) maxYearlyPremium,  "
					+ "MIN(NULLIF(premiums.fortnightlyPremium, 0)) as minFortnightlyPremium,  "
					+ "Max(premiums.fortnightlyPremium) as maxFortnightlyPremium,  "
					+ "MIN(NULLIF(premiums.monthlyPremium, 0)) as minMonthlyPremium,  "
					+ "MAX(premiums.monthlyPremium) as maxMonthlyPremium  "
					+ "FROM ( "
					+ "SELECT "
					+ "search.ProductId "
					+ "FROM ctm.product_properties_search search "
					+ "INNER JOIN ctm.stylecode_products product ON search.ProductId = product.ProductId ";
					if (healthPriceRequest.getTierHospital() > 0) {
						sql += "INNER JOIN ctm.product_properties locPP ON search.ProductId = locPP.ProductId "
								+ "AND locPP.PropertyId = 'TierHospital' AND locPP.SequenceNo = 0 "
								+ "AND locPP.Value >=  ? ";
					}
					if (healthPriceRequest.getTierExtras() > 0) {
						sql += "INNER JOIN ctm.product_properties locPPe ON search.ProductId = locPPe.ProductId "
								+ "AND locPPe.PropertyId = 'TierExtras' AND locPPe.SequenceNo = 0 "
								+ "AND locPPe.Value >= ? ";
					}
					sql += "WHERE "
					+ "(? BETWEEN product.EffectiveStart AND product.EffectiveEnd "
					+ "	AND product.Status NOT IN("
					+ healthPriceRequest.getExcludeStatus() + ") " + ") "
					+ "AND ( " + "	product.styleCodeId = ? " + ") ";
				if (healthPriceRequest.getProviderId() != 0) {
					sql += "AND product.providerId = ? ";
				}
			sql += "AND product.providerId NOT IN("
					+ excludedProvidersSql
					+ ") "
					+ "AND product.productCat = 'HEALTH' "
					+ "AND search.state = ? "
					+ "AND search.membership = ? "
					+ "AND search.productType = ? "
					+ "AND search.excessAmount >= ? and search.excessAmount <=  ? ";
			if (!healthPriceRequest.getHospitalSelection().equals("BOTH")) {
				sql += "AND search.hospitalType = ? ";
			}
			sql += " " + "GROUP BY search.ProductId " + ") as results "
					+ "INNER JOIN ctm.product_properties_premiums premiums "
					+ "ON premiums.productID = results.productID;";

			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					sql);

			int i = 1;

			if (healthPriceRequest.getTierHospital() > 0) {
				stmt.setInt(i++, healthPriceRequest.getTierHospital());
			}
			if (healthPriceRequest.getTierExtras() > 0) {
				stmt.setInt(i++, healthPriceRequest.getTierExtras());
			}

			stmt.setDate(i++, searchDate);
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

		} catch (SQLException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}
		return healthPricePremiumRange;
	}

	public String getFilterLevelOfCover(HealthPriceRequest healthPriceRequest) {
		String filterLevelOfCover = "";
		if (healthPriceRequest.getTierHospital() > 0) {
			filterLevelOfCover = " INNER JOIN ctm.product_properties locPP ON search.ProductId = locPP.ProductId "
					+ "AND locPP.PropertyId = 'TierHospital' AND locPP.SequenceNo = 0 "
					+ "AND locPP.Value >= " + healthPriceRequest.getTierHospital() + " ";
		}
		if (healthPriceRequest.getTierExtras() > 0) {
			filterLevelOfCover += " INNER JOIN ctm.product_properties locPPe ON search.ProductId = locPPe.ProductId "
					+ "AND locPPe.PropertyId = 'TierExtras' AND locPPe.SequenceNo = 0 "
					+ "AND locPPe.Value >= "
					+ healthPriceRequest.getTierExtras() + " ";
		}
		return filterLevelOfCover;
	}

}
