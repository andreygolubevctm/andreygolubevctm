package com.ctm.web.simples.phone.inin.model;

import com.fasterxml.jackson.annotation.JsonAnySetter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import static java.util.stream.Collectors.toList;

public class SearchWithFilterResults {
    private List<List<SearchResult>> results = new ArrayList<>();

    private SearchWithFilterResults() {
    }

    public SearchWithFilterResults(final List<List<SearchResult>> results) {
        this.results = results;
    }

    public List<List<SearchResult>> getResults() {
        return results;
    }

    @JsonAnySetter
    private void setResults(final String key, final List<Map<String, String>> value) {
        final List<SearchResult> searchResults = value.stream().map(SearchResult::instanceOf).collect(toList());
        results.add(searchResults);
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final SearchWithFilterResults that = (SearchWithFilterResults) o;
        return Objects.equals(results, that.results);
    }

    @Override
    public int hashCode() {
        return Objects.hash(results);
    }

    @Override
    public String toString() {
        return "SearchResults{" +
                "results=" + results +
                '}';
    }
}