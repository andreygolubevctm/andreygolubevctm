package com.ctm.web.bsb.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import org.springframework.stereotype.Repository;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Created by akhurana on 8/09/2016.
 */
@Repository
public class BSBDetailsDao {

    private static final String GET_BSB_DETAILS_QUERY = "SELECT * from bsb_details where BsbNumber = ?";
    /*public BSBDetails getBsbDetailsByBsbNumber(String bsbNumber){
        SimpleDatabaseConnection dbSource = null;

        try {
            dbSource = new SimpleDatabaseConnection();
            PreparedStatement stmt =dbSource.getConnection().prepareStatement(GET_BSB_DETAILS_QUERY);
            stmt.setString(1,bsbNumber);

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (NamingException e) {
            e.printStackTrace();
        }
        return null;
    }
*/
    public BSBDetails getBsbDetailsByBsbNumber(String bsbNumber){
        return new BSBDetails("032-639", "Greenhills Kiosk", "K123 Greenhills Shopping Cntre", "East Maitland", "2323", "NSW");
    }


}
