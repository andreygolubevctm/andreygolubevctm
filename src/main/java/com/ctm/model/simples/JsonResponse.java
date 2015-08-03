package com.ctm.model.simples;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

public class JsonResponse extends AbstractJsonModel {

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		return new JSONObject();
	}

}
