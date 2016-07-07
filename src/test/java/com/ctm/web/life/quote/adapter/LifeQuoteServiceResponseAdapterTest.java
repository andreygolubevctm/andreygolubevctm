package com.ctm.web.life.quote.adapter;

import com.ctm.interfaces.common.types.ServiceId;
import com.ctm.life.quote.model.response.ApplicantType;
import com.ctm.life.quote.model.response.Company;
import com.ctm.life.quote.model.response.LifeQuote;
import com.ctm.life.quote.model.response.Product;
import com.ctm.web.core.providers.model.QuoteResponse;
import com.ctm.web.life.form.model.LifeQuoteWebRequest;
import com.ctm.web.life.form.response.model.LifeResultsWebResponse;
import com.ctm.web.life.form.response.model.Premium;
import com.ctm.web.life.model.LifeQuoteResponse;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.IsCollectionContaining.hasItems;

public class LifeQuoteServiceResponseAdapterTest {

    public static final String SERVICE_PROVIDER = "Lifebroker";
    private LifeQuoteServiceResponseAdapter responseAdapter;
    private String partnerProductId = "partnerProductId";
    private String primaryProductId = "primaryProductId";

    @Before
    public void setUp() throws Exception {
        responseAdapter = new LifeQuoteServiceResponseAdapter();
    }
    @Test
    public void adaptTest() throws Exception {
        Premium expectedPartnerResult = new Premium();
        expectedPartnerResult.setProductId(partnerProductId);
        expectedPartnerResult.setServiceProvider(SERVICE_PROVIDER);
        expectedPartnerResult.setInfo("");

        Premium expectedPrimaryResult = new Premium();
        expectedPrimaryResult.setServiceProvider(SERVICE_PROVIDER);
        expectedPrimaryResult.setProductId(primaryProductId);
        expectedPrimaryResult.setInfo("");

        LifeQuoteResponse response = getLifeQuoteResponse();
        LifeQuoteWebRequest request = getLifeQuoteWebRequest();

        final LifeResultsWebResponse result = responseAdapter.adapt(response, request);
        assertThat(result.getResults().getPartner().getPremiums(), hasItems(expectedPartnerResult));
        assertThat(result.getResults().getClient().getPremiums(), hasItems(expectedPrimaryResult));
    }

    private LifeQuoteResponse getLifeQuoteResponse() {
        ServiceId service = ServiceId.instanceOf("LFBR");
        LifeQuoteResponse response = new LifeQuoteResponse();
        QuoteResponse<LifeQuote> payload = new QuoteResponse<>();
        List<LifeQuote> quotes = new ArrayList<>();
        Company partnerCompany = new Company.Builder().build();
        com.ctm.life.quote.model.response.Premium partnerPremium = new com.ctm.life.quote.model.response.Premium.Builder().build();
        Product partnerProduct = new Product.Builder()
                .company(partnerCompany)
                .premium(partnerPremium)
                .build();
        LifeQuote quotePartner = new LifeQuote.Builder()
                .applicantType(ApplicantType.PARTNER)
                .productId(partnerProductId)
                .available(true)
                .product(partnerProduct)
                .service(service)
                .build();
        Company primaryCompany = new Company.Builder().build();
        com.ctm.life.quote.model.response.Premium primaryPremium = new com.ctm.life.quote.model.response.Premium.Builder().build();
        Product primaryProduct = new Product.Builder()
                .company(primaryCompany)
                .premium(primaryPremium)
                .build();
        LifeQuote quotePrimary = new LifeQuote.Builder()
                .applicantType(ApplicantType.PRIMARY)
                .productId(primaryProductId)
                .available(true)
                .product(primaryProduct)
                .service(service)
                .build();
        quotes.add(quotePartner);
        quotes.add(quotePrimary);
        payload.setQuotes(quotes);
        response.setPayload(payload);
        return response;
    }

    public LifeQuoteWebRequest getLifeQuoteWebRequest() {
        LifeQuoteWebRequest lifeQuoteWebRequest = new LifeQuoteWebRequest();
        return lifeQuoteWebRequest;
    }
}