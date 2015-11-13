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
				"SELECT multiplier as currentMultiplier, (SELECT multiplier FROM `ctm`.`health_changeover_rebates` WHERE id = rebates.id + 1) as futureMultiplier, " +
						"effectiveStart " +
						"FROM `ctm`.`health_changeover_rebates` rebates " +
						"WHERE ? >= effectiveStart "
			);
			stmt.setDate(1, new java.sql.Date(commencementDate.getTime()));

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				changeOverRebate.setCurrentMultiplier(results.getBigDecimal(1));
				changeOverRebate.setFutureMultiplier(results.getBigDecimal(2));
				changeOverRebate.setEffectiveStart(results.getDate(3));
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
