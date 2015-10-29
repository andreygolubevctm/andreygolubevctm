package com.ctm.web.core.dao;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.model.segment.Segment;
import com.ctm.model.segment.SegmentRequest;
import com.ctm.model.segment.SegmentRule;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

public class SegmentDao {

	public List<Segment> getAvailableSegments(SegmentRequest segmentRequest) throws DaoException {
		return getAvailableSegments(segmentRequest.styleCodeId, segmentRequest.verticalId, segmentRequest.effectiveDate);
	}

	public List<Segment> getAvailableSegments(final int styleCodeId, final int verticalId, final Date effectiveDate) throws DaoException {
		final SqlDao<Segment> sqlDao = new SqlDao<Segment>();

		String sql =
				"SELECT segmentId, classToHide, canHide " +
				"FROM ctm.segment " +
				"WHERE styleCodeId = ? " +
				"AND verticalId = ? " +
				"AND ? BETWEEN effectiveStart AND effectiveEnd;";

		DatabaseQueryMapping<Segment> databaseMapping = new DatabaseQueryMapping<Segment>() {

			@Override
			public void mapParams() throws SQLException {
				set(styleCodeId);
				set(verticalId);
				set(effectiveDate);
			}

			@Override
			public Segment handleResult(ResultSet rs) throws SQLException {
				return mapToObject(rs);
			}
		};

		return sqlDao.getList(databaseMapping, sql);
	}

	public void setRulesForSegment(final Segment segment) throws DaoException {
		if (segment.getSegmentId() > 0) {
			final SqlDao<SegmentRule> sqlDao = new SqlDao<SegmentRule>();

			String sql =
					"SELECT * " +
					"FROM ctm.segment_rules " +
					"WHERE segmentId = ? ";

			DatabaseQueryMapping<SegmentRule> databaseMapping = new DatabaseQueryMapping<SegmentRule>() {
				@Override
				public void mapParams() throws SQLException {
					set(segment.getSegmentId());
				}

				@Override
				public SegmentRule handleResult(ResultSet rs) throws SQLException {
					SegmentRule segmentRule = new SegmentRule();

					segmentRule.setRuleId(rs.getInt("ruleId"));
					segmentRule.setXpath(rs.getString("xpath"));
					segmentRule.setFilterBy(rs.getString("filterBy"));
					segmentRule.setOption(rs.getString("option"));
					segmentRule.setValue(rs.getString("value"));

					return segmentRule;
				}
			};

			segment.setSegmentRules(sqlDao.getList(databaseMapping, sql));
		}
	}

	private Segment mapToObject(final ResultSet results) throws SQLException {
		final Segment segment = new Segment();

		segment.setSegmentId(results.getInt("segmentId"));
		segment.setClassToHide(results.getString("classToHide"));
		segment.setCanHide(results.getBoolean("canHide"));

		return segment;
	}
}
