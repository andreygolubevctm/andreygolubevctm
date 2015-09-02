package com.ctm.model.resultsData;

import java.util.List;

public class PricesObj<R extends Result> extends BaseResultObj<R> {

    public List<R> getPrice() {
        return result;
    }

}
