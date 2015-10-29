package com.ctm.web.core.utils;


import com.ctm.services.EnvironmentService;
import org.junit.Test;

import javax.servlet.ServletContext;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.*;

public class ConfigResolverTest {

    @Test
    public void shouldLoadFileWithEnding() throws IOException {
        String config = "config";
        ConfigResolver resolver = new ConfigResolver(EnvironmentService.Environment.PRO);
        String base = "context.xml";
        String baseProd = "context_PRO.xml";
        ServletContext sc = mock(ServletContext.class);
        InputStream resource = new ByteArrayInputStream(config.getBytes(StandardCharsets.UTF_8));
        when(sc.getResourceAsStream(baseProd)).thenReturn(resource);
        String configReturned = resolver.getConfig(sc, base);
        assertEquals(config, configReturned);
        verify(sc).getResourceAsStream(baseProd);
        verifyNoMoreInteractions(sc);
    }

    @Test
    public void shouldDefaultToNoEndingIfFileDoesNotExist() throws IOException {
        String config = "config";
        ConfigResolver resolver = new ConfigResolver(EnvironmentService.Environment.PRO);
        String base = "context.xml";
        String baseProd = "context_PRO.xml";
        ServletContext sc = mock(ServletContext.class);
        InputStream resource = new ByteArrayInputStream(config.getBytes(StandardCharsets.UTF_8));
        when(sc.getResourceAsStream(baseProd)).thenReturn(null);
        when(sc.getResourceAsStream(base)).thenReturn(resource);
        String configReturned = resolver.getConfig(sc, base);
        assertEquals(config, configReturned);
        verify(sc).getResourceAsStream(baseProd);
        verify(sc).getResourceAsStream(base);
        verifyNoMoreInteractions(sc);
    }

}