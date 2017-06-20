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
    public void calcRebate() throws Exception {
        HealthRebate healthRebate= new HealthRebate( changeOverRebatesService);
        String rebateChoice = null;
        String commencementDate = null;
        int age = 0;
        int income = 0;
        healthRebate.calcRebate( rebateChoice,  commencementDate,  age,  income);

    }

}