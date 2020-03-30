package com.ctm.web.core.filter;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class SpringFormParamMapFilterTest {

    private SpringFormParamMapFilter filter;

    @Before
    public void setup() {
        filter = new SpringFormParamMapFilter();
    }

    @Test
    public void noReplace() throws Exception {
        assertEquals("test", filter.addBracketsOfNumberedSuffix("test"));
    }

    @Test
    public void noReplaceWithNumbersPrefix() throws Exception {
        assertEquals("123test", filter.addBracketsOfNumberedSuffix("123test"));
    }

    @Test
    public void noReplaceWithNumbersMid() throws Exception {
        assertEquals("test123test", filter.addBracketsOfNumberedSuffix("test123test"));
    }

    @Test
    public void withReplace() throws Exception {
        assertEquals("test[123]", filter.addBracketsOfNumberedSuffix("test123"));
    }

    @Test
    public void withReplace1() throws Exception {
        assertEquals("test[0123]", filter.addBracketsOfNumberedSuffix("test0123"));
    }
}
