package com.ctm.web.health.model.form;

public class Dependant {
    /* As NIB & Qantas do not care as to the day of graduation it is set to 15 */
    private static final String DATE_TEMPLATE = "20%s-%s-15";

    private String title;

    private String firstName;

    private String lastname;

    private String dob;

    private String gender;

    private String school;

    /* Form field only */
    private GradDate gradDate;

    private String schoolDate;

    private String schoolID;

    private String expectedSchoolCompletionDate;

    private String fulltime;

    private String relationship;

    public String getSchool() {
        return school;
    }

    public void setSchool(String school) {
        this.school = school;
    }

    public GradDate getGradDate() {
        return gradDate;
    }

    public void setGradDate(GradDate gradDate) {
        this.gradDate = gradDate;
    }

    /* Derived field is passed to health-apply */
    public String getGraduationDate() {
        if (gradDate == null) {
            return null;
        } else {
            return String.format(DATE_TEMPLATE, gradDate.getCardExpiryYear(), gradDate.getCardExpiryMonth());
        }
    }

    public String getSchoolDate() {
        return schoolDate;
    }

    public void setSchoolDate(String schoolDate) {
        this.schoolDate = schoolDate;
    }

    public String getSchoolID() {
        return schoolID;
    }

    public void setSchoolID(String schoolID) {
        this.schoolID = schoolID;
    }

    public String getExpectedSchoolCompletionDate() {
        return expectedSchoolCompletionDate;
    }

    public void setExpectedSchoolCompletionDate(String expectedSchoolCompletionDate) {
        this.expectedSchoolCompletionDate = expectedSchoolCompletionDate;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

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

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getFulltime() {
        return fulltime;
    }

    public void setFulltime(String fulltime) {
        this.fulltime = fulltime;
    }

    public String getRelationship() {
        return relationship;
    }

    public void setRelationship(String relationship) {
        this.relationship = relationship;
    }
}
