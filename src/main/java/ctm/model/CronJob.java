package com.ctm.model;

import java.sql.Date;


public class CronJob {

	private Integer cronID = null;
	private Integer cronStyleCodeID = null;
	private Integer cronVerticalID = null;
	private String cronFrequency = null;
	private String cronURL = null;
	private Date cronEffectiveStart = null;
	private Date cronEffectiveEnd = null;
	private String cronStatus = null;

	protected static enum CronFrequency {
		DAILY("daily"),
		HOURLY("hourly"),
		QUARTERLY("quarterly");

		private final String frequency;

		CronFrequency(String frequency) {
			this.frequency = frequency;
		}

		public String get() {
			return frequency;
		}
	}

	public void setID(Integer id) {
		cronID = id;
	}

	public Integer getID() {
		return cronID;
	}

	public void setStyleCodeID(Integer id) {
		cronStyleCodeID = id;
	}

	public Integer getStyleCodeID() {
		return cronStyleCodeID;
	}

	public void setVerticalID(Integer id) {
		cronVerticalID = id;
	}

	public Integer getVerticalID() {
		return cronVerticalID;
	}

	public void setFrequency(String frequency) {
		cronFrequency = frequency;
	}

	public String getFrequency() {
		return cronFrequency;
	}

	public void setURL(String url) {
		cronURL = url;
	}

	public String getURL() {
		return cronURL;
	}

	public void setEffectiveStart(Date effective_start) {
		cronEffectiveStart = effective_start;
	}

	public Date getEffectiveStart() {
		return cronEffectiveStart;
	}

	public void setEffectiveEnd(Date effective_end) {
		cronEffectiveEnd = effective_end;
	}

	public Date getEffectiveEnd() {
		return cronEffectiveEnd;
	}

	public void setStatus(String status) {
		cronStatus = status;
	}

	public String getStatus() {
		return cronStatus;
	}
}
