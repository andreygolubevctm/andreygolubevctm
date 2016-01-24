package com.ctm.web.core.utils;

public class PhoneNumberUtil {

    public static String stripOffNonNumericChars(String phone) {
        if (phone != null) {
            return phone.replaceAll("[^0-9]+", "");
        }
        return phone;
    }

}
