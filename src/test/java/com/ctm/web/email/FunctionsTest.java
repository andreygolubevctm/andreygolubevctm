package com.ctm.web.email;

import com.google.common.collect.ImmutableList;
import org.junit.Test;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.junit.Assert.assertThat;

public class FunctionsTest {

    @Test
    public void whenListOfStringsWithHtmlTags_thenStripWhilstMaintainingSpacesInEachElement() {
        List<String> expectedResult = ImmutableList.of("Hi ", "There, ", "No ", "Tags ", "Remain ");
        List<String> testStrings = ImmutableList.of("Hi <span/>", "There, <span/>", "No <span/>", "Tags <span/>", "Remain <span/>");
        List<String> result = Functions.stripHtmlFromStrings.apply(testStrings);

        assertThat(result, equalTo(expectedResult));

    }

    @Test
    public void whenStringContainsNestedHtmlElements_thenReturnOnlyText() {
        String testStrings = "Join on combined cover before the end of February and skip 2 and 6 month waits on extras<div><p></p><p></p></div>";
        String expectedResult = "Join on combined cover before the end of February and skip 2 and 6 month waits on extras";
        String result = Functions.stripHtml.apply(testStrings);

        assertThat(result, equalTo(expectedResult));
    }

    @Test
    public void whenListElementsAreNull_thenSafelyHandleNull() {
        String[] testStrings = new String[]{"Join on combined cover before the end of February and skip 2 and 6 month waits on extras<div><p></p><p></p></div>", null};
        ImmutableList<String> expectedResult = ImmutableList.of("Join on combined cover before the end of February and skip 2 and 6 month waits on extras", "");
        List<String> result = Functions.stripHtmlFromStrings.apply(Arrays.asList(testStrings));

        assertThat(result, equalTo(expectedResult));
    }


    @Test
    public void givenAnInvalidBigDecimalString_thenReturnZero() {
        assertThat(Functions.bigDecimalOrZero.apply("NaN"), equalTo(BigDecimal.ZERO));
    }

    @Test
    public void givenAvalidBigDecimalString_thenReturnAsBigDecimal() {
        assertThat(Functions.bigDecimalOrZero.apply("3.14"), equalTo(BigDecimal.valueOf(3.14)));
    }

}