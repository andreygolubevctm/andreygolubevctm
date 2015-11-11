package com.ctm.web.core.resultsData.model;

import com.fasterxml.jackson.annotation.JsonInclude;

/**
 * This class is used to hold the results java classes when returning to the front end
 * It assists by ensuring the JSON structure matches what the front end expects.
 */
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class ResultsWrapper {

    private final ResultsObj results;

    // Added for token validation
    private final String verificationToken;

    // Added for token validation error
    private final Error error;

    private ResultsWrapper(ResultsObj results, String verificationToken, Error error) {
        this.results = results;
        this.verificationToken = verificationToken;
        this.error = error;
    }

    public ResultsWrapper(ResultsObj results) {
        this(results, "", null);
    }

    public ResultsWrapper(ResultsObj results, String verificationToken) {
        this.results = results;
        this.verificationToken = verificationToken;
        this.error = null;
    }

    public ResultsWrapper(ResultsObj results, Error error) {
        this.results = results;
        this.verificationToken = null;
        this.error = error;
    }

    public ResultsObj getResults() {
        return results;
    }

    public String getVerificationToken() {
        return verificationToken;
    }

    public Error getError() {
        return error;
    }

}
