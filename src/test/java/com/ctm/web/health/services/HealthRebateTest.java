package com.ctm.web.health.services;

import com.ctm.web.simples.model.ChangeOverRebate;
import com.ctm.web.simples.services.ChangeOverRebatesService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import java.math.BigDecimal;

import static org.junit.Assert.*;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;


public class HealthRebateTest {

    @Mock
    private ChangeOverRebatesService changeOverRebatesService;
    @Mock
    private ChangeOverRebate changeOverRebate;
    private HealthRebate healthRebate;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        when(changeOverRebatesService.getChangeOverRebate(anyString())).thenReturn(changeOverRebate);
        when(changeOverRebate.getPreviousMultiplier()).thenReturn(new BigDecimal("0.8930322720"));
        when(changeOverRebate.getCurrentMultiplier()).thenReturn(new BigDecimal("0.8644552392"));
        when(changeOverRebate.getFutureMultiplier()).thenReturn(new BigDecimal("0.8644552392"));
         healthRebate= new HealthRebate( changeOverRebatesService);
    }

    @Test
    public void calcRebatePrevious() throws Exception {
        String rebateChoice = null;
        String commencementDate = null;
        int age = 20;
        int income = 2;
        healthRebate.calcRebate( rebateChoice,  commencementDate,  age,  income);
        assertEquals("8.930" ,healthRebate.getPreviousRebate());
        assertEquals("26.790" ,healthRebate.getRebateTier0Previous());
        assertEquals("17.860" ,healthRebate.getRebateTier1Previous());
        assertEquals("8.930" ,healthRebate.getRebateTier2Previous());
        assertEquals("0" ,healthRebate.getRebateTier3Previous());
    }

    @Test
    public void calcRebateUnder65() throws Exception {
        String rebateChoice = null;
        String commencementDate = null;
        int age = 20;
        int income = 2;
        healthRebate.calcRebate( rebateChoice,  commencementDate,  age,  income);
        assertEquals("8.644" ,healthRebate.getCurrentRebate());
        assertEquals("8.644" ,healthRebate.getFutureRebate());

        assertEquals("25.933" ,healthRebate.getRebateTier0Current());
        assertEquals("25.933" ,healthRebate.getRebateTier0Future());

        assertEquals("17.289" ,healthRebate.getRebateTier1Current());
        assertEquals("17.289" ,healthRebate.getRebateTier1Future());

        assertEquals("8.644" ,healthRebate.getRebateTier2Current());
        assertEquals("8.644" ,healthRebate.getRebateTier2Future());

        assertEquals("0" ,healthRebate.getRebateTier3Current());
        assertEquals("0" ,healthRebate.getRebateTier3Future());

    }

    @Test
    public void calcRebate65to69() throws Exception {
        String rebateChoice = null;
        String commencementDate = null;
        int age = 65;
        int income = 2;
        healthRebate.calcRebate( rebateChoice,  commencementDate,  age,  income);
        assertEquals("12.966" ,healthRebate.getCurrentRebate());
        assertEquals("30.255" ,healthRebate.getRebateTier0Current());
        assertEquals("21.612" ,healthRebate.getRebateTier1Current());
        assertEquals("12.966" ,healthRebate.getRebateTier2Current());
        assertEquals("0" ,healthRebate.getRebateTier3Current());

    }

    @Test
    public void calcRebate70() throws Exception {
        String rebateChoice = null;
        String commencementDate = null;
        int age = 70;
        int income = 2;
        healthRebate.calcRebate( rebateChoice,  commencementDate,  age,  income);
        assertEquals("17.289" ,healthRebate.getCurrentRebate());
        assertEquals("34.579" ,healthRebate.getRebateTier0Current());
        assertEquals("25.933" ,healthRebate.getRebateTier1Current());
        assertEquals("17.289" ,healthRebate.getRebateTier2Current());
        assertEquals("0" ,healthRebate.getRebateTier3Current());



    }


}