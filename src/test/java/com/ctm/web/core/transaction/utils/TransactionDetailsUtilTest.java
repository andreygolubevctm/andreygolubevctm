package com.ctm.web.core.transaction.utils;

import org.apache.commons.lang3.StringUtils;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class TransactionDetailsUtilTest {

    @Test
    public void testWithNoTruncate() {
        final String textValueHere = TransactionDetailsUtil.checkLengthTextValue("TextValueHere");
        assertEquals("TextValueHere", textValueHere);
    }

    @Test
    public void testWithTruncate() {
        final String value = StringUtils.leftPad("a", TransactionDetailsUtil.TEXT_VALUE_LENGTH) + "xxx";
        final String textValueHere = TransactionDetailsUtil.checkLengthTextValue(value);
        assertEquals(StringUtils.leftPad("a", TransactionDetailsUtil.TEXT_VALUE_LENGTH), textValueHere);
    }


}