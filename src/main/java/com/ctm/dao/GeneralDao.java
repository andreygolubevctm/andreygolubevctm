package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class GeneralDao {

	private static final Logger logger = LoggerFactory.getLogger(GeneralDao.class.getName());

	public Map<String, String> getValues(String type){
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		Map<String, String> values = new HashMap<String, String>();
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
			logger.error("",e);
		} finally {
			dbSource.closeConnection();
		}
		return values;
	}

}
