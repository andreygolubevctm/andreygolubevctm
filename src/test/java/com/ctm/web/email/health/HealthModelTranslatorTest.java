package com.ctm.web.email.health;

import com.google.common.collect.ImmutableList;
import org.junit.Test;

import java.util.List;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.junit.Assert.*;

public class HealthModelTranslatorTest {

    @Test
    public void ensureNoHtmlSpanTags() {
        List<String> expectedResult = ImmutableList.of("Hi ", "There, ", "No ", "Tags ", "Remain ");
        List<String> testStrings = ImmutableList.of("Hi <span/>", "There, <span/>", "No <span/>", "Tags <span/>", "Remain <span/>");
        List<String> result = HealthModelTranslator.removeEmptySpanTags.apply(testStrings);

        assertThat(result, equalTo(expectedResult));

    }

}