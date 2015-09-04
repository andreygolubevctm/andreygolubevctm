package com.ctm.model.request.health;

public class UserDetails {

    private String rootPath;
    private UserContactDetails questionSet = new UserContactDetails();
    private UserContactDetails application = new UserContactDetails();

    private String firstname;
    private String lastname;

    public UserContactDetails getQuestionSet() {
        return questionSet;
    }

    public void setQuestionSet(UserContactDetails questionSet) {
        this.questionSet = questionSet;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public String getRootPath() {
        return rootPath;
    }

    public void setRootPath(String rootPath) {
        this.rootPath = rootPath;
    }

    @Override
    public String toString() {
        return "UserDetails{" +
                "rootPath=" + rootPath +
                ", firstname='" + firstname + '\'' +
                ", lastname='" + lastname + '\'' +
                ", questionSet='" + questionSet + '\'' +
                ", application='" + application + '\'' +
                '}';
    }
}
