package com.ctm.web.health.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.health.model.HealthFamilyType;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import static com.ctm.commonlogging.common.LoggingArguments.kv;


public class HealthFamilyTypeDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(HealthFamilyTypeDao.class);


    public HealthFamilyTypeDao() {

    }


	/**
	 * Returns list of family Types (healthCvr) and their associated descriptions - the boolean  parameter determines if 'S' is returned or if 'SM' and 'SF' is returned
	 *
	 * @param getGender
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<HealthFamilyType> getFamilyTypes(Boolean getGender) throws DaoException{
		SimpleDatabaseConnection dbSource = null;

		ArrayList<HealthFamilyType> familyTypes = new ArrayList<>();

		try{
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;


			String statementSQL = "SELECT code, description " +
				"FROM aggregator.general " +
				"WHERE type = 'healthCvr' ";

			if (getGender) {
				statementSQL += "AND (status IS NULL OR status != 0) ";
			} else {
				// return alternate values that have a status of zero
				statementSQL += "AND code NOT IN ('SF', 'SM', 'SPF') ";
			}

			statementSQL += " ORDER BY orderSeq";

			stmt = dbSource.getConnection().prepareStatement(statementSQL);

			ResultSet productResult = stmt.executeQuery();

			while (productResult.next()) {

				HealthFamilyType familyType = new HealthFamilyType();
				familyType.setCode(productResult.getString("code"));
				familyType.setDescription(productResult.getString("description"));
				familyTypes.add(familyType);

			}

		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to retrieve Health family Types {}, {}",  kv("getGender", getGender));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return familyTypes;
	}
}