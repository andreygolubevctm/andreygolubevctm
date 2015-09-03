package com.ctm.dao.life;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.model.life.Occupation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.logging.LoggingArguments.kv;

public class OccupationsDao {
	private static final Logger logger = LoggerFactory.getLogger(OccupationsDao.class.getName());

	public Occupation getOccupation(String occupationId) {
		Occupation occupation = new Occupation();
		occupation.setId(occupationId);
		
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			
			if(conn != null) {
				stmt = conn.prepareStatement(
					"SELECT title, talCode " +
					"FROM ctm.lifebroker_occupations " +
					"WHERE occupationCode = ? " +
					"LIMIT 1;"
				);
				
				stmt.setString(1, occupationId);
				
				ResultSet resultSet = stmt.executeQuery();
				
				while (resultSet.next()) {
					occupation.setTitle(resultSet.getString("title"));
					occupation.setTALCode(resultSet.getString("talCode"));
				}
			}
		} catch (SQLException | NamingException e) {
			logger.error("Failed to retrieve occupation {}", kv("occupationId", occupationId));
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		
		return occupation;
	}
	
}
