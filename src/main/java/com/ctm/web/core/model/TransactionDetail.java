package com.ctm.web.core.model;

import org.json.JSONException;
import org.json.JSONObject;

import java.sql.Date;

/**
 * Database model for the aggregator.transaction_details table.
 * @author bthompson
 *
 */
public class TransactionDetail extends AbstractJsonModel {

	public static final String JSON_COLLECTION_NAME = "transaction_details";

	private Integer sequenceNo;
	private String xpath;
	private String textValue;
	private Date dateValue;


	/**
	 * The sequence number
	 * @return
	 */
	public Integer getSequenceNo() {
		return sequenceNo;
	}
	public void setSequenceNo(Integer sequenceNo) {
		this.sequenceNo = sequenceNo;
	}

	/**
	 * The field name/xpath in data bucket.
	 * @return
	 */
	public String getXPath() {
		return xpath;
	}
	/**
	 * Set the XPath
	 * @param xpath
	 */
	public void setXPath(String xpath) {
		this.xpath = xpath;
	}

	/**
	 * The value the user submitted
	 * @return
	 */
	public String getTextValue() {
		return textValue;
	}
	/**
	 * Set the textValue
	 * @param textValue
	 */
	public void setTextValue(String textValue) {
		this.textValue = textValue;
	}


	/**
	 * The value the user submitted
	 * @return
	 */
	public Date getDateValue() {
		return dateValue;
	}
	/**
	 * Set the dateValue
	 * @param dateValue
	 */
	public void setDateValue(Date dateValue) {
		this.dateValue = dateValue;
	}

	/**
	 * Add the attributes to the data model JSON object.
	 */
	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("sequenceNo", getSequenceNo());
		json.put("xpath", getXPath());
		json.put("textValue", getTextValue());
		json.put("dateValue", getDateValue());

		return json;
	}
}
