package com.ctm.web.simples.phone.inin.model;

import com.ctm.interfaces.common.types.ValueType;

import java.util.Map;

@SuppressWarnings("PMD.ClassWithOnlyPrivateConstructorsShouldBeFinal")
public class SearchResult extends ValueType<Map<String, String>> {

    private SearchResult(final Map<String, String> value) {
        super(value);
    }

    public static SearchResult instanceOf(final Map<String, String> value) {
        return new SearchResult(value);
    }

}