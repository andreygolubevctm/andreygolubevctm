package com.ctm.model.resultsData;

import com.fasterxml.jackson.annotation.JsonInclude;

/**
 * This class is used to hold the results java classes when returning to the front end
 * It assists by ensuring the JSON structure matches what the front end expects.
 */
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class ResultsWrapper {

    private final BaseResultObj results;

    private final String verificationToken;

    private final Error error;

    public ResultsWrapper(BaseResultObj results) {
        this(results, "", null);
    }

    private ResultsWrapper(BaseResultObj results, String verificationToken, Error error) {
        this.results = results;
        this.verificationToken = verificationToken;
        this.error = error;
    }

    public ResultsWrapper(BaseResultObj results, String verificationToken) {
        this.results = results;
        this.verificationToken = verificationToken;
        this.error = null;
    }

    public ResultsWrapper(BaseResultObj results, Error error) {
        this.results = results;
        this.verificationToken = null;
        this.error = error;
    }

    public BaseResultObj getResults() {
        return results;
    }

    public String getVerificationToken() {
        return verificationToken;
    }

    public Error getError() {
        return error;
    }
}
