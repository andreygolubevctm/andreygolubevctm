package com.ctm.web.core.content.services;

import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.SettingsService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.HttpServletRequest;

import static junit.framework.TestCase.assertFalse;
import static junit.framework.TestCase.assertTrue;
import static org.powermock.api.mockito.PowerMockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest( { ConfigService.class, SettingsService.class})
public class ConfigServiceTest {

    @Mock
    private PageSettings pageSettings;
    @Mock
    private HttpServletRequest request;

    private ConfigService configService;

    @Before
    public void setUp() throws Exception {
        PowerMockito.mockStatic(SettingsService.class);
        when(SettingsService.getPageSettingsForPage(request, true)).thenReturn(pageSettings);
        configService = new ConfigService();
    }

    @Test
    public void testGetConfigValueBoolean() throws Exception {
        String configCode = "configCode";
        when(pageSettings.getSettingAsBoolean(configCode)).thenReturn(true);
        boolean result = configService.getConfigValueBoolean(request, configCode);
        assertTrue(result);
        when(pageSettings.getSettingAsBoolean(configCode)).thenReturn(false);
        result = configService.getConfigValueBoolean(request, configCode);
        assertFalse(result);
    }
}