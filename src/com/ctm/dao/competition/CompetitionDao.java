package com.ctm.dao.competition;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.NamingException;
import org.apache.log4j.Logger;
import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;

public class CompetitionDao {

	private static Logger logger = Logger.getLogger(CompetitionDao.class.getName());

	public static Boolean isActive(Integer styleCodeId, Integer competitionId) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		Boolean compActive = false;

		try{
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT competitionName FROM ctm.competition " +
				"WHERE competitionId = ? " +
				"	AND styleCodeId = ? " +
				"	AND effectiveStart <= CURRENT_TIMESTAMP " +
				"	AND effectiveEnd >= CURRENT_TIMESTAMP " +
				"LIMIT 1;"
			);
			stmt.setInt(1, competitionId);
			stmt.setInt(2, styleCodeId);
			ResultSet resultSet = stmt.executeQuery();

			if (resultSet.next()) {
				compActive = true;
			}

		} catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return compActive;
	}
}
