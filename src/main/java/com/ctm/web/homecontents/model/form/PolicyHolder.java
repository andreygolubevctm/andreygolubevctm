package com.ctm.web.homecontents.model.form;

import com.ctm.web.core.validation.Name;

public class PolicyHolder {

    private String dob;

    private String email;

    @Name
    private String firstName;

    private String jointDob;

    @Name
    private String jointFirstName;

    @Name
    private String jointLastName;

    private String jointTitle;

    @Name
    private String lastName;

    private String marketing;

    private String oktocall;

    private String retired;

    private String phone;

    private String title;


    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getJointDob() {
        return jointDob;
    }

    public void setJointDob(String jointDob) {
        this.jointDob = jointDob;
    }

    public String getJointFirstName() {
        return jointFirstName;
    }

    public void setJointFirstName(String jointFirstName) {
        this.jointFirstName = jointFirstName;
    }

    public String getJointLastName() {
        return jointLastName;
    }

    public void setJointLastName(String jointLastName) {
        this.jointLastName = jointLastName;
    }

    public String getJointTitle() {
        return jointTitle;
    }

    public void setJointTitle(String jointTitle) {
        this.jointTitle = jointTitle;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getMarketing() {
        return marketing;
    }

    public void setMarketing(String marketing) {
        this.marketing = marketing;
    }

    public String getOktocall() {
        return oktocall;
    }

    public void setOktocall(String oktocall) {
        this.oktocall = oktocall;
    }

    public String getRetired() {
        return retired;
    }

    public void setRetired(String retired) {
        this.retired = retired;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
