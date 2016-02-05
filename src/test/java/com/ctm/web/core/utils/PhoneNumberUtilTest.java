package com.ctm.web.core.utils;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class PhoneNumberUtilTest {

    @Test
    public void testWithOtherChars() throws Exception {
        assertEquals("04123123", PhoneNumberUtil.stripOffNonNumericChars("(04) 123 123"));
    }

    @Test
    public void testWithLetters() throws Exception {
        assertEquals("04123123", PhoneNumberUtil.stripOffNonNumericChars("(04) 123 123 ABC"));
    }

}