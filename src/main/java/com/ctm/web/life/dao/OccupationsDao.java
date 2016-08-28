package com.ctm.web.life.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.life.model.Occupation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.naming.NamingException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

@Repository
public class OccupationsDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(OccupationsDao.class);
	private final NamedParameterJdbcTemplate jdbcTemplate;

	@Autowired
	@SuppressWarnings("SpringJavaAutowiringInspection")
	public OccupationsDao(final NamedParameterJdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}

	public Occupation getOccupation(String occupationId) {
		final MapSqlParameterSource params = new MapSqlParameterSource()
				.addValue("occupationCode", occupationId);

		return jdbcTemplate.queryForObject("SELECT title, talCode " +
				"FROM ctm.lifebroker_occupations " +
				"WHERE occupationCode = :occupationCode " +
				"LIMIT 1;", params, (rs, rowNum) -> {
			Occupation occupation = new Occupation();
			occupation.setId(occupationId);
			occupation.setTitle(rs.getString("title"));
			occupation.setTalCode(rs.getString("talCode"));
			return occupation;
		});
	}
	
	public static ArrayList<Occupation> getOccupationList(String searchText) {
		SimpleDatabaseConnection dbSource = null;
		ArrayList<Occupation> occupations;

		occupations = new ArrayList<>();

		try {
			dbSource = new SimpleDatabaseConnection();
			java.sql.PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
					"SELECT occupationCode AS code, title, hannover AS hannoverCode " +
			"FROM ctm.lifebroker_occupations " +
			"JOIN ctm.tal_hannover_mappings ON lifebroker_occupations.talCode = tal_hannover_mappings.tal " +
				"WHERE title LIKE (?)"
			);
			stmt.setString(1,"%"+searchText.trim()+"%");

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				Occupation occupation = new Occupation();
				occupation.setId(results.getString("code"));
				occupation.setTitle(results.getString("title"));
				occupation.setTalCode(results.getString("hannoverCode"));
				occupations.add(occupation);
			}
		}
		catch (SQLException | NamingException e) {
			LOGGER.error("Failed to retrieve occupations", e);
		}
		finally {
			dbSource.closeConnection();
		}

		return occupations;
	}
}
