package com.ctm.web.core.services.segment;

import com.ctm.web.core.segment.dao.SegmentDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.segment.SegmentRequest;
import com.ctm.web.core.segment.model.Segment;
import com.ctm.web.core.web.go.Data;

import java.util.ArrayList;
import java.util.List;

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
