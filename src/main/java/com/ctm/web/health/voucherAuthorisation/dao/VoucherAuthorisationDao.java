package com.ctm.web.health.voucherAuthorisation.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Repository;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

/**
 * Created by msmerdon on 5/10/2016.
 */
@Repository
public class VoucherAuthorisationDao {

    private static final String GET_AUTHORISATION_QUERY = 
		"SELECT hvu.voucherUsername, hvu.voucherCode, hvu.voucherEffectiveEnd " +
		"FROM ctm.health_voucher_users AS hvu " +
		"WHERE hvu.voucherCode = ? AND ? < hvu.voucherEffectiveEnd " +
		"LIMIT 1";

    @Cacheable(cacheNames = {"getAuthorisation"})
    public VoucherAuthorisation getAuthorisation(String code, java.util.Date currentDatetime) throws DaoException {
        SimpleDatabaseConnection dbSource = null;
        PreparedStatement stmt = null;
        VoucherAuthorisation voucherAuthorisation = new VoucherAuthorisation();

        try {
            dbSource = new SimpleDatabaseConnection();
            stmt = dbSource.getConnection().prepareStatement(GET_AUTHORISATION_QUERY);
            stmt.setString(1,code);
			stmt.setTimestamp(2,new Timestamp(currentDatetime.getTime()));

            ResultSet resultSet = stmt.executeQuery();
            while(resultSet.next()){
                voucherAuthorisation.setCode(resultSet.getString("voucherCode"));
                voucherAuthorisation.setUsername(resultSet.getString("voucherUsername"));
                voucherAuthorisation.setEffectiveEnd(resultSet.getDate("voucherEffectiveEnd"));
                voucherAuthorisation.setIsAuthorised(true);
            }

        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
        finally{
            dbSource.closeConnection();
            dbSource.closeStatement(stmt);
        }
        return voucherAuthorisation;
    }
}
