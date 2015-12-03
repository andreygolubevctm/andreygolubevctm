package com.ctm.web.life.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.life.model.Occupation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class OccupationsDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(OccupationsDao.class);

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
			LOGGER.error("Failed to retrieve occupation {}", kv("occupationId", occupationId));
		} finally {
			if(dbSource != null) {
				dbSource.closeConnection();
			}
		}
		
		return occupation;
	}
	
}
