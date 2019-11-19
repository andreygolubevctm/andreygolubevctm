package com.ctm.web.core.model.resultsData;

import com.ctm.web.core.resultsData.model.Result;

import java.util.List;

public class PricesObj<R extends Result> extends BaseResultObj<R> {

    public List<R> getPrice() {
        return value;
    }

    public void setPrice(List<R> result) {
        this.value = result;
    }



}
