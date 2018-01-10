package com.ctm.web.email;

import junitx.framework.ListAssert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.junit.Assert.assertThat;

public class EmailUtilsTest {

    private EmailUtils testInstance = new EmailUtils();

    @Test
    public void testPremiumLabels() {

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

        List<String> actual = testInstance.getPremiumLabels(premiumLables);
        ListAssert.assertEquals(expected, actual);
    }

    @Test
    public void givenXMLAndTag_thenReturnXMLTagValue() {
        String valueToExtract = "1139575501.1515372592";
        String xmlString = String.format("<this><gaclientid>%1$s</gaclientid></this>", valueToExtract);

        assertThat(testInstance.getParamFromXml(xmlString, "gaclientid", ""), equalTo(valueToExtract));
    }
}
