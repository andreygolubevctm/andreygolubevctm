package com.ctm.web.fuel.router;

import com.ctm.fuelquote.model.config.Coordinate;
import com.ctm.fuelquote.model.request.QuoteRequest;
import com.ctm.fuelquote.model.response.QuoteResponse;
import com.ctm.httpclient.Client;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/rest/fuel")
public class FuelQuoteController {
    @Autowired
    private Client<QuoteRequest, QuoteResponse> fuelQuoteClient;

    @Value("${ctm.fuelquote.url}")
    private String fuelQuoteUrl;

    @RequestMapping(value = "/quote/get.json",
                    method = RequestMethod.POST,
                    produces = MediaType.APPLICATION_JSON_VALUE)
    public QuoteResponse getQuote(final HttpServletRequest request) {
        final QuoteRequest quoteRequest = QuoteRequest.newBuilder()
                .initialPoint(Coordinate.newBuilder() // Top left
                    .lat(-26.961234f)
                    .lng(151.404197f)
                    .build())
                .endPoint(Coordinate.newBuilder() // Bottom right
                    .lat(-28.067122f)
                    .lng(153.692100f)
                    .build())
                .fuelId(2L)
                .build();

        return fuelQuoteClient.post(quoteRequest, QuoteResponse.class, fuelQuoteUrl + "/quote").toBlocking().first();
    }
}
