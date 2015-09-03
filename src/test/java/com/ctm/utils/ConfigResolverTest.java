package com.ctm.utils;


import com.ctm.services.EnvironmentService;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class ConfigResolverTest {

    @Test
    public void shouldGetConfigUrl() throws Exception {
        ConfigResolver  configResolver= new ConfigResolver(EnvironmentService.Environment.LOCALHOST);
        assertEquals("path/test.xml" , configResolver.getConfigUrl("path/test.xml"));
        configResolver= new ConfigResolver(EnvironmentService.Environment.PRO);
        assertEquals("path/test_PRO.xml" , configResolver.getConfigUrl("path/test.xml"));

    }
}