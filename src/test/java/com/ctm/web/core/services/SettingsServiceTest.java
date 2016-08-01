package com.ctm.web.core.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.HttpServletRequest;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

@RunWith(PowerMockRunner.class)
@PrepareForTest( { ApplicationService.class, SettingsService.class})
public class SettingsServiceTest {

    @Mock
    private HttpServletRequest request;
    @Mock
    private Brand brand;
    @Mock
    private Vertical healthVertical;
    @Mock
    private Vertical genericVertical;

    String healthVerticalCode = Vertical.VerticalType.HEALTH.getCode();
    String defaultVerticalCode = Vertical.VerticalType.GENERIC.getCode();

    @Before
    public void setup() throws Exception {
        initMocks(this);
        PowerMockito.mockStatic(ApplicationService.class);
        PowerMockito.when(ApplicationService.getBrandFromRequest(request)).thenReturn(brand);
        when(brand.getVerticalByCode(healthVerticalCode)).thenReturn(healthVertical);
        when(brand.getVerticalByCode(defaultVerticalCode)).thenReturn(genericVertical);
    }

    @Test
    public void testGetPageSettingsForPageDefaultVertical() throws Exception {
        boolean defaultVertical = true;

        PowerMockito.when(ApplicationService.getVerticalCodeFromRequest(request)).thenReturn(healthVerticalCode);
        PageSettings pageSettings = SettingsService.getPageSettingsForPage(request, defaultVertical);
        assertEquals(healthVertical, pageSettings.getVertical());


        PowerMockito.when(ApplicationService.getVerticalCodeFromRequest(request)).thenReturn("");
         pageSettings = SettingsService.getPageSettingsForPage(request, defaultVertical);
        assertEquals(genericVertical, pageSettings.getVertical());

    }

    @Test
    public void testGetPageSettingsForPageNoDefaultVertical() throws Exception {
        boolean defaultVertical = false;

        PowerMockito.when(ApplicationService.getVerticalCodeFromRequest(request)).thenReturn(healthVerticalCode);
        PageSettings pageSettings = SettingsService.getPageSettingsForPage(request, defaultVertical);
        assertEquals(healthVertical, pageSettings.getVertical());

    }

    @Test(expected = ConfigSettingException.class)
    public void testGetPageSettingsForPageNoDefaultVerticalNotSet() throws Exception {
        boolean defaultVertical = false;
        PowerMockito.when(ApplicationService.getVerticalCodeFromRequest(request)).thenReturn("");
        SettingsService.getPageSettingsForPage(request, defaultVertical);
    }
}