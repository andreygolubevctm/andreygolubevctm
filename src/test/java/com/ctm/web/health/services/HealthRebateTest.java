package com.ctm.web.health.services;

import com.ctm.web.simples.services.ChangeOverRebatesService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static org.junit.Assert.*;
import static org.mockito.MockitoAnnotations.initMocks;


public class HealthRebateTest {

    @Mock
    private ChangeOverRebatesService changeOverRebatesService;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
    }

    @Test
    public void calcRebateUnder65() throws Exception {
        HealthRebate healthRebate= new HealthRebate( changeOverRebatesService);
        String rebateChoice = null;
        String commencementDate = null;
        int age = 20;
        int income = 2;
        healthRebate.calcRebate( rebateChoice,  commencementDate,  age,  income);
        assertEquals("8.644" ,healthRebate.getCurrentRebate());
        assertEquals("8.644" ,healthRebate.getFutureRebate());
        assertEquals("8.93" ,healthRebate.getPreviousRebate());

        assertEquals("26.791" ,healthRebate.getRebateTier0Current());
        assertEquals("25.934" ,healthRebate.getRebateTier0Future());
        assertEquals("25.934" ,healthRebate.getRebateTier0Previous());

        assertEquals("26.791" ,healthRebate.getRebateTier1Current());
        assertEquals("25.934" ,healthRebate.getRebateTier1Future());
        assertEquals("25.934" ,healthRebate.getRebateTier1Previous());

        assertEquals("8.644" ,healthRebate.getRebateTier2Current());
        assertEquals("8.644" ,healthRebate.getRebateTier2Future());
        assertEquals("8.93" ,healthRebate.getRebateTier2Previous());

        assertEquals("0" ,healthRebate.getRebateTier3Current());
        assertEquals("0" ,healthRebate.getRebateTier3Future());
        assertEquals("0" ,healthRebate.getRebateTier3Previous());

    }

}