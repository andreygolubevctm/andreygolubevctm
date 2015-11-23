package com.ctm.web.core.resultsData.model;

/**
 * This class is used to hold the results java classes when returning to the front end
 * It assists by ensuring the JSON structure matches what the front end expects.
 */
public class ResultsWrapper {

    private final ResultsObj results;

    public ResultsWrapper(ResultsObj results) {
        this.results = results;
    }

    public ResultsObj getResults() {
        return results;
    }

}
