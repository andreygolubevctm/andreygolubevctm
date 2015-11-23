package com.ctm.web.core.resultsData.model;

import com.fasterxml.jackson.annotation.JsonRootName;
import com.fasterxml.jackson.annotation.JsonTypeName;

import java.util.List;

/**
 * This class is used to hold the results java classes when returning to the front end
 * It assists by ensuring the JSON structure matches what the front end expects.
 */

@JsonTypeName("results")
@JsonRootName("results")
public class ResultsObj<R extends Result> {

    private Info info;

    private List<R> result;

    public Info getInfo() {
        return info;
    }

    public void setInfo(Info info) {
        this.info = info;
    }

    public List<R> getResult() {
        return result;
    }

    public void setResult(List<R> result) {
        this.result = result;
    }
}
