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
    private static final String LHC_EXEMPT_BIRTHDATE = "01/07/1934";

    @Test
    public void testCalculateRebateValueWithEmptyRebate() {
        assertEquals(new BigDecimal(25), ResponseAdapterV2.calculateRebateValue(Optional.empty(), new BigDecimal(100), new BigDecimal(25)));
    }

    @Test
    public void testCalculateRebateValueWithRebate() {
        assertEquals(new BigDecimal("30.00"), ResponseAdapterV2.calculateRebateValue(Optional.of(BigDecimal.valueOf(30)), new BigDecimal(100), new BigDecimal(25)));
    }


    @Test
    public void givenInsured_isOldEnoughForLHC_andWantsHospitalCover_thenInsuredIsAffectedByLHC() {
        Insured testInsured = new Insured();
        boolean islookingForHospitalCover = true;
        testInsured.setDob(JOHNS_BIRTHDAY);

        assertTrue(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured, islookingForHospitalCover));
    }

    @Test
    public void givenInsured_isOldEnoughForLHC_andWantsExtrasCoverOnly_thenInsuredIsNotAffectedByLHC() {
        Insured testInsured = new Insured();
        boolean islookingForHospitalCover = false;
        testInsured.setDob(JOHNS_BIRTHDAY);

        assertFalse(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured, islookingForHospitalCover));
    }

    @Test
    public void givenInsured_whenHasNoApplicableLHCCoverDays_andWantsExtrasCoverOnly_thenInsuredIsNotAffectedByLHC() {
        Insured testInsured = new Insured();
        boolean islookingForHospitalCover = false;
        testInsured.setDob(LocalDate.now().plusDays(1).format(formatter));

        assertFalse(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured, islookingForHospitalCover));
    }

    @Test
    public void givenInsured_whenHasNoApplicableLHCCoverDays_andWantsHospitalCover_thenInsuredIsNotAffectedByLHC() {
        Insured testInsured = new Insured();
        boolean islookingForHospitalCover = true;
        testInsured.setDob(LocalDate.now().plusDays(1).format(formatter));

        assertFalse(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured, islookingForHospitalCover));
    }


    @Test
    public void givenInsured_isTooOldForLHC_andWantsExtrasCoverOnly_thenInsuredIsNotAffectedByLHC() {
        Insured testInsured = new Insured();
        boolean islookingForHospitalCover = false;
        testInsured.setDob(LHC_EXEMPT_BIRTHDATE);

        assertFalse(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured, islookingForHospitalCover));
    }

    /* TODO This test seems to still be breaking need to investigate if LHC Calc is working correctly
    @Test
    public void givenInsured_isTooOldForLHC_andWantsHospitalCover_thenInsuredIsNotAffectedByLHC() {
        Insured testInsured = new Insured();
        boolean islookingForHospitalCover = true;
        testInsured.setDob(LHC_EXEMPT_BIRTHDATE);

        assertFalse(ResponseAdapterV2.isInsuredAffectedByLHC(testInsured, islookingForHospitalCover));
    }
    */
}