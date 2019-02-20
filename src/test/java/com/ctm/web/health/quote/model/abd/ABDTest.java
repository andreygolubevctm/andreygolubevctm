package com.ctm.web.health.quote.model.abd;

import org.junit.Test;

import java.time.LocalDate;
import java.util.Arrays;

import static com.ctm.web.health.quote.model.abd.ABD.ABD_INTRO_DATE;
import static com.ctm.web.health.quote.model.abd.ABD.FOURTY_ONE;
import static com.ctm.web.health.quote.model.abd.ABD.THIRTY;
import static org.junit.Assert.assertEquals;

public class ABDTest {

    public static final LocalDate TEST_DATE = LocalDate.of(2019, 3, 15);
    public static final LocalDate TEST_DATE_OF_BIRTH = LocalDate.of(1981, 3, 31);


    @Test
    public void givenDateAndDateOfBirth_thenCalculateAgeInYears() {
        long ageInYears = ABD.calculateAgeInYearsFrom(TEST_DATE_OF_BIRTH, TEST_DATE);
        assertEquals(38, ageInYears);
    }

    @Test
    public void givenDateAndDateOfBirth_whenCalculatingBeforeApril12019_thenUseABDIntroDate() {
        long ageInYearsUsingABDDate = ABD.calculateAgeInYearsFrom(TEST_DATE_OF_BIRTH, ABD_INTRO_DATE);
        long ageInYears = ABD.calculateAgeInYearsFrom(TEST_DATE_OF_BIRTH, TEST_DATE);
        assertEquals(38, ageInYearsUsingABDDate);
        assertEquals("If the Test Date is prior to the ABD Intro Date, always use the ABD Intro Date", ageInYears, ageInYearsUsingABDDate);
    }

    @Test
    public void givenDateOfBirth_thenCalculateAgeInYears() {
        LocalDate turnedOneToday = LocalDate.now().minusYears(1);
        long ageInYears = ABD.calculateAgeInYearsFrom(turnedOneToday, LocalDate.now());
        assertEquals(1, ageInYears);
    }

    @Test
    public void givenAge16_thenReturn0ABD() {
        int ageInYears = ABD.calculateAgeInYearsFrom(LocalDate.of(2002, 4, 30), LocalDate.of(2019, 2, 28));
        assertEquals(16, ageInYears);
        assertCorrectABDPercentage(0, ageInYears);
    }

    @Test
    public void givenAgeLessThan18_thenReturnZeroABD() {
        for (int age = 0; age < 18; age++) {
            assertCorrectABDPercentage(0, age);
        }
    }

    @Test
    public void givenDateAndDateOfBirth_whenAgeBelowZero_thenReturnZero() {
        LocalDate bornTomorrow = LocalDate.now().plusDays(1);
        long ageInYears = ABD.calculateAgeInYearsFrom(bornTomorrow, LocalDate.now());
        assertEquals(0, ageInYears);
    }

    @Test
    public void givenAgeBetween18and25_thenReturn10() {
        for (int age = 18; age <= 25; age++) {
            assertCorrectABDPercentage(10, age);
        }
    }

    @Test
    public void givenAgeBetween30and41_thenReturn0() {
        for (int age = THIRTY; age <= FOURTY_ONE; age++) {
            assertCorrectABDPercentage(0, age);
        }
    }

    @Test
    public void givenAge26_thenReturn8() {
        assertCorrectABDPercentage(8, 26);
    }


    @Test
    public void givenAge27_thenReturn6() {
        assertCorrectABDPercentage(6, 27);
    }

    @Test
    public void givenAge28_thenReturn4() {
        assertCorrectABDPercentage(4, 28);
    }


    @Test
    public void givenAge29_thenReturn2() {
        assertCorrectABDPercentage(2, 29);
    }

    @Test
    public void givenAgeBelowZero_thenReturn0() {
        assertCorrectABDPercentage(0, Integer.MIN_VALUE);
    }

    @Test
    public void givenTwoAges_when25And26_thenReturn9() {
        assertCorrectABDPercentage(9, 25, 26);
    }

    @Test
    public void givenTwoAges_when25And27_thenReturn8() {
        assertCorrectABDPercentage(8, 25, 27);
    }

    @Test
    public void givenTwoAges_when25And28_thenReturn7() {
        assertCorrectABDPercentage(7, 25, 28);
    }

    @Test
    public void givenTwoAges_when25And29_thenReturn6() {
        assertCorrectABDPercentage(6, 25, 29);
    }

    @Test
    public void givenTwoAges_when25And30_thenReturn5() {
        assertCorrectABDPercentage(5, 25, 30);
    }

    @Test
    public void givenTwoAges_when25And31_thenReturn5() {
        assertCorrectABDPercentage(5, 25, 31);
    }

    @Test
    public void givenTwoAges_when26And29_thenReturn5() {
        assertCorrectABDPercentage(5, 26, 29);
    }

    @Test
    public void givenTwoAges_when27And29_thenReturn4() {
        assertCorrectABDPercentage(4, 27, 29);
    }

    @Test
    public void givenTwoAges_when28And29_thenReturn3() {
        assertCorrectABDPercentage(3, 28, 29);
    }

    @Test
    public void givenTwoAges_whenBothAged29_thenReturn2() {
        assertCorrectABDPercentage(2, 29, 29);
    }


    @Test
    public void givenTwoAges_whenBothAgedTheSame_thenReturnTheSameAsOnePerson() {
        for (int age = 0; age <= FOURTY_ONE; age++) {
            int expected = ABD.getAgeBasedDiscount(age);
            assertCorrectABDPercentage(expected, age, age);
        }
    }

    private static void assertCorrectABDPercentage(int expected, int... age) {
        assertEquals(String.format("Age '%1$s' should yield ABD of %2$s%%", Arrays.toString(age), expected), expected, ABD.getAgeBasedDiscount(age));
    }
}