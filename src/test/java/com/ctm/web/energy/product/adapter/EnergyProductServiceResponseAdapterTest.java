package com.ctm.web.energy.product.adapter;

import com.ctm.energy.product.response.model.EnergyProduct;
import com.ctm.energy.product.response.model.types.*;
import com.ctm.web.core.providers.model.QuoteResponse;
import com.ctm.web.energy.form.response.model.EnergyProductInfoWebResponse;
import com.ctm.web.energy.model.EnergyProductResponse;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static java.util.Collections.singletonList;
import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class EnergyProductServiceResponseAdapterTest {

    @Mock
    private EnergyProductResponse response;
    @Mock
    private QuoteResponse<EnergyProduct> quoteResponse;
    @Mock
    private EnergyProduct energyProduct;

    private EnergyProductServiceResponseAdapter adapter = new EnergyProductServiceResponseAdapter();

    @Before
    public void setup() throws Exception {
        initMocks(this);
        when(response.getPayload()).thenReturn(quoteResponse);
        when(quoteResponse.getQuotes()).thenReturn(singletonList(energyProduct));
    }

    @Test
    public void adaptEmpty() throws Exception {
        when(energyProduct.getRetailerName()).thenReturn(RetailerName.empty());
        when(energyProduct.getPlanName()).thenReturn(PlanName.empty());
        when(energyProduct.getPlanDetails()).thenReturn(PlanDetails.empty());
        when(energyProduct.getContractDetails()).thenReturn(ContractDetails.empty());
        when(energyProduct.getBillingOptions()).thenReturn(BillingOptions.empty());
        when(energyProduct.getPricingInformation()).thenReturn(PricingInformation.empty());
        when(energyProduct.getPaymentDetails()).thenReturn(PaymentDetails.empty());
        when(energyProduct.getTermsUrl()).thenReturn(TermsUrl.empty());
        when(energyProduct.getPrivacyPolicyUrl()).thenReturn(PrivacyPolicyUrl.empty());
        final EnergyProductInfoWebResponse webResponse = adapter.adapt(response);
        assertEquals("", webResponse.getRetailName());
        assertEquals("", webResponse.getPlanName());
        assertEquals("", webResponse.getPlanDetails());
        assertEquals("", webResponse.getContractDetails());
        assertEquals("", webResponse.getBillingOptions());
        assertEquals("", webResponse.getPricingInformation());
        assertEquals("", webResponse.getPaymentDetails());
        assertEquals("", webResponse.getTermsUrl());
        assertEquals("", webResponse.getPrivacyPolicyUrl());

    }

    @Test
    public void adapt() throws Exception {
        when(energyProduct.getRetailerName()).thenReturn(RetailerName.instanceOf("Simply Energy"));
        when(energyProduct.getPlanName()).thenReturn(PlanName.instanceOf("Simply Summer Sale Plan (Dual Fuel)"));
        when(energyProduct.getPlanDetails()).thenReturn(PlanDetails.instanceOf("<h4>Discounts</h4>"));
        when(energyProduct.getContractDetails()).thenReturn(ContractDetails.instanceOf("<b>Contract Term</b>"));
        when(energyProduct.getBillingOptions()).thenReturn(BillingOptions.instanceOf("<b>Standard Billing: </b>"));
        when(energyProduct.getPricingInformation()).thenReturn(PricingInformation.instanceOf("Comparisons based on standard tariffs"));
        when(energyProduct.getPaymentDetails()).thenReturn(PaymentDetails.instanceOf("<ul><li>BPAY </li><li>Direct Debit</li></ul>"));
        when(energyProduct.getTermsUrl()).thenReturn(TermsUrl.instanceOf("http://www.utilityworld.com.au/comparethemarket/terms/Small-Customer-Market-Retail-Contract-Terms-VIC-NSW-SA.pdf"));
        when(energyProduct.getPrivacyPolicyUrl()).thenReturn(PrivacyPolicyUrl.instanceOf("http://www.utilityworld.com.au/comparethemarket/privacy/Simply-Privacy.pdf"));
        final EnergyProductInfoWebResponse webResponse = adapter.adapt(response);
        assertEquals("Simply Energy", webResponse.getRetailName());
        assertEquals("Simply Summer Sale Plan (Dual Fuel)", webResponse.getPlanName());
        assertEquals("<h4>Discounts</h4>", webResponse.getPlanDetails());
        assertEquals("<b>Contract Term</b>", webResponse.getContractDetails());
        assertEquals("<b>Standard Billing: </b>", webResponse.getBillingOptions());
        assertEquals("Comparisons based on standard tariffs", webResponse.getPricingInformation());
        assertEquals("<ul><li>BPAY </li><li>Direct Debit</li></ul>", webResponse.getPaymentDetails());
        assertEquals("http://www.utilityworld.com.au/comparethemarket/terms/Small-Customer-Market-Retail-Contract-Terms-VIC-NSW-SA.pdf", webResponse.getTermsUrl());
        assertEquals("http://www.utilityworld.com.au/comparethemarket/privacy/Simply-Privacy.pdf", webResponse.getPrivacyPolicyUrl());
    }


}