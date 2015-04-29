package com.ctm.dao.car;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class GlassesDao {

    public String getGlassesCode(String redbookCode) throws DaoException {
        SimpleDatabaseConnection dbSource = null;

        try {
            PreparedStatement stmt;
            dbSource = new SimpleDatabaseConnection();

            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT glasscode FROM aggregator.glasses_extract WHERE redbookCode = ? LIMIT 1;");

            stmt.setString(1, redbookCode);

            ResultSet results = stmt.executeQuery();

            if (results.next()) {
                return results.getString("glasscode");
            }
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        }
        finally {
            dbSource.closeConnection();
        }

        return null;
    }

    public String getGlassesCode(String redbookCode, int year) throws DaoException {
        SimpleDatabaseConnection dbSource = null;

        try {
            PreparedStatement stmt;
            dbSource = new SimpleDatabaseConnection();

            stmt = dbSource.getConnection().prepareStatement(
                    "SELECT glasscode FROM aggregator.glasses_extract WHERE redbookCode = ? and year = ? LIMIT 1;");

            stmt.setString(1, redbookCode);
            stmt.setString(2, Integer.toString(year));

            ResultSet results = stmt.executeQuery();

            if (results.next()) {
                return results.getString("glasscode");
            }
        }
        catch (SQLException | NamingException e) {
            throw new DaoException(e.getMessage(), e);
        }
        finally {
            dbSource.closeConnection();
        }

        return null;
    }

}
