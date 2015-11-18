package com.ctm.web.core.jaxb;

import org.joda.time.LocalDate;
import org.joda.time.LocalTime;

public class Binder {

    public static LocalDate parseLocalDate(final String s) {
        try {
            return new LocalDateAdapter().unmarshal(s);
        } catch (Exception e) {
            return null;
        }
    }

    public static String printLocalDate(final LocalDate d) {
        try {
            return new LocalDateAdapter().marshal(d);
        } catch (Exception e) {
            return null;
        }
    }

    public static LocalTime parseLocalTime(final String s) {
        try {
            return new LocalTimeAdapter().unmarshal(s);
        } catch (Exception e) {
            return null;
        }
    }

    public static String printLocalTime(final LocalTime t)  {
        try {
            return new LocalTimeAdapter().marshal(t);
        } catch (Exception e) {
            return null;
        }
    }

}
