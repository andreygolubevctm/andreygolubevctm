package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.IpAddress;
import com.ctm.model.settings.PageSettings;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Accesses the database table aggregator.ip_address
 * Used by Fuel and Travel currently to block scrape attacks based on IP Address.
 */
public class IpAddressDao {


    private IpAddress ipAddress;

    /**
     *
     * @param pageSettings
     * @param ipAddress
     * @return
     * @throws DaoException
     */
    public IpAddress findMatch(PageSettings pageSettings, long ipAddress) throws DaoException {

        SimpleDatabaseConnection dbSource = null;
        IpAddress ipAddressModel = null;
        try {
            dbSource = new SimpleDatabaseConnection();
            PreparedStatement stmt;
            Connection conn = dbSource.getConnection();

            if (conn != null) {
                stmt = conn.prepareStatement(
                        "SELECT styleCodeId, ipStart, ipEnd, `Role`, " +
                                "CASE WHEN `date` = CURDATE() THEN total ELSE 0 END AS `total` " +
                                "FROM aggregator.ip_address " +
                                "WHERE Service = ? " +
                                "AND styleCodeId = ? " +
                                "AND ipStart <= ? " +
                                "AND ipEnd >= ? " +
                                "ORDER BY ipEnd, `date` DESC " +
                                "LIMIT 1"
                );

                stmt.setString(1, pageSettings.getVerticalCode());
                stmt.setInt(2, pageSettings.getBrandId());
                stmt.setLong(3, ipAddress);
                stmt.setLong(4, ipAddress);

                ResultSet resultSet = stmt.executeQuery();

                if (resultSet.next()) {
                    ipAddressModel = new IpAddress(resultSet.getLong("ipStart"), resultSet.getLong("ipEnd"),
                            pageSettings.getVerticalCode(), IpAddress.IpCheckRole.findByCode(resultSet.getString("Role")),
                            resultSet.getInt("total"), resultSet.getInt("styleCodeId")
                    );
                } else {
                    ipAddressModel = new IpAddress(ipAddress, ipAddress, pageSettings.getVerticalCode(),
                            IpAddress.IpCheckRole.TEMPORARY_USER, 0, pageSettings.getBrandId()
                    );
                }

            }
        } catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        } finally {
            if (dbSource != null) {
                dbSource.closeConnection();
            }
        }

        return ipAddressModel;
    }

    /**
     *
     * @param ip
     * @return
     * @throws DaoException
     */
    public IpAddress insertOrUpdateRecord(IpAddress ip) throws DaoException {
        SimpleDatabaseConnection dbSource = null;

        try {
            // Increment. We set to 1 by default, but will update to 2 and return
            IpAddress updatedIp = new IpAddress(ip.getIpStart(), ip.getIpEnd(), ip.getService(), ip.getRole(), ip.getNumberOfHits() + 1, ip.getStyleCodeId());

            dbSource = new SimpleDatabaseConnection();
            PreparedStatement stmt;
            Connection conn = dbSource.getConnection();

            if (conn != null) {
                stmt = dbSource.getConnection().prepareStatement(
                        "INSERT INTO  `aggregator`.`ip_address` ( `ipStart`, `ipEnd`, `Date`, `Service`, `Role`, `Total`, `styleCodeId`)  " +
                                "VALUES (?, ?, CURDATE(), ?, ?, 1, ?) " +
                                "ON DUPLICATE KEY UPDATE " +
                                "`Total` = ?, " +
                                "`Date` = CURDATE();"
                );


                stmt.setLong(1, updatedIp.getIpStart());
                stmt.setLong(2, updatedIp.getIpEnd());
                stmt.setString(3, updatedIp.getService());
                stmt.setString(4, updatedIp.getRole().getCode());
                stmt.setInt(5, updatedIp.getStyleCodeId());
                stmt.setInt(6, updatedIp.getNumberOfHits());
                stmt.executeUpdate();
            }
        } catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        } finally {
            dbSource.closeConnection();
        }

        // return updated model with incremented total.
        return this.ipAddress;
    }

}
