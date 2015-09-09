package com.ctm.dao.competition;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.dao.DatabaseUpdateBatchMapping;
import com.ctm.dao.DatabaseUpdateMapping;
import com.ctm.dao.SqlDao;
import com.ctm.exceptions.DaoException;
import org.apache.commons.lang3.tuple.Pair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class CompetitionDao {

	private static final Logger logger = LoggerFactory.getLogger(CompetitionDao.class.getName());

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
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return compActive;
	}

	/**
	 * Adds to the competition_master table the competitionId and emailId with
	 * related details (key value pair) to the competition_data table.
	 * @param competitionId
	 * @param emailId
	 * @param details
	 * @throws DaoException
	 */
	public static void addCompetitionEntry(Integer competitionId, Integer emailId, List<Pair<String, String>> details) throws DaoException {
		// FIXME: needs to be wrapped in an atomic transaction
		SqlDao sqlDao = new SqlDao();
		long competitionMasterId = sqlDao.insert(new DatabaseUpdateMapping() {
			@Override
			protected void mapParams() throws SQLException {
				set(competitionId);
				set(emailId);
			}

			@Override
			public String getStatement() {
				return "INSERT INTO ctm.competition_master (competition_id, email_id) VALUES (?,?)";
			}
		});

		sqlDao.updateBatch(new DatabaseUpdateBatchMapping() {
			@Override
			protected void mapParams() throws SQLException {
				for (Pair<String, String> data : details) {
					set(competitionMasterId);
					set(data.getKey());
					set(data.getValue());
					set(data.getValue());
					addToBatch();
				}
			}

			@Override
			public String getStatement() {
				return "INSERT INTO ctm.competition_data (entry_id, property_id, value) " +
						"VALUES (?,?,?) ON DUPLICATE KEY UPDATE value = ?";
			}
		});
	}

}
