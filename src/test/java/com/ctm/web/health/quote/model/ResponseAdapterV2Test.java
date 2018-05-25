package com.ctm.web.health.quote.model;

import com.ctm.web.health.model.form.Insured;
import org.junit.Test;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

import static junit.framework.TestCase.assertTrue;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;

public class ResponseAdapterV2Test {

    private static DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final String JOHNS_BIRTHDAY = "25/07/1983";

    @Test
    public void testCalculateRebateValueWithEmptyRebate() {
        assertEquals(new BigDecimal(25), ResponseAdapterV2.calculateRebateValue(Optional.empty(), new BigDecimal(100), new BigDecimal(25)));
    }

    @Test
    public void testCalculateRebateValueWithRebate() {
        assertEquals(new BigDecimal("30.00"), ResponseAdapterV2.calculateRebateValue(Optional.of(BigDecimal.valueOf(30)), new BigDecimal(100), new BigDecimal(25)));
    }


    @Test
    public void givenInsured_whenHasCover_andNoHealthCoverLoading_thenInsuredIsAffectedByLHC() {
        Insured testInsured = new Insured();
        testInsured.setDob(JOHNS_BIRTHDAY);
        testInsured.setCover("Y");
        testInsured.setHealthCoverLoading("N");

        assertTrue(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured));
    }

    @Test
    public void givenInsured_whenHasNoCover_andHasPreviouslyHasCover_thenInsuredIsAffectedByLHC() {
        Insured testInsured = new Insured();
        testInsured.setDob(JOHNS_BIRTHDAY);
        testInsured.setCover("N");
        testInsured.setEverHadCover("Y");

        assertTrue(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured));
    }

    @Test
    public void givenInsured_whenHasNoApplicableLHCCoverDays_thenInsuredIsNotAffectedByLHC() {
        Insured testInsured = new Insured();
        testInsured.setDob(LocalDate.now().plusDays(1).format(formatter));

        assertFalse(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured));
    }

    @Test
    public void givenInsured_whenHasNoCover_andNoHealthCoverLoading_thenInsuredIsNotAffectedByLHC() {
        Insured testInsured = new Insured();
        testInsured.setDob(LocalDate.now().plusDays(1).format(formatter));
        testInsured.setCover("N");
        testInsured.setEverHadCover("N");

        assertFalse(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured));
    }

}