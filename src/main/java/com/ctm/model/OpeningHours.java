package com.ctm.model;

import org.hibernate.validator.constraints.NotEmpty;
import org.hibernate.validator.constraints.Range;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

public class OpeningHours {

	public int openingHoursId;
	public String startTime;
	public String endTime;
	
	@NotNull(message="Description can not be empty")
	@NotEmpty(message="Description can not be empty")
	public String description;
	
	public String date;
	public String daySequence;
	
	@NotEmpty(message="Hours Type can not be empty and must be either 'H' or 'N' or 'S'")
	@Pattern(regexp="[s|S|n|N|h|H]", message="Hours Type can not be empty and must be either 'H' or 'N' or 'S'")
	public String hoursType;
	
	@NotNull(message="Effective Start date can not be empty")
	@NotEmpty(message="Effective Start date can not be empty")
	public String effectiveStart;
	
	@NotNull(message="Effective End date can not be empty")
	@NotEmpty(message="Effective End date  can not be empty")
	public String effectiveEnd;
	@Range(min=1, message="Vertical ID must be positive Integer")	
	public int verticalId;
	public OpeningHours(){

	}
	public int getOpeningHoursId() {
		return openingHoursId;
	}
	public void setOpeningHoursId(int openingHoursId) {
		this.openingHoursId = openingHoursId;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getDaySequence() {
		return daySequence;
	}
	public void setDaySequence(String daySequence) {
		this.daySequence = daySequence;
	}
	public String getHoursType() {
		return hoursType;
	}
	public void setHoursType(String hoursType) {
		this.hoursType = hoursType!=null?hoursType.toUpperCase():null;
	}
	public String getEffectiveStart() {
		return effectiveStart;
	}
	public void setEffectiveStart(String effectiveStart) {
		this.effectiveStart = effectiveStart;
	}
	public String getEffectiveEnd() {
		return effectiveEnd;
	}
	public void setEffectiveEnd(String effectiveEnd) {
		this.effectiveEnd = effectiveEnd;
	}

	public int getVerticalId() {
		return verticalId;
	}

	public void setVerticalId(int verticalId) {
		this.verticalId = verticalId;
	}
	
}
