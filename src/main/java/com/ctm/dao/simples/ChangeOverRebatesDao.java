package com.ctm.dao.simples;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.simples.ChangeOverRebate;
import com.ctm.model.simples.MessageOverview;

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
				"SELECT multiplier as currentMultiplier, (SELECT multiplier FROM simples.changeover_rebates WHERE id = rebates.id + 1) as futureMultiplier," +
						"effectiveStart, effectiveEnd\n" +
						"FROM simples.changeover_rebates rebates \n" +
						"WHERE ?  >= effectiveStart AND ? <= effectiveEnd; "
			);
			stmt.setDate(1, new java.sql.Date(commencementDate.getTime()));
			stmt.setDate(2, new java.sql.Date(commencementDate.getTime()));

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				changeOverRebate.setCurrentMultiplier(results.getBigDecimal(1));
				changeOverRebate.setFutureMultiplier(results.getBigDecimal(2));
				changeOverRebate.setEffectiveStart(results.getDate(3));
				changeOverRebate.setEffectiveEnd(results.getDate(4));
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
