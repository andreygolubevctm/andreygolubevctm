package com.ctm.dao.simples;

import com.ctm.dao.DatabaseQueryMapping;
import com.ctm.dao.DatabaseUpdateMapping;
import com.ctm.dao.SqlDao;
import com.ctm.exceptions.DaoException;
import com.ctm.helper.simples.CappingLimitsHelper;
import com.ctm.model.request.CappingLimitDeleteRequest;
import com.ctm.model.request.health.CappingLimit;
import com.ctm.model.response.CappingLimitInformation;
import com.ctm.utils.common.utils.DateUtils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class CappingLimitsDao {
	SqlDao<CappingLimit> sqlDao = new SqlDao<>();
	SqlDao<CappingLimitInformation> cappingLimitInformationDao = new SqlDao<>();

	CappingLimitsHelper helper = new CappingLimitsHelper();

	public List<CappingLimitInformation> fetchCappingLimits() throws DaoException {
		DatabaseQueryMapping<CappingLimitInformation> databaseMapping= new DatabaseQueryMapping<CappingLimitInformation>(){

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
						rs.getBoolean("isCurrent"));
			}
		};
		return cappingLimitInformationDao.getList(databaseMapping,
				"(SELECT " +
						"1 as isCurrent, " +
						"pp.ProviderId,\n" +
						"\t\t\t\tpm.Name as providerName,\n" +
						"\t\tpp.PropertyId, sequenceNo ,\n" +
						"\t\t\t\tText as cappingAmount,\n" +
						"\t\tIFNULL(sc.currentJoinCount, 0) as currentJoinCount,\n" +
						"\t\tpp.EffectiveStart,\n" +
						"\t\t\t\tpp.EffectiveEnd\n" +
						"\t\tFROM ctm.provider_properties pp\n" +
						"\t\tLEFT JOIN\n" +
						"\t\t(\n" +
						"\t\t\t\tSELECT 'MonthlyLimit' as PropertyId,\n" +
						"\t\tmsc.currentJoinCount,\n" +
						"\t\t\t\tmsc.ProviderId FROM ctm.vw_monthlySalesCount msc\n" +
						"\t\tUNION ALL\n" +
						"\t\tSELECT 'DailyLimit' as PropertyId,\n" +
						"\t\tdsc.currentJoinCount,\n" +
						"\t\t\t\tdsc.ProviderId FROM ctm.vw_dailySalesCount dsc\n" +
						"\t\t) as sc\n" +
						"\t\tON pp.EffectiveEnd >= curDate()\n" +
						"\t\tAND sc.ProviderId = pp.ProviderId\n" +
						"\t\tAND  sc.PropertyId = pp.PropertyId\n" +
						"\t\tINNER JOIN ctm.provider_master pm\n" +
						"\t\tON pm.providerID = pp.providerID " +
						" WHERE pp.propertyId IN ('" + CappingLimit.CappingLimitType.Daily.text+ "' , '"+ CappingLimit.CappingLimitType.Monthly.text+  "')\n" +
						"\t\tAND pp.EffectiveEnd >= curDate()\n" +
						"\t\tORDER BY pp.ProviderId , pp.PropertyId)\n" +
						"\t\tUNION ALL\n" +
						"\t\t( " +
						"SELECT " +
						"0 as isCurrent, " +
						"pp.ProviderId, " +
						"\t\t\t\tpm.Name as providerName,\n" +
						"\t\tpp.PropertyId, sequenceNo ,\n" +
						"\t\t\t\tText as cappingAmount,\n" +
						"\t\t0 as currentJoinCount,\n" +
						"\t\tpp.EffectiveStart,\n" +
						"\t\t\t\tpp.EffectiveEnd\n" +
						"\t\tFROM ctm.provider_properties pp\n" +
						"\t\tINNER JOIN ctm.provider_master pm\n" +
						"\t\tON pm.providerID = pp.providerID " +
						" WHERE pp.propertyId IN ('"+CappingLimit.CappingLimitType.Daily.text+ "' , '"+ CappingLimit.CappingLimitType.Monthly.text+ "')\n" +
						"\t\tAND pp.EffectiveEnd < curDate()\n" +
						"\t\tORDER BY pp.EffectiveEnd, pp.ProviderId , pp.PropertyId\n" +
						"\t\tLIMIT 20)");

	}

	public CappingLimitInformation fetchCappingInformation(final CappingLimit cappingLimit) throws DaoException {
		DatabaseQueryMapping<CappingLimitInformation> databaseMapping= new DatabaseQueryMapping<CappingLimitInformation>(){

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
						rs.getBoolean("isCurrent"));
			}
		};
		return cappingLimitInformationDao.get(databaseMapping,
				"SELECT  \n" +
						"pp.EffectiveEnd >= curDate() as isCurrent , \n" +
						"pp.ProviderId, \n" +
						"pm.Name as providerName,\n" +
						"pp.PropertyId, sequenceNo , \n" +
						"Text as cappingAmount,\n" +
						"IFNULL(sc.currentJoinCount, 0) as currentJoinCount,\n" +
						"pp.EffectiveStart, \n" +
						"pp.EffectiveEnd\n" +
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
		DatabaseUpdateMapping databaseMapping =  new DatabaseUpdateMapping(){
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
     *  @return CappingLimitInformation which includes the latest capping counts
	 */
	public CappingLimit updateCappingLimits(final CappingLimit cappingLimit) throws DaoException {
		DatabaseUpdateMapping databaseMapping = new DatabaseUpdateMapping(){
			@Override
			public void mapParams() throws SQLException {
				set(cappingLimit.getCappingAmount());
				set(cappingLimit.getEffectiveStart());
				set(cappingLimit.getEffectiveEnd());
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
                        "EffectiveEnd = ? " +
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
     *   @return CappingLimitInformation which includes the latest capping counts and sequence no
	 * */
	public CappingLimit createCappingLimits(final CappingLimit cappingLimit) throws DaoException {
		cappingLimit.setSequenceNo(getSequenceNumber(cappingLimit));

		sqlDao.update(getDatabaseUpdateMapping(cappingLimit,"INSERT INTO `ctm`.`provider_properties`\n" +
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
		DatabaseQueryMapping<Integer> databaseMapping= new DatabaseQueryMapping<Integer>(){

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
		return new DatabaseUpdateMapping(){
                @Override
                public void mapParams() throws SQLException {
					set(cappingLimit.getProviderId());
                    set(cappingLimit.getLimitType().text);
					if(cappingLimit.getSequenceNo() != null){
						set(cappingLimit.getSequenceNo());
					}
					set(cappingLimit.getCappingAmount());
					set(cappingLimit.getEffectiveStart());
					set(cappingLimit.getEffectiveEnd());
					set(1);
				}

            @Override
            public String getStatement() {
                return statement;
            }
        };
	}


    public List<CappingLimit> fetchCappingLimits(final CappingLimit cappingLimit) throws DaoException {
        DatabaseQueryMapping<CappingLimit> databaseMapping= new DatabaseQueryMapping<CappingLimit>(){

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
        DatabaseQueryMapping<CappingLimit> databaseMapping= new DatabaseQueryMapping<CappingLimit>(){

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
