package com.ctm.web.core.intercepter;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class SpringFormParamMapInInterceptorTest {

    private SpringFormParamMapInInterceptor interceptor;

    @Before
    public void setup() {
        interceptor = new SpringFormParamMapInInterceptor();
    }

    @Test
    public void noReplace() throws Exception {
        assertEquals("test", interceptor.addBracketsOfNumberedSuffix("test"));
    }

    @Test
    public void noReplaceWithNumbersPrefix() throws Exception {
        assertEquals("123test", interceptor.addBracketsOfNumberedSuffix("123test"));
    }

    @Test
    public void noReplaceWithNumbersMid() throws Exception {
        assertEquals("test123test", interceptor.addBracketsOfNumberedSuffix("test123test"));
    }

    @Test
    public void withReplace() throws Exception {
        assertEquals("test[123]", interceptor.addBracketsOfNumberedSuffix("test123"));
    }

    @Test
    public void withReplace1() throws Exception {
        assertEquals("test[0123]", interceptor.addBracketsOfNumberedSuffix("test0123"));
    }
}