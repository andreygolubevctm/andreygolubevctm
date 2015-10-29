package com.ctm.web.creditcards.utils;

import com.ctm.web.creditcards.model.CreditCardRequest;
import com.ctm.web.core.web.go.Data;

/**
 * Created by voba on 26/06/2015.
 */
public class CreditCardRequestParser {
    public static CreditCardRequest parseRequest(Data data, String vertical) {
        CreditCardRequest request = new CreditCardRequest();
        request.setName(data.getString(vertical.toLowerCase() + "/name"));
        request.setEmail(data.getString(vertical.toLowerCase() + "/email"));
        request.setPostcode(data.getString(vertical.toLowerCase() + "/postcode"));
        return request;
    }
}
