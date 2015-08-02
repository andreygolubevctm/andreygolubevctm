package com.ctm.model.utilities;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;

public class UtilitiesProductRequestModel  extends AbstractJsonModel{

	private String productId;

	public UtilitiesProductRequestModel(){

	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("product_id", getProductId());

		return json;
	}

	public void populateFromRequest(HttpServletRequest request){

		setProductId(request.getParameter("productId"));

	}
}
