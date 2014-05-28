package com.ctm.dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.simples.InboundPhoneNumber;
import com.ctm.services.ApplicationService;

public class InboundPhoneNumberDao {

	private static Logger logger = Logger.getLogger(InboundPhoneNumberDao.class.getName());

	public InboundPhoneNumberDao(){

	}

	/**
	 * Query the database for information relating to a VDN number. (eg: which brand it relates to)
	 *
	 * @param vdn
	 * @return
	 */
	public InboundPhoneNumber getByVdn(String vdn) throws DaoException{

		InboundPhoneNumber inboundPhoneNumber = null;

		SimpleDatabaseConnection dbSource = null;

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT inboundPhoneNumberId, styleCodeId, phoneNumber, vdn, cid, effectiveStart, effectiveEnd " +
				"FROM simples.inbound_phone_numbers ipns " +
				"WHERE ipns.vdn = ? AND ipns.effectiveStart < ? AND ipns.effectiveEnd > ? ;"
			);

			stmt.setInt(1, Integer.parseInt(vdn));
			Date referenceDate = new Date(ApplicationService.getServerDate().getTime());
			stmt.setDate(2, referenceDate);
			stmt.setDate(3, referenceDate);


			ResultSet resultSet = stmt.executeQuery();

			ArrayList<InboundPhoneNumber> phoneNumbers = new ArrayList<InboundPhoneNumber>();

			while (resultSet.next()) {

				InboundPhoneNumber phone = new InboundPhoneNumber();
				phone.setId(resultSet.getInt("inboundPhoneNumberId"));
				phone.setStyleCodeId(resultSet.getInt("styleCodeId"));
				phone.setPhoneNumber(resultSet.getString("phoneNumber"));
				phone.setVdn(resultSet.getInt("vdn"));
				phone.setCid(resultSet.getString("cid"));
				phone.setEffectiveStart(resultSet.getDate("effectiveStart"));
				phone.setEffectiveEnd(resultSet.getDate("effectiveEnd"));
				phoneNumbers.add(phone);

			}

			if(phoneNumbers.size() > 1){
				logger.error("There is more than one phone for this vdn code: "+vdn);
			}else if(phoneNumbers.size() == 0){
				logger.error("There is no record of this VDN: "+vdn);
			}else{
				inboundPhoneNumber = phoneNumbers.get(0);
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
		return inboundPhoneNumber;
	}
}
