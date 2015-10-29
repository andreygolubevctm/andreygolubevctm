package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class GeneralDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(GeneralDao.class);

	public Map<String, String> getValues(String type){
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		Map<String, String> values = new HashMap<>();
		Connection conn;
		try {
			// Allocate and use a connection from the pool
			conn = dbSource.getConnection();
			PreparedStatement stmt;
			stmt = conn.prepareStatement(
					"SELECT code, description " +
						"FROM aggregator.general g " +
						"WHERE g.type = ?;");
			stmt.setString(1, type);
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				values.put(rs.getString("code"), rs.getString("description"));
			}
			rs.close();
		} catch (SQLException | NamingException e) {
			LOGGER.error("failed retrieving value from general table {}", kv("type", type), e);
		} finally {
			dbSource.closeConnection();
		}
		return values;
	}

}
