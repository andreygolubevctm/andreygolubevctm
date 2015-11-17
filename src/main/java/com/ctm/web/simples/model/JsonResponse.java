package com.ctm.web.simples.model;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.web.core.model.AbstractJsonModel;

public class JsonResponse extends AbstractJsonModel {

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		return new JSONObject();
	}

}
