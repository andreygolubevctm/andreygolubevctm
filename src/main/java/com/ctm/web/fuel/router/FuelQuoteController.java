package com.ctm.web.fuel.router;

import com.ctm.fuelquote.model.config.Coordinate;
import com.ctm.fuelquote.model.request.QuoteRequest;
import com.ctm.fuelquote.model.response.QuoteResponse;
import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@RestController
@RequestMapping("/rest/fuel")
public class FuelQuoteController {
    private static final Logger LOGGER = LoggerFactory.getLogger(FuelQuoteController.class);

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

        LOGGER.debug("Fuel quote {}, {}, {}", kv("fuel_map_northWest", northWest), kv("fuel_map_southEast", southEast), kv("fuelId", fuelId));

        if(StringUtils.isNotBlank(northWest) && StringUtils.isNotBlank(southEast) && fuelId != null) {
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

            final RestSettings<QuoteRequest> restSettings = RestSettings.<QuoteRequest>builder()
                    .url(fuelQuoteUrl + "/quote")
                    .request(quoteRequest)
                    .response(QuoteResponse.class)
                    .timeout(20000) // 20 seconds
                    .header("Accept", MediaType.APPLICATION_JSON_VALUE)
                    .header("Content-Type", MediaType.APPLICATION_JSON_UTF8_VALUE)
                    .build();

            return fuelQuoteClient.post(restSettings).toBlocking().first();
        } else {
            return QuoteResponse.newBuilder().build();
        }
    }
}
