package com.ctm.web.life.quote.adapter;

import com.ctm.interfaces.common.types.ServiceId;
import com.ctm.life.quote.model.response.ApplicantType;
import com.ctm.life.quote.model.response.Company;
import com.ctm.life.quote.model.response.LifeQuote;
import com.ctm.life.quote.model.response.Product;
import com.ctm.web.core.providers.model.Response;
import com.ctm.web.life.form.model.Api;
import com.ctm.web.life.form.model.LifeQuoteWebRequest;
import com.ctm.web.life.form.response.model.LifeResults;
import com.ctm.web.life.form.response.model.LifeResultsWebResponse;
import com.ctm.web.life.form.response.model.Premium;
import com.ctm.web.life.form.response.model.ResultPremiums;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Stream;

import static java.util.stream.Collectors.toList;

@Component
public class LifeQuoteServiceResponseAdapter {

    public LifeResultsWebResponse adapt(Response<LifeQuote> lifeQuoteResponse, LifeQuoteWebRequest request) {
        final LifeResultsWebResponse response = new LifeResultsWebResponse();
        response.setResults(createResults(lifeQuoteResponse, request));
        return response;
    }

    private LifeResults createResults(Response<LifeQuote> lifeQuoteResponse, LifeQuoteWebRequest request) {
        final LifeResults results = new LifeResults();
        results.setTransactionId(request.getTransactionId());
        final List<LifeQuote> quotes = lifeQuoteResponse.getPayload()
                .getQuotes();
        final Api api = new Api();
        api.setReference(quotes.stream()
                .filter(q -> q.isAvailable() && q.getReference().isPresent())
                .map(q -> q.getReference().get())
                .findFirst()
                .orElse(""));
        results.setApi(api);
        results.setSuccess(quotes.stream().anyMatch(LifeQuote::isAvailable));

        results.setClient(createResultPremiums(quotes.stream()
                .filter(q -> q.isAvailable() && ApplicantType.PRIMARY.equals(q.getApplicantType()))));

        results.setPartner(createResultPremiums(quotes.stream()
                .filter(q -> q.isAvailable() && ApplicantType.PARTNER.equals(q.getApplicantType()))));
        return results;
    }

    private ResultPremiums createResultPremiums(Stream<LifeQuote> lifeQuoteStream) {
        final List<Premium> premiums = lifeQuoteStream.map(this::createPremium).collect(toList());
        if (!premiums.isEmpty()) {
            final ResultPremiums resultPremiums = new ResultPremiums();
            resultPremiums.setPremiums(premiums);
            return resultPremiums;
        }
        return null;
    }

    private Premium createPremium(LifeQuote quote) {
        final Premium premium = new Premium();
        final Product product = quote.getProduct();
        final Company company = product.getCompany();
        premium.setInsurerContact(company.getInsurerContact());
        premium.setProductId(quote.getProductId().get());
        premium.setName(product.getName());
        premium.setDescription(product.getDescription());
        premium.setBelowMinimum(product.getBelowMinimum());
        premium.setCompany(company.getName());
        premium.setServiceProvider(getServiceProvider(quote.getService()));
        premium.setStars(product.getStars());
        premium.setValue(product.getPremium().getValue());
        premium.setPds(product.getPds());
        premium.setInfo(company.getInfo().orElse(""));
        return premium;
    }

    private String getServiceProvider(ServiceId service) {
        return service.get().equals("LFBR") ? "Lifebroker" : service.get();
    }
}
