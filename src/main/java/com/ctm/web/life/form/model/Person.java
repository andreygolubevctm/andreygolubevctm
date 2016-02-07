package com.ctm.web.life.form.model;

import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;

public class Person {

    private String firstName;

    private String lastname;

    private Gender gender;

    @DateTimeFormat(pattern = "dd/MM/yyyy")
    private LocalDate dob;

    private Integer age;

    private Integer hannover;

    private Smoker smoker;

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public Integer getHannover() {
        return hannover;
    }

    public void setHannover(Integer hannover) {
        this.hannover = hannover;
    }

    public Smoker getSmoker() {
        return smoker;
    }

    public void setSmoker(Smoker smoker) {
        this.smoker = smoker;
    }
}
