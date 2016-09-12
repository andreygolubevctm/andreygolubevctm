package com.ctm.web.bsb.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import org.springframework.stereotype.Repository;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by akhurana on 8/09/2016.
 */
@Repository
public class BSBDetailsDao {

    private static final String GET_BSB_DETAILS_QUERY = "SELECT * from bsb_details where bsbNumber = ?";
    public BSBDetails getBsbDetailsByBsbNumber(String bsbNumber) throws DaoException {
        SimpleDatabaseConnection dbSource = null;
        BSBDetails bsbDetails = new BSBDetails();

        try {
            dbSource = new SimpleDatabaseConnection();
            PreparedStatement stmt =dbSource.getConnection().prepareStatement(GET_BSB_DETAILS_QUERY);
            stmt.setString(1,bsbNumber);

            ResultSet resultSet = stmt.executeQuery();
            while(resultSet.next()){
                bsbDetails.setBsbNumber(resultSet.getString("BsbNumber"));
                bsbDetails.setBankCode(resultSet.getString("BankCode"));
                bsbDetails.setBranchName(resultSet.getString("BranchName"));
                bsbDetails.setAddress(resultSet.getString("Address"));
                bsbDetails.setSuburb(resultSet.getString("Suburb"));
                bsbDetails.setBranchState(resultSet.getString("BranchState"));
                bsbDetails.setPostCode(resultSet.getString("PostCode"));
                bsbDetails.setFound(true);
            }

        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
        finally{
            dbSource.closeConnection();
        }
        return bsbDetails;
    }
}
