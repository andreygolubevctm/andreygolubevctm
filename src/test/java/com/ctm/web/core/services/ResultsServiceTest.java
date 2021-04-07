package com.ctm.web.core.services;

import org.junit.Assert;
import org.junit.Test;

import java.util.Arrays;

public class ResultsServiceTest {

    @Test
    public void testVericalListItems() {
        Assert.assertEquals(Arrays.asList("HOME"), ResultsService.VERTICAL_LIST);
    }

}
