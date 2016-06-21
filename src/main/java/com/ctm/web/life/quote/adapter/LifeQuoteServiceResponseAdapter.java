package com.ctm.web.life.quote.adapter;

import com.ctm.interfaces.common.types.ServiceId;
import com.ctm.life.quote.model.response.*;
import com.ctm.web.core.providers.model.Response;
import com.ctm.web.life.form.model.Api;
import com.ctm.web.life.form.model.LifeQuoteWebRequest;
import com.ctm.web.life.form.response.model.*;
import com.ctm.web.life.form.response.model.Premium;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
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

        if(quote.getService().get().equals("OZIC") ) {
            quote.getProduct().getProductDetails().ifPresent(productDetails -> {
                premium.setSpecial_offer(productDetails.getSpecialOffer());
                premium.setLeadNumber(productDetails.getLeadNumber());
                premium.setFsg(productDetails.getFsg());
                premium.setCallCentreHours(productDetails.getCallCentreHours());
                Benefits benefits  = productDetails.getBenefits();
                Features features = new Features();

                features.setExclusions(mapFeature(benefits.getExclusions()));
                features.setFeatures(mapFeature(benefits.getFeatures()));
                features.setOptionalExtras(mapFeature(benefits.getOptionalExtras()));
                features.setSpecialOffers(mapFeature(benefits.getSpecialOffers()));
                features.setWhatsIncluded(mapFeature(benefits.getWhatsIncluded()));
                premium.setFeatures(features);
            });
            premium.setCompanyName(company.getName());
        }
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

    private FeaturesInner mapFeature(List<Feature> features) {
        FeaturesInner featuresInner = new FeaturesInner();
        List<FeatureWithAvailability> targetLongList = features.stream().map(element ->
                new FeatureWithAvailability.Builder()
                        .available(
                                element.getAvailable()
                                        .map(aval -> Optional.of( aval ? 1 : 0)).orElse(Optional.empty()))
                        .id(element.getId()).name(element.getName()).build())
                .collect(Collectors.toList());
        featuresInner.setFeature(targetLongList);
        return featuresInner;
    }

    private String getServiceProvider(ServiceId service) {
        return service.get().equals("LFBR") ? "Lifebroker" : service.get();
    }
}
