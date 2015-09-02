package com.ctm.model.resultsData;

import com.fasterxml.jackson.annotation.JsonRootName;
import com.fasterxml.jackson.annotation.JsonTypeName;

import java.util.List;

@JsonTypeName("results")
@JsonRootName("results")
public abstract class BaseResultObj<R extends Result> {

    private Info info;

    protected List<R> result;

    public Info getInfo() {
        return info;
    }

    public void setInfo(Info info) {
        this.info = info;
    }

    public void setResult(List<R> result) {
        this.result = result;
    }

}
