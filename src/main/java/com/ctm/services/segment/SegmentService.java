package com.ctm.services.segment;

import java.util.ArrayList;
import java.util.List;

import com.ctm.web.core.dao.SegmentDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.segment.Segment;
import com.ctm.model.segment.SegmentRequest;
import com.disc_au.web.go.Data;

public class SegmentService {

	private SegmentDao segmentDao;

	public SegmentService() {
		this.segmentDao = new SegmentDao();
	}

	public SegmentService(SegmentDao segmentDao) {
		this.segmentDao = segmentDao;
	}

	public List<Segment> filterSegmentsForUser(SegmentRequest segmentRequest, Data data) throws DaoException {
		SegmentRulesService segmentRulesService = new SegmentRulesService();
		List<Segment> segmentsAvailable = segmentDao.getAvailableSegments(segmentRequest);
		List<Segment> segmentsFiltered = new ArrayList<Segment>();

		if (!segmentsAvailable.isEmpty()){
			for (Segment segment: segmentsAvailable) {
				segmentDao.setRulesForSegment(segment);
				if (segmentRulesService.filter(segment, segment.getSegmentRules(), data)) {
					segmentsFiltered.add(segment);
				}
			}
		}
		return segmentsFiltered;
	}
}
