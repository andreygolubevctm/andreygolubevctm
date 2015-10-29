package com.ctm.services;

import com.ctm.web.core.dao.HandoverConfirmationDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.model.HandoverConfirmation;
import com.ctm.model.settings.Vertical;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import static com.ctm.model.Touch.TouchType.SOLD;
import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.*;

public class HandoverConfirmationServiceTest {
    AccessTouchService touchService;
    HandoverConfirmationDao dao;
    HandoverConfirmationService service;
    private HandoverConfirmation confirm;

    @Before
    public void setup() {
        touchService = Mockito.mock(AccessTouchService.class);
        dao = Mockito.mock(HandoverConfirmationDao.class);
        service = new HandoverConfirmationService(touchService, dao);
        confirm = new HandoverConfirmation(new Date(1415921541L * 1000), new Date(1415921545L * 1000), "NH522821", "Domestic", "Budget Direct", new BigDecimal("647.8"), "AGIS-TRAVEL-1", 5, Vertical.VerticalType.HEALTH, 50881, "127.0.0.1", "T", false);
    }

    @Test
    public void confirmWhenNoTouchOrConfirmation() throws DaoException {
        when(touchService.hasTouch(50881, SOLD)).thenReturn(false);
        when(dao.hasExistingConfirmationWithPolicy(confirm)).thenReturn(false);

        service.confirm(confirm);
        verify(touchService, times(1)).recordTouch(anyInt(), anyString());
        verify(dao, times(1)).recordConfirmation(Mockito.<HandoverConfirmation>anyObject());
    }

    @Test
    public void confirmWhenNoTouchButHasConfirmation() throws  DaoException {
        when(touchService.hasTouch(50881, SOLD)).thenReturn(false);
        when(dao.hasExistingConfirmationWithPolicy(confirm)).thenReturn(true);

        service.confirm(confirm);
        verify(touchService, times(1)).recordTouch(anyInt(), anyString());
        verify(dao, never()).recordConfirmation(Mockito.<HandoverConfirmation>anyObject());
    }

    @Test
    public void confirmWhenHasTouchButNoConfirmation() throws  DaoException {
        when(touchService.hasTouch(50881, SOLD)).thenReturn(true);
        when(dao.hasExistingConfirmationWithPolicy(confirm)).thenReturn(false);

        service.confirm(confirm);
        verify(touchService, never()).recordTouch(anyInt(), anyString());
        verify(dao, times(1)).recordConfirmation(Mockito.<HandoverConfirmation>anyObject());
    }

    @Test
    public void confirmWhenHasTouchAndConfirmation() throws  DaoException {
        when(touchService.hasTouch(50881, SOLD)).thenReturn(true);
        when(dao.hasExistingConfirmationWithPolicy(confirm)).thenReturn(true);

        service.confirm(confirm);
        verify(touchService, never()).recordTouch(anyInt(), anyString());
        verify(dao, never()).recordConfirmation(Mockito.<HandoverConfirmation>anyObject());
    }

    @Test
    @SuppressWarnings("unchecked")
    public void createConfirmation() throws Exception {
        final Map<String, String[]> values1 = confirm("HEALTH", "5", "NH522821", "647.8", "Domestic", "Budget Direct", "nf041x", "nf0421", "AGIS-TRAVEL-1", "50881", "T", "0");
        assertEquals(confirm, service.createConfirmation(values1, "127.0.0.1"));

        final Map<String, String[]> values2 = confirm("TRAVEL", "8", "somet else", "5698.34", "Pluto", "Meerkats", "nf0421", "nf041x", null, "50831", "1", "1");
        final HandoverConfirmation confirm2 = new HandoverConfirmation(new Date(1415921545L * 1000), new Date(1415921541L * 1000), "somet else", "Pluto", "Meerkats", new BigDecimal("5698.34"), null, 8, Vertical.VerticalType.TRAVEL, 50831, "192.168.1.1", "1", true);
        assertEquals(confirm2, service.createConfirmation(values2, "192.168.1.1"));
    }

    private Map<String, String[]> confirm(final String v, final String pid, final String policyno, final String premium, final String type,
      final String name, final String c, final String u, final String pd, final String tid, final String sent, final String test) {
        final Map<String, String[]> values = new HashMap<>();
        values.put("v", new String[]{v});
        values.put("pid", new String[]{pid});
        values.put("policyno", new String[]{policyno});
        values.put("premium", new String[]{premium});
        values.put("type", new String[]{type});
        values.put("name", new String[]{name});
        values.put("c", new String[]{c});
        values.put("u", new String[]{u});
        values.put("pd", new String[]{pd});
        values.put("tid", new String[]{tid});
        values.put("sent", new String[]{sent});
        values.put("test", new String[]{test});
        return values;
    }
}