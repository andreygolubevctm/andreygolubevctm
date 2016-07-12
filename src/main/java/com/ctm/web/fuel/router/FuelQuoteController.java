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
        final String northWest = request.getParameter("fuel_map_northWest");
        final String southEast = request.getParameter("fuel_map_southEast");
        final Long fuelId = Long.valueOf(request.getParameter("fuel_type_id"));

        final QuoteRequest quoteRequest = QuoteRequest.newBuilder()
                .initialPoint(Coordinate.newBuilder()
                    .lat(Float.valueOf(northWest.split(",")[0]))
                    .lng(Float.valueOf(northWest.split(",")[1]))
                    .build())
                .endPoint(Coordinate.newBuilder()
                    .lat(Float.valueOf(southEast.split(",")[0]))
                    .lng(Float.valueOf(southEast.split(",")[1]))
                    .build())
                .fuelId(fuelId)
                .build();

        return fuelQuoteClient.post(quoteRequest, QuoteResponse.class, fuelQuoteUrl + "/quote").toBlocking().first();
    }
}
