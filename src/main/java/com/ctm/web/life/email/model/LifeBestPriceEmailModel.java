package com.ctm.web.life.email.model;

import com.ctm.web.core.email.model.BestPriceEmailModel;

public class LifeBestPriceEmailModel extends BestPriceEmailModel {

	private String premium;
	private String lifeCover;
	private String tpdCover;
	private String smoker;
	private String traumaCover;
	private String gender;
	private String age;
	private String leadNumber;
	private String occupation;
	private String coverType;
	
	public String getPremium() {
		return premium;
	}

	public void setPremium(String premium) {
		this.premium = premium;
	}

	public String getLifeCover() {
		return lifeCover;
	}

	public void setLifeCover(String lifeCover) {
		this.lifeCover = lifeCover;
	}

	public String getTPDCover() {
		return tpdCover;
	}

	public void setTPDCover(String tpdCover) {
		this.tpdCover = tpdCover;
	}

	public String getSmoker() {
		return smoker;
	}

	public void setSmoker(String smoker) {
		this.smoker = smoker;
	}

	public String getTraumaCover() {
		return traumaCover;
	}

	public void setTraumaCover(String traumaCover) {
		this.traumaCover = traumaCover;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getAge() {
		return age;
	}

	public void setAge(String age) {
		this.age = age;
	}

	public String getLeadNumber() {
		return leadNumber;
	}

	public void setLeadNumber(String leadNumber) {
		this.leadNumber = leadNumber;
	}

	public String getCoverType() {
		return coverType;
	}

	public void setCoverType(String coverType) {
		this.coverType = coverType;
	}

	public String getOccupation() {
		return occupation;
	}

	public void setOccupation(String occupation) {
		this.occupation = occupation;
	}

	@Override
	public String toString() {
		return "LifeBestPriceEmailModel{" +
				"premium='" + premium + '\'' +
				", lifeCover='" + lifeCover + '\'' +
				", tpdCover='" + tpdCover + '\'' +
				", smoker='" + smoker + '\'' +
				", traumaCover='" + traumaCover + '\'' +
				", gender='" + gender + '\'' +
				", age='" + age + '\'' +
				", leadNumber='" + leadNumber + '\'' +
				", occupation='" + occupation + '\'' +
				", coverType='" + coverType + '\'' +
				'}';
	}
}
