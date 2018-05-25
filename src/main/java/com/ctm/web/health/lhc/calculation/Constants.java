package com.ctm.web.health.lhc.calculation;

import java.time.LocalDate;

/**
 * Utility class containing LHC Calculation constant values.
 */
public final class Constants {

    /**
     * The number of contiguous years of cover after which LHC reverts to zero.
     */
    public static final int CONTIGUOUS_YEARS_COVER_LHC_RESET_THRESHOLD = 10;
    /**
     * The date from which LHC becomes applicable if an applicant is 31 years or older.
     */
    public static final LocalDate JULY_FIRST_2000 = LocalDate.of(2000, 7, 1);
    /**
     * 365 (days) * 3 (years) minus 1 (day).
     */
    public static final int LHC_DAYS_WITHOUT_COVER_THRESHOLD = 1094;
    /**
     * The age in years after which LHC becomes applicable.
     */
    public static final int LHC_EXEMPT_AGE_CUT_OFF = 31;

    /**
     * The base percentage if coverage begins after the calculated LHC Base date
     */
    public static final int NO_COVER_LHC_BASE_PERCENTAGE = 2;

    /**
     * The age in years from which health cover must be obtained.
     */
    public static final int LHC_REQUIREMENT_AGE = 30;
    /**
     * Max LHC Percentage value.
     */
    public static final int MAX_LHC_PERCENTAGE = 70;
    /**
     * Floor LHC Percentage value.
     */
    public static final int MIN_LHC_PERCENTAGE = 0;


    private Constants() { /* Intentionally Empty to prevent instantiation. */}
}
