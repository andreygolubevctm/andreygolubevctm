package com.ctm.web.core.leadfeed.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.validator.constraints.NotBlank;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Arrays;

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(value = JsonInclude.Include.ALWAYS)
public class Person implements Serializable {

    private static final int AU_TELEPHONE_LENGTH = 10;
    private static final String NOT_DIGIT = "[^\\d]";
    private static final String AU_DIGITAL_MOBILE_CODE = "04";
    private static final String GEOGRAPHIC_CODE_QLD = "07";
    public static final String GEOGRAPHIC_CODE_SA_NT_WA = "08";
    public static final String GEOGRAPHIC_CODE_NSW_ACT = "02";
    public static final String GEOGRAPHIC_CODE_VIC_TAS = "03";

    @NotBlank
    private String firstName;
    @NotNull
    private Address address;
    //has to be valid, and one of mobile or phone has to be there.
    //Can be replaced by class level validator when have time.
    private String mobile;
    private String phone;
    //Optional properties
    private String email;
    private String lastName;
    private String dob;

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        if (isValidMobile(mobile)) this.mobile = mobile;
        else this.mobile = null;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        if (isValidPhone(phone)) this.phone = phone;
        else this.phone = null;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public static boolean hasValidMobileOrPhone(final Person person) {
        if (person == null || (!isValidPhone(person.getPhone()) && !isValidMobile(person.getMobile()))) {
            return false;
        }
        return true;
    }

    /**
     * returns true if given phone number is valid.
     * <p>
     * valid: Must be landline number starting with 07,08,02,03 - no spaces or international prefixes allowed
     *
     * @param phoneNumber
     * @return true if valid, else false.
     */
    public static boolean isValidPhone(final String phoneNumber) {
        final String numbersOnly = getNumbersOnly(phoneNumber);
        if (StringUtils.length(numbersOnly) != AU_TELEPHONE_LENGTH || !isValidGeographicCode(numbersOnly.substring(0, 2))) {
            return false;
        }
        return true;
    }

    /**
     * Must be mobile number starting with 04 - no spaces or international prefixes allowed
     *
     * @param mobileNumber
     * @return
     */
    public static boolean isValidMobile(final String mobileNumber) {
        final String numbersOnly = getNumbersOnly(mobileNumber);
        if (StringUtils.length(numbersOnly) != AU_TELEPHONE_LENGTH || !isValidDigitalMobileCode(numbersOnly.substring(0, 2))) {
            return false;
        }
        return true;
    }

    /**
     * returns only the digits/numbers from given input.
     *
     * @param input
     * @return empty string or string with numbers only.
     */
    private static String getNumbersOnly(final String input) {
        if (StringUtils.isBlank(input)) return "";
        return input.replaceAll(NOT_DIGIT, "");
    }

    private static boolean isValidGeographicCode(final String code) {
        return Arrays.asList(GEOGRAPHIC_CODE_QLD, GEOGRAPHIC_CODE_SA_NT_WA, GEOGRAPHIC_CODE_NSW_ACT, GEOGRAPHIC_CODE_VIC_TAS).stream().anyMatch(item -> StringUtils.equals(item, code));
    }

    private static boolean isValidDigitalMobileCode(final String code) {
        return StringUtils.equals(AU_DIGITAL_MOBILE_CODE, code);
    }

    @Override
    public String toString() {
        return "Person{" +
                "firstName='" + firstName + '\'' +
                ", address=" + address +
                ", mobile='" + mobile + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", lastName='" + lastName + '\'' +
                ", dob='" + dob + '\'' +
                '}';
    }
}
