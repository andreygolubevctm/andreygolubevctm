package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.ProviderExclusion;

public class ProviderExclusionsDao {

	private static Logger logger = Logger.getLogger(ProviderExclusionsDao.class.getName());

	/**
	 * Return a list of providers which have been disabled for a specific brand and vertical for the provided date.
	 * @param brandId
	 * @param verticalId
	 * @param effectiveDate
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<ProviderExclusion> getForVerticalId(int brandId, int verticalId, Date effectiveDate) throws DaoException{

		ArrayList<ProviderExclusion> exclusions = new ArrayList<ProviderExclusion>();

		SimpleDatabaseConnection dbSource = null;

		try{
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT styleCodeId, verticalId, providerId, excludeDateFrom, excludeDateTo " +
				"FROM ctm.stylecode_provider_exclusions spe " +
				"WHERE (styleCodeId = ? OR styleCodeId = 0) " +
					"AND (verticalId = ? OR verticalId = 0) " +
					"AND ? Between spe.excludeDateFrom AND spe.excludeDateTo " +
				";"
			);

			stmt.setInt(1, brandId);
			stmt.setInt(2, verticalId);
			stmt.setTimestamp(3, new java.sql.Timestamp(effectiveDate.getTime()));

			ResultSet resultSet = stmt.executeQuery();

			while (resultSet.next()) {

				ProviderExclusion providerExclusion = new ProviderExclusion();
				providerExclusion.setStyleCodeId(resultSet.getInt("styleCodeId"));
				providerExclusion.setVerticalId(resultSet.getInt("verticalId"));
				providerExclusion.setProviderId(resultSet.getInt("providerId"));
				providerExclusion.setExcludeDateFrom(resultSet.getDate("excludeDateFrom"));
				providerExclusion.setExcludeDateTo(resultSet.getDate("excludeDateTo"));

				exclusions.add(providerExclusion);

			}


		} catch (SQLException e) {
			logger.error("Failed to get ctm.stylecode_provider_exclusions for:" + brandId+":"+verticalId , e);
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			logger.error("Failed to get ctm.stylecode_provider_exclusions for:" + brandId+":"+verticalId , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return exclusions;
	}
}
