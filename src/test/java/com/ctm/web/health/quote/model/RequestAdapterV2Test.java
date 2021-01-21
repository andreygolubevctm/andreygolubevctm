package com.ctm.web.health.quote.model;

import com.ctm.web.health.model.form.Filter;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.Situation;
import com.ctm.web.health.quote.model.request.Filters;
import com.ctm.web.health.quote.model.request.HealthQuoteRequest;
import com.ctm.web.health.quote.model.request.HospitalBenefitsSource;
import com.ctm.web.health.quote.model.request.ProductType;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.*;
import static org.mockito.Mockito.times;

public class RequestAdapterV2Test {

	final Filters filters = mock(Filters.class);

    @Test
    public void testAddExcludeProvidersFilterEmpty() throws Exception {
        final Filter filter = mock(Filter.class);
        RequestAdapterV2.addExcludeProvidersFilter(filters, filter);
        verify(filters, never()).setProviderFilter(any());
    }

    @Test
    public void testAddExcludeProvidersFilterHealthFundNotFound() throws Exception {
        final Filter filter = mock(Filter.class);
        when(filter.getProviderExclude()).thenReturn("XX");
        RequestAdapterV2.addExcludeProvidersFilter(filters, filter);
        verify(filters, never()).setProviderFilter(any());
    }

    @Test
    public void testAddExcludeProvidersFilter() throws Exception {
        final Filter filter = mock(Filter.class);
        when(filter.getProviderExclude()).thenReturn("AUF");
        RequestAdapterV2.addExcludeProvidersFilter(filters, filter);
        verify(filters, times(1)).setProviderFilter(any());
    }

    @Test
    public void testSituationFilterEmpty() throws Exception {
        RequestAdapterV2.addSituationFilter(filters, null,null);
        verify(filters, never()).setSituationFilter(any());
    }

    @Test
    public void testSituationFilterCombinedAccidentOnlyY() throws Exception {
        final Situation situation = mock(Situation.class);
        final HealthQuoteRequest quoteRequest = mock(HealthQuoteRequest.class);
        when(quoteRequest.getProductType()).thenReturn(ProductType.COMBINED);
        when(situation.getAccidentOnlyCover()).thenReturn("Y");
        RequestAdapterV2.addSituationFilter(filters, situation,quoteRequest);
        verify(filters, times(1)).setSituationFilter(Boolean.TRUE);
    }

    @Test
    public void testSituationFilterCombinedAccidentOnlyN() throws Exception {
        final Situation situation = mock(Situation.class);
        final HealthQuoteRequest quoteRequest = mock(HealthQuoteRequest.class);
        when(quoteRequest.getProductType()).thenReturn(ProductType.COMBINED);
        when(situation.getAccidentOnlyCover()).thenReturn("N");
        RequestAdapterV2.addSituationFilter(filters, situation,quoteRequest);
        verify(filters, times(1)).setSituationFilter(Boolean.FALSE);
    }

    @Test
    public void testSituationFilterHospitalAccidentOnlyY() throws Exception {
        final Situation situation = mock(Situation.class);
        final HealthQuoteRequest quoteRequest = mock(HealthQuoteRequest.class);
        when(quoteRequest.getProductType()).thenReturn(ProductType.HOSPITAL);
        when(situation.getAccidentOnlyCover()).thenReturn("Y");
        RequestAdapterV2.addSituationFilter(filters, situation,quoteRequest);
        verify(filters, times(1)).setSituationFilter(Boolean.TRUE);
    }

    @Test
    public void testSituationFilterHospitalAccidentOnlyN() throws Exception {
        final Situation situation = mock(Situation.class);
        final HealthQuoteRequest quoteRequest = mock(HealthQuoteRequest.class);
        when(quoteRequest.getProductType()).thenReturn(ProductType.HOSPITAL);
        when(situation.getAccidentOnlyCover()).thenReturn("N");
        RequestAdapterV2.addSituationFilter(filters, situation,quoteRequest);
        verify(filters, times(1)).setSituationFilter(Boolean.FALSE);
    }

    @Test
    public void testSituationFilterGeneralHealthAccidentOnlyN() throws Exception {
        final Situation situation = mock(Situation.class);
        final HealthQuoteRequest quoteRequest = mock(HealthQuoteRequest.class);
        when(quoteRequest.getProductType()).thenReturn(ProductType.GENERALHEALTH);
        when(situation.getAccidentOnlyCover()).thenReturn("N");
        RequestAdapterV2.addSituationFilter(filters, situation,quoteRequest);
        verify(filters, times(1)).setSituationFilter(Boolean.FALSE);
    }

    @Test
    public void testSituationFilterGeneralHealthAccidentOnlyY() throws Exception {
        final Situation situation = mock(Situation.class);
        final HealthQuoteRequest quoteRequest = mock(HealthQuoteRequest.class);
        when(quoteRequest.getProductType()).thenReturn(ProductType.GENERALHEALTH);
        when(situation.getAccidentOnlyCover()).thenReturn("Y");
        RequestAdapterV2.addSituationFilter(filters, situation,quoteRequest);
        verify(filters, times(1)).setSituationFilter(Boolean.FALSE);
    }

    @Test
    public void testReturnCTMBenefits() throws Exception {
        boolean flag = true;
        final HealthQuoteRequest quoteRequest = new HealthQuoteRequest();
        quoteRequest.setReturnCTMBenefits(flag);
        assertEquals(flag, quoteRequest.getReturnCTMBenefits());
    }

    @Test
    public void testSetReturnCTMBenefits() throws Exception {
        final HealthQuoteRequest quoteRequest = new HealthQuoteRequest();
        quoteRequest.setReturnCTMBenefits(Boolean.TRUE);
        assertEquals(Boolean.TRUE, quoteRequest.getReturnCTMBenefits());
    }

    @Test
    public void testAddHospitalBenefitsSource() throws Exception {
        final Filters filters = new Filters();
        final HealthQuote quote = new HealthQuote();
        quote.setHospitalBenefitsSource(HospitalBenefitsSource.CLINICAL_CATEGORIES.name());
        RequestAdapterV2 adapter = new RequestAdapterV2();
        adapter.addHospitalBenefitsSource(filters, quote);
        assertEquals(HospitalBenefitsSource.CLINICAL_CATEGORIES, filters.getHospitalBenefitsSource());
    }
}