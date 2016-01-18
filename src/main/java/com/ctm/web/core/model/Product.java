package com.ctm.web.core.model;

import com.ctm.web.core.provider.model.Provider;

import java.util.ArrayList;
import java.util.Date;

/** This maps to product_master table */

public class Product {

	private int id;
	private String code;

	private Provider provider;

	private String shortTitle;
	private String longTitle;

	private Date effectiveStart;
	private Date effectiveEnd;

	private String status;

	private String verticalCode;

	private ArrayList<ProductProperty> properties;
	private ArrayList<ProductPropertyText> propertiesText;
	private ArrayList<ProductPropertyExt> propertiesExt;

	public Product(){
		properties = new ArrayList<ProductProperty>();
		propertiesExt = new ArrayList<ProductPropertyExt>();
		propertiesText = new ArrayList<ProductPropertyText>();
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public Provider getProvider() {
		return provider;
	}

	public void setProvider(Provider provider) {
		this.provider = provider;
	}

	public String getShortTitle() {
		return shortTitle;
	}

	public void setShortTitle(String shortTitle) {
		this.shortTitle = shortTitle;
	}

	public String getLongTitle() {
		return longTitle;
	}

	public void setLongTitle(String longTitle) {
		this.longTitle = longTitle;
	}

	public Date getEffectiveStart() {
		return effectiveStart;
	}

	public void setEffectiveStart(Date effectiveStart) {
		this.effectiveStart = effectiveStart;
	}

	public Date getEffectiveEnd() {
		return effectiveEnd;
	}

	public void setEffectiveEnd(Date effectiveEnd) {
		this.effectiveEnd = effectiveEnd;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getVerticalCode() {
		return verticalCode;
	}

	public void setVerticalCode(String verticalCode) {
		this.verticalCode = verticalCode;
	}

	public ArrayList<ProductProperty> getProperties() {
		return properties;
	}

	public void setProperties(ArrayList<ProductProperty> properties) {
		this.properties = properties;
	}

	public void addProperty(ProductProperty property){
		property.setProductId(getId());
		properties.add(property);
	}

	public ProductProperty getProperty(String propertyId){
		for(ProductProperty prop : getProperties()){
			if(prop.getPropertyId().equals(propertyId)){
				return prop;
			}
		}

		return null;
	}

	public boolean isPropertyExists(String key){
		ProductProperty prop = getProperty(key);
		if(prop != null) return true;
		return false;
	}

	public String getPropertyAsString(String key){
		ProductProperty prop = getProperty(key);
		if(prop != null) return prop.getText();
		return null;
	}

	public Double getPropertyAsDouble(String key){
		ProductProperty prop = getProperty(key);
		if(prop != null) return prop.getValue();
		return null;
	}

	public boolean getPropertyAsBoolean(String key){
		ProductProperty prop = getProperty(key);
		if(prop != null) return prop.getValue() == 1;
		return false;
	}

	/**
	 * The following functions use the ctm.product_properties_ext table.
	 * @return
	 */
	public ArrayList<ProductPropertyExt> getPropertiesExt() {
		return propertiesExt;
	}

	public void addPropertyExt(ProductPropertyExt propertyExt){
		propertyExt.setProductId(getId());
		propertiesExt.add(propertyExt);
	}

	public void setPropertiesExt(ArrayList<ProductPropertyExt> propertiesExt) {
		this.propertiesExt = propertiesExt;
	}

	public ProductPropertyExt getPropertyExtByType(String type){
		for(ProductPropertyExt prop : getPropertiesExt()){
			if(prop.getType().equals(type)) {
				return prop;
			}
		}
		return null;
	}
	/**
	 * The following functions use the ctm.product_properties_TEXT table.
	 * @return
	 */
	public ArrayList<ProductPropertyText> getPropertiesText() {
		return propertiesText;
	}

	public void setPropertiesText(ArrayList<ProductPropertyText> propertiesText) {
		this.propertiesText = propertiesText;
	}

	public void addPropertyText(ProductPropertyText propertyText){
		propertyText.setProductId(getId());
		propertiesText.add(propertyText);
	}

	public ProductPropertyText getPropertyText(String propertyId){
		for(ProductPropertyText prop : getPropertiesText()){
			if(prop.getPropertyId().equals(propertyId)){
				return prop;
			}
		}

		return null;
	}
	/**
	 * This is a TEXT type in the database (product_properties uses VARCHAR(640).
	 * @param key
	 * @return
	 */
	public String getPropertyAsLongText(String key) {
		ProductPropertyText prop = getPropertyText(key);
		return prop != null ? prop.getText() : null;
	}


}
