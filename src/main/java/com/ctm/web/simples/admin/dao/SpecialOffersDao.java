package com.ctm.web.simples.admin.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.dao.AuditTableDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.utils.common.utils.DateUtils;
import com.ctm.web.simples.admin.model.SpecialOffers;
import com.ctm.web.simples.helper.SpecialOffersHelper;
import com.mysql.jdbc.Statement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class SpecialOffersDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(SpecialOffersDao.class);
    private final SpecialOffersHelper helper = new SpecialOffersHelper();
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    private final AuditTableDao auditTableDao = new AuditTableDao();
    private static boolean autoCommit = true;


    /**
     * this method will return single record if ID exist else return null
     *
     * @param offerId : Unique identifier for special offers record
     */
    private SpecialOffers fetchSingleRecSpecialOffers(int offerId) throws DaoException {
        SpecialOffers specialOffers;
        List<SpecialOffers> specialOffersList = fetchSpecialOffers(offerId);
        specialOffers = specialOffersList.isEmpty() ? null : specialOffersList.get(0);
        return specialOffers;
    }

    /**
     * this method will fetch all the special offers record from database
     *
     * @param offerId : if 0 return all results else return the specific one
     */
    public List<SpecialOffers> fetchSpecialOffers(int offerId) throws DaoException {
        SimpleDatabaseConnection dbSource;
        List<SpecialOffers> specialOffersList = new ArrayList<>();
        PreparedStatement stmt;
        dbSource = new SimpleDatabaseConnection();
        try {
            StringBuilder sql = new StringBuilder(
                    "SELECT offerId,content, terms,so.providerId,  so.effectiveStart, so.effectiveEnd," +
                            "so.styleCodeId,state,so.coverType, sc.styleCodeName ,pm.Name providerName, so.offerType  " +
                            "from ctm.hlt_specialoffer_master so inner join stylecodes sc on so.styleCodeId = sc.styleCodeId " +
                            "inner join provider_master pm on pm.ProviderId = so.providerId");
            if (offerId != 0) {
                sql.append(" where offerId = ?  ");
            }

            sql.append(" ORDER BY providerName, so.styleCodeId, so.state, so.coverType, so.effectiveStart, so.effectiveEnd");

            stmt = dbSource.getConnection().prepareStatement(sql.toString());
            if (offerId != 0) {
                stmt.setInt(1, offerId);
            }
            ResultSet resultSet = stmt.executeQuery();
            while (resultSet.next()) {
                SpecialOffers specialOffers = helper.createSpecialOffersObject(
                        resultSet.getInt("offerId"),
                        resultSet.getString("content"),
                        resultSet.getString("terms"),
                        resultSet.getDate("effectiveEnd") != null ? sdf.format(resultSet.getDate("effectiveEnd")) : "",
                        resultSet.getDate("effectiveStart") != null ? sdf.format(resultSet.getDate("effectiveStart")) : "",
                        resultSet.getInt("providerId"),
                        resultSet.getInt("styleCodeId"),
                        resultSet.getString("state"),
                        resultSet.getString("coverType"),
                        resultSet.getString("styleCodeName"),
                        resultSet.getString("providerName"),
                        resultSet.getString("offerType")
                    );
                specialOffersList.add(specialOffers);
            }
            return specialOffersList;
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to retrieve Special Offers {}", kv("offerId", offerId), e);
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
    }

    /**
     * this method will fetch all the special offers record from database
     *
     * @param providerId      : fund ID
     * @param styleCodeId     : brand code id , function also look for default '0' value
     * @param applicationDate : Current date
     * @param state           : name of state (i.e QLD), function also search for default value '0'
     * @param coverType       : type of Cover (i.e C for Combined, H for Hospital, E for Extras), function also search for default value '0'
     * @param verticalId      : vertical ID
     */
    public List<SpecialOffers> getSpecialOffers(int providerId, int styleCodeId, Date applicationDate, String state, String coverType, int verticalId) throws DaoException {
        SimpleDatabaseConnection dbSource;
        List<SpecialOffers> specialOffersList = new ArrayList<>();
        PreparedStatement stmt;
        dbSource = new SimpleDatabaseConnection();
        try {
            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT content, terms FROM ctm.hlt_specialoffer_master WHERE providerId=? AND  (styleCodeId=?  OR styleCodeId = 0) " +
                            "AND (state=? OR state='0') AND (coverType=? OR coverType='0') AND ? BETWEEN effectiveStart AND effectiveEnd order by state DESC limit 1");
            stmt.setInt(1, providerId);
            stmt.setInt(2, styleCodeId);
            stmt.setString(3, state.trim().toUpperCase());
            stmt.setString(4, coverType.trim().toUpperCase());
            stmt.setTimestamp(5, new java.sql.Timestamp(applicationDate.getTime()));
            ResultSet resultSet = stmt.executeQuery();
            while (resultSet.next()) {
                SpecialOffers specialOffers = helper.createSpecialOffersObject(0,
                        resultSet.getString("content"), resultSet.getString("terms"), null, null, 0, 0, null, null, null, null, null);
                specialOffersList.add(specialOffers);
            }
            return specialOffersList;
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to retrieve Special Offers {}, {}, {}, {}, {}", kv("providerId", providerId), kv("styleCodeId",
                styleCodeId), kv("applicationDate", applicationDate), kv("state", state), kv("coverType", coverType), kv("verticalId", verticalId), e);
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
    }

    /**
     * This method will delete record associated with supplied ID
     *
     * @param offerId    : Unique identifier for special offers record
     * @param serverDate : Date on server
     * @param userName   : userName of the user who has logged in during the session
     */
    public String deleteSpecialOffers(String offerId, Date serverDate, String userName, String ipAddress) throws DaoException {
        SimpleDatabaseConnection dbSource;
        PreparedStatement stmt;
        dbSource = new SimpleDatabaseConnection();
        try {

            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);
            if (offerId == null || offerId.trim().equalsIgnoreCase("")) {
                return "OfferId is blank";
            }
            SpecialOffers offer = fetchSingleRecSpecialOffers(Integer.parseInt(offerId.trim()));
            if (offer == null) {
                return "Offer doesn't exist with id : " + offerId;
            }
            if (DateUtils.isDateInRange(serverDate, sdf.parse(offer.getEffectiveStart()), sdf.parse(offer.getEffectiveEnd()))) {
                return "Can not delete this offer as Start date of the offer has already been commenced";
            }
            auditTableDao.auditAction("hlt_specialoffer_master", "offerId", Integer.parseInt(offerId.trim()), userName, ipAddress, AuditTableDao.DELETE, dbSource.getConnection());

            stmt = dbSource.getConnection().prepareStatement("DELETE FROM ctm.hlt_specialoffer_master WHERE offerId = ?");
            stmt.setInt(1, Integer.parseInt(offerId.trim()));
            stmt.executeUpdate();
            dbSource.getConnection().commit();
            return "success";
        } catch (SQLException | NamingException | ParseException e) {
            LOGGER.error("Failed to delete Special Offers {}, {}, {}, {}", kv("offerId", offerId), kv("serverDate", serverDate), kv("userName", userName), kv("ipAddress", ipAddress), e);
            rollbackTransaction(dbSource);
            throw new DaoException(e);
        } finally {
            resetDefaultsAndCloseConnection(dbSource);
        }
    }

    /**
     * This method will update record
     *
     * @param userName            : userName of the user who has logged in during the session
     * @param specialOffersParams : Special offers object
     */
    public SpecialOffers updateSpecialOffers(SpecialOffers specialOffersParams, String userName, String ipAddress) throws DaoException {
        SpecialOffers specialOffers = new SpecialOffers();
        SimpleDatabaseConnection dbSource;
        int offerId;
        PreparedStatement stmt = null;
        dbSource = new SimpleDatabaseConnection();
        try {
            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);
            java.sql.Timestamp startDate = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(specialOffersParams.getEffectiveStart()), 0, 0, 1).getTime());
            java.sql.Timestamp endDate = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(specialOffersParams.getEffectiveEnd()), 23, 59, 59).getTime());
            offerId = specialOffersParams.getOfferId();
            if (offerId == 0) {
                throw new DaoException("failed : offerId is null");
            }
            stmt = dbSource.getConnection().prepareStatement(" UPDATE ctm.hlt_specialoffer_master SET  " +
                    "content = ?,terms=?, providerId = ?,effectiveStart = ?, effectiveEnd = ?,styleCodeId=?,state=?,coverType=?,offerType=? " +
                    " WHERE offerId= ?");
            if (specialOffersParams.getContent() != null && !specialOffersParams.getContent().equals(""))
                stmt.setString(1, specialOffersParams.getContent());
            else
                stmt.setNull(1, Types.NULL);
            if (specialOffersParams.getTerms() != null && !specialOffersParams.getTerms().equals(""))
                stmt.setString(2, specialOffersParams.getTerms());
            else
                stmt.setNull(2, Types.NULL);
            stmt.setInt(3, specialOffersParams.getProviderId());
            stmt.setTimestamp(4, startDate);
            stmt.setTimestamp(5, endDate);
            stmt.setInt(6, specialOffersParams.getStyleCodeId());
            stmt.setString(7, specialOffersParams.getState().toUpperCase());
            stmt.setString(8, specialOffersParams.getCoverType().toUpperCase());
            stmt.setString(9,specialOffersParams.getOfferType());
            stmt.setInt(10, offerId);
            stmt.executeUpdate();
            auditTableDao.auditAction("hlt_specialoffer_master", "offerId", offerId, userName, ipAddress, AuditTableDao.UPDATE, dbSource.getConnection());
            // Commit these records to the DB before fetching them
            dbSource.getConnection().commit();
            specialOffers = fetchSingleRecSpecialOffers(offerId);
        } catch (SQLException | NamingException | ParseException e) {
            LOGGER.error("Failed to update Special Offers {}, {}, {}", kv("specialOffersParams", specialOffersParams), kv("userName", userName), kv("ipAddress", ipAddress), e);
            rollbackTransaction(dbSource);
            throw new DaoException(e);
        } finally {
            resetDefaultsAndCloseConnection(dbSource);
        }
        return specialOffers;
    }


    /**
     * This method will create new record in the table and also returns the
     * created record in the object
     *
     * @param specialOffersParams : Special offers object
     * @param userName            : userName of the user who has logged in during the session
     */
    public SpecialOffers createSpecialOffers(SpecialOffers specialOffersParams, String userName, String ipAddress) throws DaoException {
        SpecialOffers specialOffers = new SpecialOffers();
        SimpleDatabaseConnection dbSource;
        int offerId = 0;
        dbSource = new SimpleDatabaseConnection();
        PreparedStatement stmt;
        try {

            autoCommit = dbSource.getConnection().getAutoCommit();
            dbSource.getConnection().setAutoCommit(false);
            java.sql.Timestamp startDate = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(specialOffersParams.getEffectiveStart()), 0, 0, 1).getTime());
            java.sql.Timestamp endDate = new java.sql.Timestamp(DateUtils.setTimeInDate(sdf.parse(specialOffersParams.getEffectiveEnd()), 23, 59, 59).getTime());

            stmt = dbSource.getConnection().prepareStatement(
                    " INSERT INTO ctm.hlt_specialoffer_master " +
                            "( content, terms,providerId,  effectiveStart, effectiveEnd,styleCodeId,state,coverType,offerType ) VALUES " +
                            "(?,?,?,?,?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);
            if (specialOffersParams.getContent() != null && !specialOffersParams.getContent().equals(""))
                stmt.setString(1, specialOffersParams.getContent());
            else
                stmt.setNull(1, Types.NULL);
            if (specialOffersParams.getTerms() != null && !specialOffersParams.getTerms().equals(""))
                stmt.setString(2, specialOffersParams.getTerms());
            else
                stmt.setNull(2, Types.NULL);
            stmt.setInt(3, specialOffersParams.getProviderId());
            stmt.setTimestamp(4, startDate);
            stmt.setTimestamp(5, endDate);
            stmt.setInt(6, specialOffersParams.getStyleCodeId());
            stmt.setString(7, specialOffersParams.getState());
            stmt.setString(8, specialOffersParams.getCoverType());
            stmt.setString(9, specialOffersParams.getOfferType());
            stmt.executeUpdate();
            ResultSet rsKey = stmt.getGeneratedKeys();
            if (rsKey.next()) {
                offerId = rsKey.getInt(1);
            }
            auditTableDao.auditAction("hlt_specialoffer_master", "offerId", offerId, userName, ipAddress, AuditTableDao.CREATE, dbSource.getConnection());
            // Commit these records to the DB before fetching them
            dbSource.getConnection().commit();
            specialOffers = fetchSingleRecSpecialOffers(offerId);
        } catch (SQLException | NamingException | ParseException e) {
            LOGGER.error("Failed to create Special Offers {}, {}, {}", kv("specialOffersParams", specialOffersParams), kv("userName", userName), kv("ipAddress", ipAddress), e);
            rollbackTransaction(dbSource);
            throw new DaoException(e);
        } finally {
            resetDefaultsAndCloseConnection(dbSource);
        }
        return specialOffers;
    }
    /**
     * This method will roleback the changes made via connection in supplied SimpleDatabaseConnection
     * @param dbSource
     * @throws DaoException
     */
    private void rollbackTransaction(SimpleDatabaseConnection dbSource) throws DaoException {
        try {
            LOGGER.error("Transaction is being rolled back");
            dbSource.getConnection().rollback();
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
    }

    /**
     * This method will reset autocommit option to the default value and also commit changes and close the connection
     * @param dbSource
     * @throws DaoException
     */
    private void resetDefaultsAndCloseConnection(SimpleDatabaseConnection dbSource) throws DaoException {
        try {
            dbSource.getConnection().commit();
            dbSource.getConnection().setAutoCommit(autoCommit);
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
        dbSource.closeConnection();
    }
}
