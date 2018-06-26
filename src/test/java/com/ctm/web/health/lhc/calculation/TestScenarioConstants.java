package com.ctm.web.health.lhc.calculation;

import java.time.LocalDate;

public class TestScenarioConstants {

    public static final LocalDate TEST_CALCULATION_DATE = LocalDate.of(2018, 6, 22);

    public static final LocalDate MIKES_BIRTHDAY = LocalDate.of(1981, 12, 23);
    public static final LocalDate MATTS_BIRTHDAY = LocalDate.of(1981, 5, 9);
    public static final LocalDate FIRST_JULY_BIRTHDAY = LocalDate.of(1981, 7, 1);
    public static final LocalDate SECOND_JULY_BIRTHDAY = FIRST_JULY_BIRTHDAY.plusDays(1);
    public static final LocalDate THIRTIETH_JUNE_BIRTHDAY = LocalDate.of(1981, 6, 30);
    public static final LocalDate FIRST_JULY_1969 = LocalDate.of(1969, 7, 1);
    public static final LocalDate TEST_DATE = LocalDate.of(2018, 5, 2);
    public static final int MAX_LHC_APPLICABLE_DAYS = 6515;

}