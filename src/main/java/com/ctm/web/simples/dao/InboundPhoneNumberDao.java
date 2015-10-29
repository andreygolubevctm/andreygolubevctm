package com.ctm.web.simples.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.simples.model.InboundPhoneNumber;
import com.ctm.services.ApplicationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class InboundPhoneNumberDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(InboundPhoneNumberDao.class);

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
				"SELECT inboundPhoneNumberId, styleCodeId, verticalId, phoneNumber, vdn, cid, effectiveStart, effectiveEnd " +
				"FROM simples.inbound_phone_numbers ipns " +
				"WHERE ipns.vdn = ? AND ? BETWEEN ipns.effectiveStart AND ipns.effectiveEnd;"
			);

			stmt.setInt(1, Integer.parseInt(vdn));
			Date referenceDate = new Date(ApplicationService.getServerDate().getTime());
			stmt.setDate(2, referenceDate);

			ResultSet resultSet = stmt.executeQuery();

			ArrayList<InboundPhoneNumber> phoneNumbers = new ArrayList<InboundPhoneNumber>();

			while (resultSet.next()) {

				InboundPhoneNumber phone = new InboundPhoneNumber();
				phone.setId(resultSet.getInt("inboundPhoneNumberId"));
				phone.setStyleCodeId(resultSet.getInt("styleCodeId"));
				phone.setVerticalId(resultSet.getInt("verticalId"));
				phone.setPhoneNumber(resultSet.getString("phoneNumber"));
				phone.setVdn(resultSet.getInt("vdn"));
				phone.setCid(resultSet.getString("cid"));
				phone.setEffectiveStart(resultSet.getDate("effectiveStart"));
				phone.setEffectiveEnd(resultSet.getDate("effectiveEnd"));
				phoneNumbers.add(phone);

			}

			if(phoneNumbers.size() > 1){
				LOGGER.error("More than one inbound phone number found {}", kv("vdn", vdn));
			}else if(phoneNumbers.size() == 0){
				LOGGER.error("No inbound phone number found {}", kv("vdn", vdn));
			}else{
				inboundPhoneNumber = phoneNumbers.get(0);
			}

		} catch (SQLException | NamingException e) {
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}
		return inboundPhoneNumber;
	}
}
