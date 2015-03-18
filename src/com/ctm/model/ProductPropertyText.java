package com.ctm.model;

import java.util.Date;
/**
 * ctm.product_properties_text is intended to mimic ctm.product_properties,
 * but only have a TEXT field, instead of VARCHAR that is limited to 640 chars.
 * @author bthompson
 *
 */
public class ProductPropertyText {

	private int productId;
	private String propertyId;
	private int sequenceNumber = 0;
	private String text;
	private Date effectiveStart;
	private Date effectiveEnd;
	private String status;

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
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
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
}
