package com.ctm.web.life.apply.model.request;


import com.ctm.web.core.model.request.Gender;

import java.time.LocalDate;

public class Partner {

    String firstName;
    String lastname;
    Gender gender;
    LocalDate dob;
    Integer age;
    String smoker;
    String occupation;
    String hannover;
    String occupationTitle;

    protected Partner(Builder builder) {
        firstName = builder.firstName;
        lastname = builder.lastname;
        gender = builder.gender;
        dob = builder.dob;
        age = builder.age;
        smoker = builder.smoker;
        occupation = builder.occupation;
        hannover = builder.hannover;
        occupationTitle = builder.occupationTitle;
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


    public static final class Builder {
        private String firstName;
        private String lastname;
        private Gender gender;
        private LocalDate dob;
        private Integer age;
        private String smoker;
        private String occupation;
        private String hannover;
        private String occupationTitle;

        public Builder() {
        }

        public Builder firstName(String val) {
            firstName = val;
            return this;
        }

        public Builder lastname(String val) {
            lastname = val;
            return this;
        }

        public Builder gender(Gender val) {
            gender = val;
            return this;
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

        public Builder occupation(String val) {
            occupation = val;
            return this;
        }

        public Builder hannover(String val) {
            hannover = val;
            return this;
        }

        public Builder occupationTitle(String val) {
            occupationTitle = val;
            return this;
        }

        public Partner build() {
            return new Partner(this);
        }
    }


}
