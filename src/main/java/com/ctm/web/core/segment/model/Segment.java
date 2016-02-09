package com.ctm.web.core.segment.model;

import com.ctm.web.core.model.AbstractJsonModel;
import com.ctm.web.core.segment.model.segment.SegmentRule;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class Segment extends AbstractJsonModel {

	private int segmentId;
	private String classToHide;
	private boolean canHide;
	private List<SegmentRule> segmentRules;

	public int getSegmentId() {
		return segmentId;
	}

	public void setSegmentId(int segmentId) {
		this.segmentId = segmentId;
	}

	public String getClassToHide() {
		return classToHide;
	}

	public void setClassToHide(String classToHide) {
		this.classToHide = classToHide;
	}

	public boolean getCanHide() {
		return canHide;
	}

	public void setCanHide(boolean canHide) {
		this.canHide = canHide;
	}

	public List<SegmentRule> getSegmentRules() {
		if (segmentRules == null) return new ArrayList<SegmentRule>();
		return segmentRules;
	}

	public void setSegmentRules(List<SegmentRule> segmentRules) {
		this.segmentRules = segmentRules;
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("segmentId", getSegmentId());
		json.put("classToHide", getClassToHide());
		json.put("canHide", getCanHide());

		return json;
	}
}