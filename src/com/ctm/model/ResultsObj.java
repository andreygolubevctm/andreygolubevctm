package com.ctm.model;

import com.fasterxml.jackson.annotation.JsonRootName;
import com.fasterxml.jackson.annotation.JsonTypeName;
import com.fasterxml.jackson.databind.annotation.JsonNaming;

import java.util.List;

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
