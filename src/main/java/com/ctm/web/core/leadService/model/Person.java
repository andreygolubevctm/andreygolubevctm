package com.ctm.web.core.leadService.model;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.time.LocalDate;

@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Person {
    private String firstName;
    private String email;
    private String lastName;
    private String mobile;
    private String phone;
    private LocalDate dob;
    private Address address = new Address();

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getEmail() {
        return email;
    }

    public String getLastName() {
        return lastName;
    }

    public String getMobile() {
        return mobile;
    }

    public String getPhone() {
        return phone;
    }

    public LocalDate getDob() {
        return dob;
    }

    public Address getAddress() {
        return address;
    }

    @Override
    public String toString() {
        return "Person{" +
                "firstName=" + firstName +
                ", email=" + email +
                ", lastName=" + lastName +
                ", mobile=" + mobile +
                ", phone=" + phone +
                ", dob=" + dob +
                ", address=" + address +
                '}';
    }
}
