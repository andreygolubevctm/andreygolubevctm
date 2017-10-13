package com.ctm.web.email;

import junitx.framework.ListAssert;
import org.junit.Assert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

public class EmailUtilsTest {

    @Test
    public void testPremiumLabels(){
        EmailUtils emailUtils = new EmailUtils();
        List<String> premiumLables = new ArrayList<>();
        premiumLables.add("OFFLINE");
        premiumLables.add("");
        premiumLables.add(null);
        premiumLables.add("");
        premiumLables.add("OFFLINE");

        List<String> expected = new ArrayList<>();
        expected.add(EmailUtils.ANNUAL_PREMIUM);
        expected.add(EmailUtils.ANNUAL_ONLINE_PREMIUM);
        expected.add(EmailUtils.ANNUAL_ONLINE_PREMIUM);
        expected.add(EmailUtils.ANNUAL_ONLINE_PREMIUM);
        expected.add(EmailUtils.ANNUAL_PREMIUM);

        List<String> actual = emailUtils.getPremiumLabels(premiumLables);
        ListAssert.assertEquals(expected,actual);
    }
}
