package com.ctm.web.email;

import com.google.common.collect.ImmutableList;
import junitx.framework.ListAssert;
import org.junit.Test;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
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

        List<String> actual = testInstance.getPremiumLabels(premiumLables, 14);
        ListAssert.assertEquals(expected, actual);
    }

    @Test
    public void givenXMLAndTag_thenReturnXMLTagValue() {
        String valueToExtract = "1139575501.1515372592";
        String xmlString = String.format("<this><gaclientid>%1$s</gaclientid></this>", valueToExtract);

        assertThat(testInstance.getParamFromXml(xmlString, "gaclientid", ""), equalTo(valueToExtract));
    }

    @Test
    public void whenListOfStringsWithHtmlTags_thenStripWhilstMaintainingSpacesInEachElement() {
        List<String> expectedResult = ImmutableList.of("Hi ", "There, ", "No ", "Tags ", "Remain ");
        List<String> testStrings = ImmutableList.of("Hi <span/>", "There, <span/>", "No <span/>", "Tags <span/>", "Remain <span/>");
        List<String> result = EmailUtils.stripHtmlFromStrings.apply(testStrings);

        assertThat(result, equalTo(expectedResult));

    }

    @Test
    public void whenStringContainsNestedHtmlElements_thenReturnOnlyText() {
        String testStrings = "Join on combined cover before the end of February and skip 2 and 6 month waits on extras<div><p></p><p></p></div>";
        String expectedResult = "Join on combined cover before the end of February and skip 2 and 6 month waits on extras";
        String result = EmailUtils.stripHtml.apply(testStrings);

        assertThat(result, equalTo(expectedResult));
    }

    @Test
    public void whenListElementsAreNull_thenSafelyHandleNull() {
        String[] testStrings = new String[]{"Join on combined cover before the end of February and skip 2 and 6 month waits on extras<div><p></p><p></p></div>", null};
        ImmutableList<String> expectedResult = ImmutableList.of("Join on combined cover before the end of February and skip 2 and 6 month waits on extras", "");
        List<String> result = EmailUtils.stripHtmlFromStrings.apply(Arrays.asList(testStrings));

        assertThat(result, equalTo(expectedResult));
    }


    @Test
    public void givenAnInvalidBigDecimalString_thenReturnZero() {
        assertThat(EmailUtils.bigDecimalOrZero.apply("NaN"), equalTo(BigDecimal.ZERO));
    }

    @Test
    public void givenAvalidBigDecimalString_thenReturnAsBigDecimal() {
        assertThat(EmailUtils.bigDecimalOrZero.apply("3.14"), equalTo(BigDecimal.valueOf(3.14)));
    }

}
