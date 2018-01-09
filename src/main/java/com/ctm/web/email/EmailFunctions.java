package com.ctm.web.email;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.safety.Whitelist;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * Utility class containing simple EmailFunctions.
 */
public class EmailFunctions {

    /**
     * Function to strip HTML elements from each string in the provided List.
     */
    public static final Function<List<String>, List<String>> stripHtmlFromStrings = l -> l.stream().map(EmailFunctions.stripHtml).collect(Collectors.toList());

    /**
     * Function to strip HTML from a given string, maintaining white space. If a string is null, an empty String will be returned.
     */
    public static final Function<String, String> stripHtml = s -> Optional.ofNullable(s)
            .map(htmlString -> Jsoup.clean(htmlString, "", Whitelist.none(), new Document.OutputSettings().prettyPrint(false)))
            .orElse("");

    /**
     * Function to return a String as a BigDecimal, or if the String cannot be parsed, return {@link BigDecimal#ZERO}
     */
    public static final Function<String, BigDecimal> bigDecimalOrZero = s -> {
        try {
            return new BigDecimal(s);
        } catch (NumberFormatException nfe) {
            return BigDecimal.ZERO;
        }
    };

    private EmailFunctions() { /* Private constructor to prevent instantiation. Intentionally Empty. */}
}
