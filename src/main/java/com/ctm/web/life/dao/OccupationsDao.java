package com.ctm.web.life.dao;

import com.ctm.web.life.model.Occupation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class OccupationsDao {
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
	
}
