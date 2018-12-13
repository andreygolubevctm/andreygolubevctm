package com.ctm.web.health.duplicateTransCheck.model.response;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_EMPTY)
public final class DuplicateTransactionsCheckResponse {
    private final DuplicateTransactionsCheckDetails details;

    public DuplicateTransactionsCheckResponse(DuplicateTransactionsCheckDetails details) {
        this.details = details;
    }

    public DuplicateTransactionsCheckDetails getDetails() {
        return details;
    }

}
