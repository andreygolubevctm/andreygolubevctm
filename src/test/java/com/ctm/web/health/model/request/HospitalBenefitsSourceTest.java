package com.ctm.web.health.model.request;

import com.ctm.web.health.quote.model.request.HospitalBenefitsSource;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class HospitalBenefitsSourceTest {

    @Test
    public void testCTM(){
        assertEquals("CTM", HospitalBenefitsSource.CTM.name());
    }

    @Test
    public void testClinicalCategories(){
        assertEquals("CLINICAL_CATEGORIES", HospitalBenefitsSource.CLINICAL_CATEGORIES.name());
    }
}