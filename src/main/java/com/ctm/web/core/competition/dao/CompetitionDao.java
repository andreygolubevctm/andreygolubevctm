package com.ctm.web.core.competition.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class CompetitionDao {

	public static Boolean isActive(Integer styleCodeId, Integer competitionId, Date serverDate) throws DaoException{

		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		Boolean compActive = false;

		try{

			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT competitionName FROM ctm.competition " +
							"WHERE competitionId = ? " +
							"	AND styleCodeId = ? " +
							"	AND effectiveStart <= ? " +
							"	AND effectiveEnd >= ? " +
							"LIMIT 1;"
			);
			stmt.setInt(1, competitionId);
			stmt.setInt(2, styleCodeId);
			stmt.setString(3, String.valueOf(sdf.format(serverDate)));
			stmt.setString(4, String.valueOf(sdf.format(serverDate)));
			ResultSet resultSet = stmt.executeQuery();

			if (resultSet.next()) {
				compActive = true;
			}

		} catch (SQLException | NamingException e) {
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return compActive;
	}
}
