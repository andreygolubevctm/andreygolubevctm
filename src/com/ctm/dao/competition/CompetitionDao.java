package com.ctm.dao.competition;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import com.ctm.services.ApplicationService;
import org.apache.log4j.Logger;
import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;

public class CompetitionDao {

	private static Logger logger = Logger.getLogger(CompetitionDao.class.getName());

	public static Boolean isActive(Integer styleCodeId, Integer competitionId, HttpServletRequest request) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		Boolean compActive = false;

		Date serverDate = ApplicationService.getApplicationDate(request);

		try{
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT competitionName FROM ctm.competition " +
				"WHERE competitionId = ? " +
				"	AND styleCodeId = ? " +
				"	AND effectiveStart <= serverDate " +
				"	AND effectiveEnd >= serverDate " +
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
