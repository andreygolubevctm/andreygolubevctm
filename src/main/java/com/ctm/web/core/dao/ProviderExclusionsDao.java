package com.ctm.web.core.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import javax.naming.NamingException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.ProviderExclusion;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class ProviderExclusionsDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(ProviderExclusionsDao.class);

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
					"SELECT spe.styleCodeId, spe.verticalId, spe.providerId, spe.excludeDateFrom, spe.excludeDateTo, pm.providerCode " +
							"FROM ctm.stylecode_provider_exclusions spe, ctm.provider_master pm " +
							"WHERE (styleCodeId = ? OR styleCodeId = 0) " +
							"AND (verticalId = ? OR verticalId = 0) " +
							"AND ? Between spe.excludeDateFrom AND spe.excludeDateTo AND spe.providerId = pm.ProviderId" +
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
				providerExclusion.setCode(resultSet.getString("providerCode"));

				exclusions.add(providerExclusion);

			}


		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to retrieve excluded providers {}, {}, {}", kv("brandId", brandId), kv("verticalId", verticalId), kv("effectiveDate", effectiveDate), e);
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return exclusions;
	}
}
