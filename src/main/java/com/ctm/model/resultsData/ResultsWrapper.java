package com.ctm.model.resultsData;

/**
 * This class is used to hold the results java classes when returning to the front end
 * It assists by ensuring the JSON structure matches what the front end expects.
 */
public class ResultsWrapper {

    private final BaseResultObj results;

    public ResultsWrapper(BaseResultObj results) {
        this.results = results;
    }

    public BaseResultObj getResults() {
        return results;
    }

}
