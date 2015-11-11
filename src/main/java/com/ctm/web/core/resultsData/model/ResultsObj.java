package com.ctm.web.core.resultsData.model;

import com.ctm.web.core.model.resultsData.BaseResultObj;

import java.util.List;

/**
 * This class is used to hold the results java classes when returning to the front end
 * It assists by ensuring the JSON structure matches what the front end expects.
 */

public class ResultsObj<R extends Result> extends BaseResultObj<R> {

    public List<R> getResult() {
        return result;
    }

}
