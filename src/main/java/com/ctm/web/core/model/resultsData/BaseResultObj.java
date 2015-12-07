package com.ctm.web.core.model.resultsData;

import com.ctm.web.core.resultsData.model.Info;
import com.ctm.web.core.resultsData.model.Result;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonRootName;
import com.fasterxml.jackson.annotation.JsonTypeName;

import java.util.List;

@JsonTypeName("results")
@JsonRootName("results")
public abstract class BaseResultObj<R extends Result> {

    private Info info;

    @JsonIgnore
    protected List<R> value;

    public Info getInfo() {
        return info;
    }

    public void setInfo(Info info) {
        this.info = info;
    }

    public void setResult(List<R> result) {
        this.value = result;
    }

}
