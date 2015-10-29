package com.ctm.web.life.email.model;

import com.ctm.web.core.model.email.BestPriceEmailModel;

public class LifeBestPriceEmailModel extends BestPriceEmailModel {

	private String premium;
	private String LifeCover;
	private String TPDCover;
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
		return LifeCover;
	}

	public void setLifeCover(String lifeCover) {
		this.LifeCover = lifeCover;
	}

	public String getTPDCover() {
		return TPDCover;
	}

	public void setTPDCover(String tPDCover) {
		this.TPDCover = tPDCover;
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
				", LifeCover='" + LifeCover + '\'' +
				", TPDCover='" + TPDCover + '\'' +
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
