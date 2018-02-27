package com.ctm.web.simples.admin.dao;

import com.ctm.web.core.dao.DatabaseQueryMapping;
import com.ctm.web.core.dao.DatabaseUpdateMapping;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.utils.common.utils.DateUtils;
import com.ctm.web.health.model.request.CappingLimit;
import com.ctm.web.simples.admin.helper.CappingLimitsHelper;
import com.ctm.web.simples.admin.model.request.CappingLimitDeleteRequest;
import com.ctm.web.simples.admin.model.response.CappingLimitInformation;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class CappingLimitsDao {
    private final SqlDao<CappingLimit> sqlDao = new SqlDao<>();
    private final SqlDao<CappingLimitInformation> cappingLimitInformationDao = new SqlDao<>();

    private final CappingLimitsHelper helper = new CappingLimitsHelper();

    public List<CappingLimitInformation> fetchCappingLimits() throws DaoException {
        DatabaseQueryMapping<CappingLimitInformation> databaseMapping = new DatabaseQueryMapping<CappingLimitInformation>() {

            @Override
            public void mapParams() throws SQLException {
                // no params
            }

            @Override
            public CappingLimitInformation handleResult(ResultSet rs) throws SQLException {
                return helper.createCappingLimitsObject(rs.getInt("ProviderId"),
                        rs.getString("providerName"),
                        rs.getString("PropertyId"),
                        rs.getInt("sequenceNo"),
                        rs.getInt("cappingAmount"),
                        rs.getInt("currentJoinCount"),
                        DateUtils.getUtilDate(rs.getDate("EffectiveStart")),
                        DateUtils.getUtilDate(rs.getDate("EffectiveEnd")),
                        rs.getBoolean("isCurrent"), rs.getString("status"));
            }
        };
        return cappingLimitInformationDao.getList(databaseMapping,
                "SELECT *\n" +
                        "FROM (\n" +
                        "        (SELECT 1 AS isCurrent,\n" +
                        "                pp.providerId,\n" +
                        "                pm.Name AS providerName,\n" +
                        "                pp.PropertyId,\n" +
                        "                sequenceNo,\n" +
                        "                Text AS cappingAmount,\n" +
                        "                if(curDate() BETWEEN pp.EffectiveStart AND pp.EffectiveEnd , IFNULL(sc.currentJoinCount, 0) ,0) AS currentJoinCount ,\n" +
                        "                pp.effectiveStart,\n" +
                        "                pp.effectiveEnd,\n" +
                        "                pp.Status\n" +
                        "         FROM ctm.provider_properties pp\n" +
                        "         LEFT JOIN\n" +
                        "           (SELECT 'MonthlyLimit' AS PropertyId,\n" +
                        "                   msc.currentJoinCount,\n" +
                        "                   msc.providerId\n" +
                        "            FROM ctm.vw_monthlySalesCount msc\n" +
                        "            UNION ALL SELECT 'DailyLimit' AS PropertyId,\n" +
                        "                             dsc.currentJoinCount,\n" +
                        "                             dsc.providerId\n" +
                        "            FROM ctm.vw_dailySalesCount dsc) AS sc ON pp.EffectiveEnd >= curDate()\n" +
                        "         AND sc.providerId = pp.ProviderId\n" +
                        "         AND sc.PropertyId = pp.PropertyId\n" +
                        "         INNER JOIN ctm.provider_master pm ON pm.ProviderId = pp.ProviderId\n" +
                        "         WHERE pp.propertyId IN ('DailyLimit',\n" +
                        "                                 'MonthlyLimit')\n" +
                        "           AND pp.EffectiveEnd >= curDate())\n" +
                        "      UNION ALL\n" +
                        "        (SELECT 0 AS isCurrent,\n" +
                        "                pp.ProviderId,\n" +
                        "                pm.Name AS providerName,\n" +
                        "                pp.PropertyId,\n" +
                        "                sequenceNo,\n" +
                        "                Text AS cappingAmount,\n" +
                        "                0 AS currentJoinCount,\n" +
                        "                pp.EffectiveStart,\n" +
                        "                pp.EffectiveEnd,\n" +
                        "                pp.Status\n" +
                        "         FROM ctm.provider_properties pp\n" +
                        "         INNER JOIN ctm.provider_master pm ON pm.providerID = pp.providerID\n" +
                        "         WHERE pp.propertyId IN ('DailyLimit',\n" +
                        "                                 'MonthlyLimit')\n" +
                        "           AND pp.EffectiveStart > DATE_ADD(NOW(), INTERVAL -15 MONTH)\n" +
                        "           AND pp.EffectiveEnd <= curDate())) capped_data\n" +
                        "ORDER BY capped_data.isCurrent DESC,\n" +
                        "         capped_data.providerName,\n" +
                        "         capped_data.effectiveEnd DESC;");

    }

    public CappingLimitInformation fetchCappingInformation(final CappingLimit cappingLimit) throws DaoException {
        DatabaseQueryMapping<CappingLimitInformation> databaseMapping = new DatabaseQueryMapping<CappingLimitInformation>() {

            @Override
            public void mapParams() throws SQLException {
                set(cappingLimit.getProviderId());
                set(cappingLimit.getLimitType().text);
                set(cappingLimit.getSequenceNo());
            }

            @Override
            public CappingLimitInformation handleResult(ResultSet rs) throws SQLException {
                return helper.createCappingLimitsObject(rs.getInt("ProviderId"),
                        rs.getString("providerName"),
                        rs.getString("PropertyId"),
                        rs.getInt("sequenceNo"),
                        rs.getInt("cappingAmount"),
                        rs.getInt("currentJoinCount"),
                        DateUtils.getUtilDate(rs.getDate("EffectiveStart")),
                        DateUtils.getUtilDate(rs.getDate("EffectiveEnd")),
                        rs.getBoolean("isCurrent"), rs.getString("status"));
            }
        };
        return cappingLimitInformationDao.get(databaseMapping,
                "SELECT  \n" +
                        "pp.EffectiveEnd >= curDate() as isCurrent , \n" +
                        "pp.ProviderId, \n" +
                        "pm.Name as providerName,\n" +
                        "pp.PropertyId, sequenceNo , \n" +
                        "Text as cappingAmount,\n" +
                        " if(curDate() between pp.EffectiveStart and pp.EffectiveEnd , IFNULL(sc.currentJoinCount, 0) ,0 ) as currentJoinCount,\n" +
                        "pp.EffectiveStart, \n" +
                        "pp.EffectiveEnd,\n" +
                        "pp.status " +
                        "FROM ctm.provider_properties pp\n" +
                        "LEFT JOIN \n" +
                        "(\n" +
                        "\tSELECT 'MonthlyLimit' as PropertyId, \n" +
                        "\tmsc.currentJoinCount,\n" +
                        "\tmsc.ProviderId FROM ctm.vw_monthlySalesCount msc\n" +
                        "\tUNION ALL \n" +
                        "\tSELECT 'DailyLimit' as PropertyId, \n" +
                        "\tdsc.currentJoinCount,\n" +
                        "\tdsc.ProviderId FROM ctm.vw_dailySalesCount dsc\n" +
                        ") as sc\n" +
                        "ON pp.EffectiveEnd >= curDate() \n" +
                        "AND sc.ProviderId = pp.ProviderId\n" +
                        "AND  sc.PropertyId = pp.PropertyId\n" +
                        "INNER JOIN ctm.provider_master pm\n" +
                        "ON pm.providerID = pp.providerID " +
                        " WHERE " +
                        "pp.ProviderId= ? " +
                        "AND pp.PropertyId = ? " +
                        "AND pp.SequenceNo = ?;");
    }

    /**
     * This method will delete record associated with supplied ID
     */
    public String deleteCappingLimits(final CappingLimitDeleteRequest cappingLimit) throws DaoException {
        DatabaseUpdateMapping databaseMapping = new DatabaseUpdateMapping() {
            @Override
            public void mapParams() throws SQLException {
                set(cappingLimit.getProviderId());
                set(cappingLimit.getLimitType().text);
                set(cappingLimit.getSequenceNo());
            }

            @Override
            public String getStatement() {
                return "DELETE FROM " +
                        "`ctm`.`provider_properties` " +
                        " WHERE \n" +
                        "ProviderId = ? \n" +
                        "AND PropertyId = ? \n" +
                        "AND sequenceNo = ?;";
            }
        };
        return sqlDao.update(databaseMapping) > 0 ? "success" : "fail";
    }

    /**
     * This method will update the record and
     *
     * @return CappingLimitInformation which includes the latest capping counts
     */
    public CappingLimit updateCappingLimits(final CappingLimit cappingLimit) throws DaoException {
        DatabaseUpdateMapping databaseMapping = new DatabaseUpdateMapping() {
            @Override
            public void mapParams() throws SQLException {
                set(cappingLimit.getCappingAmount());
                set(cappingLimit.getEffectiveStart());
                set(cappingLimit.getEffectiveEnd());
                set(cappingLimit.getCappingLimitCategory());
                set(cappingLimit.getProviderId());
                set(cappingLimit.getLimitType().text);
                set(cappingLimit.getSequenceNo());
            }

            @Override
            public String getStatement() {
                return "UPDATE ctm.provider_properties " +
                        "set  " +
                        "Text = ?, " +
                        "EffectiveStart=?, " +
                        "EffectiveEnd = ? ," +
                        "status = ?" +
                        " WHERE ProviderId= ? " +
                        "AND PropertyId = ? " +
                        "AND SequenceNo = ? ";
            }
        };
        sqlDao.update(databaseMapping);

        return cappingLimit;
    }

    /**
     * This method will create new record in the table and also returns the
     *
     * @return CappingLimitInformation which includes the latest capping counts and sequence no
     */
    public CappingLimit createCappingLimits(final CappingLimit cappingLimit) throws DaoException {
        cappingLimit.setSequenceNo(getSequenceNumber(cappingLimit));

        sqlDao.update(getDatabaseUpdateMapping(cappingLimit, "INSERT INTO `ctm`.`provider_properties`\n" +
                "(`ProviderId`,\n" +
                "`PropertyId`,\n" +
                "`SequenceNo`,\n" +
                "`Text`,\n" +
                "`EffectiveStart`,\n" +
                "`EffectiveEnd`,\n" +
                "`Status`)\n" +
                "VALUES\n" +
                "(?,\n" +
                "?,\n" +
                "?,\n" +
                "?,\n" +
                "?,\n" +
                "?,\n" +
                "?);"));

        return cappingLimit;
    }

    private Integer getSequenceNumber(final CappingLimit cappingLimit) throws DaoException {
        SqlDao<Integer> intDao = new SqlDao<>();
        DatabaseQueryMapping<Integer> databaseMapping = new DatabaseQueryMapping<Integer>() {

            @Override
            public void mapParams() throws SQLException {
                set(cappingLimit.getProviderId());
                set(cappingLimit.getLimitType().text);
            }

            @Override
            public Integer handleResult(ResultSet rs) throws SQLException {
                return rs.getInt("sequenceNo");
            }
        };
        return intDao.get(databaseMapping,
                "SELECT max(sequenceNo) + 1 as sequenceNo \n" +
                        "FROM ctm.provider_properties " +
                        " WHERE ProviderId = ? \n" +
                        "AND PropertyId = ? ");
    }

    private DatabaseUpdateMapping getDatabaseUpdateMapping(final CappingLimit cappingLimit, final String statement) {
        return new DatabaseUpdateMapping() {
            @Override
            public void mapParams() throws SQLException {
                set(cappingLimit.getProviderId());
                set(cappingLimit.getLimitType().text);
                if (cappingLimit.getSequenceNo() != null) {
                    set(cappingLimit.getSequenceNo());
                }
                set(cappingLimit.getCappingAmount());
                set(cappingLimit.getEffectiveStart());
                set(cappingLimit.getEffectiveEnd());
                set(cappingLimit.getCappingLimitCategory());
            }

            @Override
            public String getStatement() {
                return statement;
            }
        };
    }


    public List<CappingLimit> fetchCappingLimits(final CappingLimit cappingLimit) throws DaoException {
        DatabaseQueryMapping<CappingLimit> databaseMapping = new DatabaseQueryMapping<CappingLimit>() {

            @Override
            public void mapParams() throws SQLException {
                set(cappingLimit.getProviderId());
                set(cappingLimit.getLimitType().text);
                set(cappingLimit.getEffectiveStart());
                set(cappingLimit.getEffectiveEnd());
            }

            @Override
            public CappingLimit handleResult(ResultSet rs) throws SQLException {
                return helper.createCappingLimitsObject(rs.getInt("ProviderId"),
                        rs.getString("PropertyId"),
                        rs.getInt("sequenceNo"),
                        rs.getInt("cappingAmount"),
                        DateUtils.getUtilDate(rs.getDate("EffectiveStart")),
                        DateUtils.getUtilDate(rs.getDate("EffectiveEnd")));
            }
        };
        return sqlDao.getList(databaseMapping,
                "SELECT " +
                        "pp.ProviderId, " +
                        "pp.PropertyId, " +
                        "sequenceNo, " +
                        "Text as cappingAmount, " +
                        "pp.EffectiveStart, " +
                        "pp.EffectiveEnd " +
                        "FROM ctm.provider_properties pp " +
                        "WHERE " +
                        "pp.ProviderId = ? " +
                        "AND PropertyId = ? " +
                        "AND ( ? Between pp.EffectiveStart AND pp.EffectiveEnd " +
                        "OR  ? Between pp.EffectiveStart AND pp.EffectiveEnd )");
    }

    public List<CappingLimit> fetchCappingLimitsWithMatchingFields(final CappingLimit cappingLimit) throws DaoException {
        DatabaseQueryMapping<CappingLimit> databaseMapping = new DatabaseQueryMapping<CappingLimit>() {

            @Override
            public void mapParams() throws SQLException {
                set(cappingLimit.getProviderId());
                set(cappingLimit.getLimitType().text);
                set(cappingLimit.getSequenceNo());
                set(cappingLimit.getEffectiveStart());
                set(cappingLimit.getEffectiveEnd());
            }

            @Override
            public CappingLimit handleResult(ResultSet rs) throws SQLException {
                return helper.createCappingLimitsObject(rs.getInt("ProviderId"),
                        rs.getString("PropertyId"),
                        rs.getInt("sequenceNo"),
                        rs.getInt("cappingAmount"),
                        DateUtils.getUtilDate(rs.getDate("EffectiveStart")),
                        DateUtils.getUtilDate(rs.getDate("EffectiveEnd")));
            }
        };
        return sqlDao.getList(databaseMapping,
                "SELECT  \n" +
                        "pp.ProviderId, \n" +
                        "pp.PropertyId, sequenceNo , \n" +
                        "Text as cappingAmount,\n" +
                        "pp.EffectiveStart, \n" +
                        "pp.EffectiveEnd\n" +
                        "FROM ctm.provider_properties pp " +
                        " WHERE pp.ProviderId = ? " +
                        "AND PropertyId = ? " +
                        "AND pp.sequenceNo != ? " +
                        "AND ( ? Between pp.EffectiveStart AND pp.EffectiveEnd " +
                        "OR  ? Between pp.EffectiveStart AND pp.EffectiveEnd ) " +
                        "");
    }
}
