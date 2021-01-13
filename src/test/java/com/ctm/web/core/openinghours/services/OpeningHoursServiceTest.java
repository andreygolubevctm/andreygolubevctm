package com.ctm.web.core.openinghours.services;

import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.openinghours.dao.OpeningHoursDao;
import com.ctm.web.core.openinghours.model.OpeningHours;
import com.ctm.web.core.services.SettingsService;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.internal.util.reflection.Whitebox;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.*;

import static org.junit.Assert.*;
import static org.mockito.Matchers.*;
import static org.mockito.Mockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest(SettingsService.class)
public class OpeningHoursServiceTest {

    @Mock
    private OpeningHoursDao openingHoursDao;

    @Mock
    private PageSettings pageSettings;

    @Mock
    private Vertical vertical;

    @Mock
    private HttpServletRequest request;

    @InjectMocks
    private OpeningHoursService openingHoursService;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        PowerMockito.mockStatic(SettingsService.class);
        Whitebox.setInternalState(openingHoursService, "openingHoursDao", openingHoursDao);
    }

    @Test
    public void testGetAllOpeningHoursForDisplay() throws Exception {
        when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);
        when(pageSettings.getVertical()).thenReturn(vertical);
        when(vertical.getId()).thenReturn(4);
        java.util.Date effectiveDate = new GregorianCalendar(2021, Calendar.JANUARY, 11).getTime();
        List<OpeningHours> openingHours = new ArrayList<>();
        openingHours.add(new OpeningHours());
        openingHours.add(new OpeningHours());

        when(openingHoursDao.getAllOpeningHoursForDisplay(anyInt(), any(Date.class))).thenReturn(openingHours);
        List<OpeningHours> resultOpeningHours = openingHoursService.getAllOpeningHoursForDisplay(request);
        Assert.assertNotNull(resultOpeningHours);
        assertTrue(resultOpeningHours.size() == 2);
    }

    @Test
    public void testGetOpeningHoursForDisplay() throws Exception {
        when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);
        when(pageSettings.getVertical()).thenReturn(vertical);
        when(vertical.getId()).thenReturn(4);
        when(openingHoursDao.getOpeningHoursForDisplay(anyString(), any(Date.class), anyInt())).thenReturn("I'm Open");

        String result = openingHoursService.getOpeningHoursForDisplay(request, "S");
        assertEquals("I'm Open", result);
    }

    @Test
    public void testIsCallCentreOpenNow() throws Exception {
        when(openingHoursDao.isCallCentreOpen(anyInt(), any(LocalDateTime.class))).thenReturn(true);
        boolean isOpen = openingHoursService.isCallCentreOpenNow(4, request);
        assertTrue(isOpen);
    }

    @Test
    public void testIsCallCenterOpen() throws Exception {
        when(openingHoursDao.isCallCentreOpen(anyInt(), any(LocalDateTime.class))).thenReturn(false);
        boolean isOpen = openingHoursService.isCallCentreOpenNow(4, request);
        assertFalse(isOpen);
    }

    @Test
    public void testCurrentOpeningHoursForEmail() throws Exception {
        List<OpeningHours> openingHours = new ArrayList<>();
        OpeningHours openingHour = new OpeningHours();
        openingHour.setDescription("Test Day");
        openingHours.add(openingHour);
        when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);
        when(pageSettings.getVertical()).thenReturn(vertical);
        when(vertical.getId()).thenReturn(4);
        when(openingHoursDao.getCurrentNormalOpeningHoursForEmail(anyInt(), any(Date.class))).thenReturn(openingHours);
        when(openingHoursDao.toHTMLString(openingHours)).thenReturn("<h1>Test Day</h1>");
        String htmlResult = openingHoursService.getCurrentOpeningHoursForEmail(request);
        Assert.assertEquals("<h1>Test Day</h1>", htmlResult);
    }
}
