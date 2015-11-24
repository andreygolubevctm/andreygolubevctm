package com.ctm.web.simples.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.simples.model.ChangeOverRebate;
import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

public class ChangeOverRebatesDao {

	/**
	 */
	public ChangeOverRebate getChangeOverRebates(Date commencementDate) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ChangeOverRebate changeOverRebate = new ChangeOverRebate();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			//
			// Execute the stored procedure for message details
			//
			stmt = dbSource.getConnection().prepareStatement(
					"SELECT multiplier as currentMultiplier, " +
						"(SELECT multiplier FROM `ctm`.`health_changeover_rebates` WHERE id = (SELECT min(id) " +
						"            FROM `ctm`.`health_changeover_rebates` WHERE id > rebates.id)) as futureMultiplier, " +
						"(SELECT effectiveStart FROM `ctm`.`health_changeover_rebates` WHERE id = (SELECT min(id) " +
						"            FROM `ctm`.`health_changeover_rebates` WHERE id > rebates.id)) as effectiveFutureStart, " +
						"            effectiveStart " +
						"            FROM `ctm`.`health_changeover_rebates` rebates " +
						"            WHERE ? >= effectiveStart ORDER BY id DESC LIMIT 1"
			);
			stmt.setDate(1, new java.sql.Date(commencementDate.getTime()));

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				changeOverRebate.setCurrentMultiplier(results.getBigDecimal(1));
				changeOverRebate.setFutureMultiplier(
						results.getObject("futureMultiplier") != null ?
								results.getBigDecimal("futureMultiplier") : results.getBigDecimal("currentMultiplier"));
				changeOverRebate.setEffectiveStart(results.getDate(3));
				changeOverRebate.setEffectiveFutureStart(
						results.getObject("effectiveFutureStart") != null ?
								results.getDate("effectiveFutureStart") : results.getDate(3));
			}
		}
		catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		}
		catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return changeOverRebate;
	}

}
