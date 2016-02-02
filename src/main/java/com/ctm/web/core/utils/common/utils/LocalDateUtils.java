package com.ctm.web.core.utils.common.utils;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

public class LocalDateUtils {

    public static final DateTimeFormatter AUS_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    public static final DateTimeFormatter ISO_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public static LocalDate parseAUSLocalDate(String value) {
        return Optional.ofNullable(value)
                .map(v -> LocalDate.parse(v, AUS_FORMAT))
                .orElse(null);
    }

    public static LocalDate parseISOLocalDate(String value) {
        return Optional.ofNullable(value)
                .map(v -> LocalDate.parse(v, ISO_FORMAT))
                .orElse(null);
    }

}
