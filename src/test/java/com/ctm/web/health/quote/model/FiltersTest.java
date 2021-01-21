package com.ctm.web.health.quote.model;

import com.ctm.web.health.quote.model.request.Filters;
import com.ctm.web.health.quote.model.request.HospitalBenefitsSource;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class FiltersTest {

	final Filters filters = new Filters();

    @Test
    public void testHospitalBenefitsSourceFilter() throws Exception {
		// Test Source 1
		filters.setHospitalBenefitsSource(HospitalBenefitsSource.CLINICAL_CATEGORIES);
		assertEquals(HospitalBenefitsSource.CLINICAL_CATEGORIES, filters.getHospitalBenefitsSource());

		// Test Source 2
		filters.setHospitalBenefitsSource(HospitalBenefitsSource.CTM);
		assertEquals(HospitalBenefitsSource.CTM, filters.getHospitalBenefitsSource());
    }
}