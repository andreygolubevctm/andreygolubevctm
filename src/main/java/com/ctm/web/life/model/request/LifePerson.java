package com.ctm.web.life.model.request;

import com.ctm.web.core.model.request.Gender;
import com.ctm.web.core.model.request.PersonAlt;
import com.ctm.web.core.validation.FortyCharHash;

import java.time.LocalDate;

public class LifePerson extends PersonAlt {

	@FortyCharHash
	private String occupation;

	private Insurance insurance;
	private Gender gender;
	private LocalDate dob;
	private Integer age;
	private String smoker;
	private String hannover;
	private String occupationTitle;

	protected LifePerson(Builder builder) {
		firstName = builder.firstName;
		lastname = builder.lastname;
		gender = builder.gender;
		dob = builder.dob;
		age = builder.age;
		smoker = builder.smoker;
		occupation = builder.occupation;
		hannover = builder.hannover;
		occupationTitle = builder.occupationTitle;
		insurance  = builder.insurance;
	}

	protected LifePerson() {

	}

	public String getFirstName() {
		return firstName;
	}

	public String getLastname() {
		return lastname;
	}

	public Gender getGender() {
		return gender;
	}

	public LocalDate getDob() {
		return dob;
	}

	public Integer getAge() {
		return age;
	}

	public String getSmoker() {
		return smoker;
	}

	public String getOccupation() {
		return occupation;
	}

	public String getHannover() {
		return hannover;
	}

	public String getOccupationTitle() {
		return occupationTitle;
	}

	public Insurance getInsurance() {
		return insurance;
	}

	public static class Builder<T extends LifePerson.Builder> {
		private String firstName;
		private String lastname;
		private Gender gender;
		private LocalDate dob;
		private Integer age;
		private String smoker;
		private String occupation;
		private String hannover;
		private String occupationTitle;
		private Insurance insurance;

		public Builder() {
		}

		public T firstName(String val) {
			firstName = val;
			return (T)  this;
		}

		public T lastname(String val) {
			lastname = val;
			return (T)  this;
		}

		public T gender(Gender val) {
			gender = val;
			return (T)  this;
		}

		public Builder dob(LocalDate val) {
			dob = val;
			return this;
		}

		public Builder age(Integer val) {
			age = val;
			return this;
		}

		public Builder smoker(String val) {
			smoker = val;
			return this;
		}

		public T occupation(String val) {
			occupation = val;
			return (T)  this;
		}

		public Builder hannover(String val) {
			hannover = val;
			return this;
		}

		public Builder occupationTitle(String val) {
			occupationTitle = val;
			return this;
		}

		public LifePerson build() {
			return new LifePerson(this);
		}

		public T insurance(Insurance val) {
			insurance = val;
			return ( T ) this;
		}
	}

}
