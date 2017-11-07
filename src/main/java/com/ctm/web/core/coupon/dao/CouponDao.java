package com.ctm.web.core.coupon.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.coupon.model.Coupon;
import com.ctm.web.core.coupon.model.CouponChannel;
import com.ctm.web.core.coupon.model.CouponOpenHoursCondition;
import com.ctm.web.core.coupon.model.CouponRule;
import com.ctm.web.core.coupon.model.request.CouponRequest;
import com.ctm.web.core.exceptions.DaoException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.coupon.model.CouponOpenHoursCondition.UNRESTRICTED;

@Component
public class CouponDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(CouponDao.class);

	public Coupon getCouponForConfirmation(String transactionId) throws DaoException {
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try{
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"SELECT * " +
				"FROM ctm.coupons " +
				"WHERE couponId IN ( " +
						"SELECT tdCouponId.textValue " +
						"FROM aggregator.transaction_details tdCouponId " +
						"INNER JOIN aggregator.transaction_details tdCouponOptin " +
						"ON tdCouponOptin.transactionId = tdCouponId.transactionId " +
						"WHERE tdCouponId.transactionId = ? " +
						"AND tdCouponId.xpath LIKE '%coupon/id%' " +
						"AND tdCouponOptin.xpath LIKE '%coupon/optin%' " +
						"AND tdCouponOptin.textValue = 'Y' " +
				")"
			);

			stmt.setString(1, transactionId);

			List<Coupon> coupons = mapFieldsFromResultsToCoupon(stmt.executeQuery());

			if(!coupons.isEmpty()){
				return coupons.get(0);
			}

			return new Coupon();

		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	public Coupon getCouponById(CouponRequest couponRequest) throws DaoException{
		return getCouponById(couponRequest.couponId, couponRequest.styleCodeId, couponRequest.verticalId, couponRequest.couponChannel, couponRequest.effectiveDate);
	}

	public Coupon getCouponById(int couponId, int styleCodeId, int verticalId, CouponChannel couponChannel, Date effectiveDate) throws DaoException {
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try{
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					"SELECT * " +
					"FROM ctm.coupons " +
					"WHERE couponId = ? " +
					"AND styleCodeId = ? " +
					"AND verticalId = ? " +
					"AND couponChannel IN (?, '') " +
					"AND ? BETWEEN effectiveStart AND effectiveEnd;"
			);

			stmt.setInt(1, couponId);
			stmt.setInt(2, styleCodeId);
			stmt.setInt(3, verticalId);
			stmt.setString(4, couponChannel.getCode());
			stmt.setTimestamp(5, new Timestamp(effectiveDate.getTime()));

			List<Coupon> coupons = mapFieldsFromResultsToCoupon(stmt.executeQuery());

			if(!coupons.isEmpty()){
				return coupons.get(0);
			}

			return new Coupon();

		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	public Coupon getCouponByCode(CouponRequest couponRequest, Optional<CouponOpenHoursCondition> openHoursCondition) throws DaoException{
		return getCouponByCode(couponRequest.couponCode, couponRequest.styleCodeId, couponRequest.verticalId,
				couponRequest.couponChannel, couponRequest.effectiveDate, openHoursCondition);
	}

	public Coupon getCouponByCode(String couponCode, int styleCodeId, int verticalId, CouponChannel couponChannel,
								  Date effectiveDate, Optional<CouponOpenHoursCondition> openHoursCondition) throws DaoException {
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try{
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"SELECT * " +
				"FROM ctm.coupons " +
				"WHERE couponCode = ? " +
				"AND styleCodeId = ? " +
				"AND verticalId = ? " +
				"AND couponChannel IN (?, '') " +
				"AND ? BETWEEN effectiveStart AND effectiveEnd " +
				"AND openHoursCond IN ('" + UNRESTRICTED.name() + "', ?) " +
				"ORDER BY orderSeq ASC " +
				"LIMIT 1;"
			);

			stmt.setString(1, couponCode);
			stmt.setInt(2, styleCodeId);
			stmt.setInt(3, verticalId);
			stmt.setString(4, couponChannel.getCode());
			stmt.setTimestamp(5, new Timestamp(effectiveDate.getTime()));
			stmt.setString(6, openHoursCondition.map(CouponOpenHoursCondition::name).orElse(""));

			List<Coupon> coupons = mapFieldsFromResultsToCoupon(stmt.executeQuery());

			if(!coupons.isEmpty()){
				return coupons.get(0);
			}

			return new Coupon();

		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	public Coupon getCouponByVdn(CouponRequest couponRequest, Optional<CouponOpenHoursCondition> openHoursCondition) throws DaoException{
		return getCouponByVdn(couponRequest.vdn, couponRequest.styleCodeId, couponRequest.verticalId,
				couponRequest.couponChannel, couponRequest.effectiveDate, openHoursCondition);
	}

	public Coupon getCouponByVdn(String vdn, int styleCodeId, int verticalId, CouponChannel couponChannel,
								 Date effectiveDate, Optional<CouponOpenHoursCondition> openHoursCondition) throws DaoException {
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try{
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"SELECT * " +
				"FROM ctm.coupons " +
				"WHERE vdn = ? " +
				"AND styleCodeId = ? " +
				"AND verticalId = ? " +
				"AND couponChannel IN (?, '') " +
				"AND ? BETWEEN effectiveStart AND effectiveEnd " +
				"AND openHoursCond IN ('" + UNRESTRICTED.name() + "', ?) " +
				"ORDER BY orderSeq ASC " +
				"LIMIT 1;"
			);

			stmt.setString(1, vdn);
			stmt.setInt(2, styleCodeId);
			stmt.setInt(3, verticalId);
			stmt.setString(4, couponChannel.getCode());
			stmt.setTimestamp(5, new Timestamp(effectiveDate.getTime()));
			stmt.setString(6, openHoursCondition.map(CouponOpenHoursCondition::name).orElse(""));

			List<Coupon> coupons = mapFieldsFromResultsToCoupon(stmt.executeQuery());

			if(!coupons.isEmpty()){
				return coupons.get(0);
			}

			return new Coupon();

		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	public List<Coupon> getAvailableCoupons(int styleCodeId, int verticalId, CouponChannel couponChannel, LocalDateTime effectiveDate,
											Optional<CouponOpenHoursCondition> openHoursCondition) throws DaoException {
		final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		try {
			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
				"SELECT * FROM ctm.coupons " +
				"WHERE styleCodeId = ? " +
				"AND verticalId = ? " +
				"AND couponChannel IN (?, '') " +
				"AND ? BETWEEN effectiveStart AND effectiveEnd " +
				"AND openHoursCond IN ('" + UNRESTRICTED.name() + "', ?) " +
				"ORDER BY orderSeq ASC"
			);

			stmt.setInt(1, styleCodeId);
			stmt.setInt(2, verticalId);
			stmt.setString(3, couponChannel.getCode());
			stmt.setTimestamp(4, Timestamp.valueOf(effectiveDate));
			stmt.setString(5, openHoursCondition.map(CouponOpenHoursCondition::name).orElse(""));

			return mapFieldsFromResultsToCoupon(stmt.executeQuery());
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e);
		}
		finally {
			dbSource.closeConnection();
		}
	}

	public void setRulesForCoupon(Coupon coupon) throws DaoException {
		if (coupon.getCouponId() > 0){
			final SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

			try{
				PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					"SELECT * " +
					"FROM ctm.coupon_rules " +
					"WHERE couponId = ? "
				);
				stmt.setInt(1, coupon.getCouponId());

				ResultSet resultSet = stmt.executeQuery();

				List<CouponRule> couponRules = new ArrayList<>();

				while (resultSet.next()) {
					CouponRule couponRule = new CouponRule();
					couponRule.setRuleId(resultSet.getInt("ruleId"));
					couponRule.setCouponId(resultSet.getInt("couponId"));
					couponRule.setXpath(resultSet.getString("xpath"));
					couponRule.setFilterBy(resultSet.getString("filterBy"));
					couponRule.setOption(resultSet.getString("option"));
					couponRule.setValue(resultSet.getString("value"));
					couponRule.setHard(resultSet.getBoolean("isHard"));
					couponRule.setErrorMessage(resultSet.getString("errorMessage"));

					couponRules.add(couponRule);
				}

				coupon.setCouponRules(couponRules);
			}
			catch (SQLException | NamingException e) {
				LOGGER.error("unable to get coupon rules {}", kv("couponId", coupon.getCouponId()), e);
				throw new DaoException(e);
			}
			finally {
				dbSource.closeConnection();
			}
		}
	}

	/**
	 * Internal method to pull the fields from a resultset and put into a Coupon model.
	 * @param results Result set
	 */
	private List<Coupon> mapFieldsFromResultsToCoupon(final ResultSet results) throws SQLException {
		final List<Coupon> coupons = new ArrayList<>();
		while (results.next()) {
			coupons.add(coupon(results));
		}
		return coupons;
	}

	private Coupon coupon(final ResultSet results) throws SQLException {
		final Coupon coupon = new Coupon();

		coupon.setCouponCode(results.getString("couponCode"));
		coupon.setStyleCodeId(results.getInt("styleCodeId"));
		coupon.setVerticalId(results.getInt("verticalId"));
		coupon.setCouponId(results.getInt("couponId"));
		coupon.setCampaignName(results.getString("campaignName"));
		coupon.setCouponValue(results.getDouble("couponValue"));
		coupon.setExclusive(results.getBoolean("isExclusive"));
		coupon.setShowPopup(results.getBoolean("showPopup"));
		coupon.setPrePopulate(results.getBoolean("canPrePopulate"));
        coupon.setContentTile(results.getString("contentTile"));
		coupon.setContentBanner(results.getString("contentBanner"));
		coupon.setContentSuccess(results.getString("contentSuccess"));
		coupon.setContentCheckbox(results.getString("contentCheckbox"));
		coupon.setContentConfirmation(results.getString("contentConfirmation"));
		coupon.setContentWordpress(results.getString("contentWordpress"));
		coupon.setEffectiveStart(results.getDate("effectiveStart"));
		coupon.setEffectiveEnd(results.getDate("effectiveEnd"));
		coupon.setCouponChannel(results.getString("couponChannel"));
		coupon.setOpenHoursCond(CouponOpenHoursCondition.valueOf(results.getString("openHoursCond")));
		coupon.setRemoveFromLeads(results.getBoolean("removeFromLeads"));
		coupon.setVdn(results.getInt("vdn"));
		return coupon;
	}
}
