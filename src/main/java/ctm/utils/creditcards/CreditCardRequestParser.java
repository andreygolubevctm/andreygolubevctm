package com.ctm.utils.creditcards;

import com.ctm.model.creditcards.CreditCardRequest;
import com.disc_au.web.go.Data;

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
