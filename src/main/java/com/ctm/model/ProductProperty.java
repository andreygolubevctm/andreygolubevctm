package com.ctm.model;

import java.util.Date;

/** This maps to product_properties table */

public class ProductProperty {

	private int productId;
	private String propertyId;
	private int sequenceNumber = 0;
	private Double value;
	private String text;
	private Date date;
	private Date effectiveStart;
	private Date effectiveEnd;
	private String status;
	private int benefitOrder;

	private String label;
	private String longLabel;
	private int helpId;

	public ProductProperty(){

	}

	// ProductProperty property = new ProductProperty(1,"",1,1,"",new Date(),new Date(), new Date(),"",0);
	public ProductProperty(int productId,
			String propertyId,
			int sequenceNumber,
			Double value,
			String text,
			Date date,
			Date effectiveStart,
			Date effectiveEnd,
			String status,
			int benefitOrder) {

		setProductId(productId);
		setPropertyId(propertyId);
		setSequenceNumber(sequenceNumber);
		setValue(value);
		setText(text);
		setDate(date);
		setEffectiveStart(effectiveStart);
		setEffectiveEnd(effectiveEnd);
		setStatus(status);
		setBenefitOrder(benefitOrder);
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public String getPropertyId() {
		return propertyId;
	}

	public void setPropertyId(String propertyId) {
		this.propertyId = propertyId;
	}

	public int getSequenceNumber() {
		return sequenceNumber;
	}

	public void setSequenceNumber(int sequenceNumber) {
		this.sequenceNumber = sequenceNumber;
	}

	public Double getValue() {
		return value;
	}

	public void setValue(Double value) {
		this.value = value;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
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

	public int getBenefitOrder() {
		return benefitOrder;
	}

	public void setBenefitOrder(int benefitOrder) {
		this.benefitOrder = benefitOrder;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getLongLabel() {
		return longLabel;
	}

	public void setLongLabel(String longLabel) {
		this.longLabel = longLabel;
	}

	public int getHelpId() {
		return helpId;
	}

	public void setHelpId(int helpId) {
		this.helpId = helpId;
	}



}
