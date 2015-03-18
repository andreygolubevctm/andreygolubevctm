package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by lbuchanan on 18/02/2015.
 */
public class ProductDaoBuilder {
	private Timestamp effectiveDateTime;
	private List<Object> productParams  = new ArrayList<>();
	private String categoryCode;
	private String providerCode;
	private String productCode;
	private String productCat;

	public ProductDaoBuilder withTimeStamp(Timestamp effectiveDateTime) {
		this.effectiveDateTime = effectiveDateTime;
		return this;
	}

	public ProductDaoBuilder withCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
		return this;
	}

	public ProductDaoBuilder withProviderCode(String providerCode) {
		this.providerCode = providerCode;
		return this;
	}

	public ProductDaoBuilder withProductCode(String productCode) {
		this.productCode = productCode;
		return this;
	}

	public ProductDaoBuilder withProductCat(String productCat) {
		this.productCat = productCat;
		return this;
	}

	public void addTimeStampEffectiveDateTimeParam() {
		productParams.add(effectiveDateTime);
	}

	public void addCategoryCodeParam() {
		productParams.add(categoryCode);
	}

	public void addProviderCodeParam() {
		productParams.add(providerCode);
	}

	public void addProductCodeParam() {
		productParams.add(productCode);
	}

	public void addProductCatParam() {
		productParams.add(productCat);
	}

	public void buildParams(PreparedStatement stmt) throws SQLException {
		int paramCount = 1;
		for(Object param : productParams){
			if(param instanceof String){
				stmt.setString(paramCount, (String) param);
			} else if(param instanceof Integer){
				stmt.setInt(paramCount, (Integer) param);
			} else if(param instanceof Timestamp){
				stmt.setTimestamp(paramCount, (Timestamp) param);
			}
			paramCount++;
		}

	}

	public void resetParams() {
		productParams  = new ArrayList<>();
	}
}
