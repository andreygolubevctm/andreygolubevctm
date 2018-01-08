package com.ctm.web.email;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.safety.Whitelist;

import java.util.List;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * Utility class containing simple Functions.
 */
public class Functions {

    /**
     * Function to strip HTML elements from each string in the provided List.
     */
    public static final Function<List<String>, List<String>> stripHtmlFromStrings = l -> l.stream().map(Functions.stripHtml).collect(Collectors.toList());

    /**
     * Function to strip HTML from a given string, maintaining white space. If a string is null, an empty String will be returned.
     */
    public static final Function<String, String> stripHtml = s -> Optional.ofNullable(s)
            .map(htmlString -> Jsoup.clean(htmlString, "", Whitelist.none(), new Document.OutputSettings().prettyPrint(false)))
            .orElse("");

    private Functions() { /* Private constructor to prevent instantiation. Intentionally Empty. */}
}
