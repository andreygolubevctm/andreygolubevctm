package com.ctm.web.core.results;

import com.ctm.web.core.results.model.ResultProperty;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.List;

public class ResultPropertiesBuilder {

    private final Long transactionId;

    private final String productId;

    private List<ResultProperty> resultProperties = new ArrayList<>();

    public ResultPropertiesBuilder(Long transactionId, String productId) {
        this.transactionId = transactionId;
        this.productId = productId;
    }

    public ResultPropertiesBuilder addResult(String property, String value) {
        ResultProperty resultProperty = new ResultProperty();
        resultProperty.setProductId(productId);
        resultProperty.setTransactionId(transactionId);
        resultProperty.setProperty(property);
        resultProperty.setValue(StringUtils.stripToEmpty(value));
        resultProperties.add(resultProperty);
        return this;
    }

    public List<ResultProperty> getResultProperties() {
        return resultProperties;
    }

}
