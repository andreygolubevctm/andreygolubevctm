package com.ctm.web.health.quote.model;

import com.ctm.web.health.model.form.Filter;
import com.ctm.web.health.model.form.Situation;
import com.ctm.web.health.quote.model.request.Filters;
import com.ctm.web.health.quote.model.request.HealthQuoteRequest;
import com.ctm.web.health.quote.model.request.ProductType;
import org.junit.Test;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.*;
import static org.mockito.Mockito.times;

public class RequestAdapterV2Test {

    @Test
    public void testAddExcludeProvidersFilterEmpty() throws Exception {
        final Filters filters = mock(Filters.class);
        final Filter filter = mock(Filter.class);
        RequestAdapterV2.addExcludeProvidersFilter(filters, filter);
        verify(filters, never()).setProviderFilter(any());
    }

    @Test
    public void testAddExcludeProvidersFilterHealthFundNotFound() throws Exception {
        final Filters filters = mock(Filters.class);
        final Filter filter = mock(Filter.class);
        when(filter.getProviderExclude()).thenReturn("XX");
        RequestAdapterV2.addExcludeProvidersFilter(filters, filter);
        verify(filters, never()).setProviderFilter(any());
    }

    @Test
    public void testAddExcludeProvidersFilter() throws Exception {
        final Filters filters = mock(Filters.class);
        final Filter filter = mock(Filter.class);
        when(filter.getProviderExclude()).thenReturn("AUF");
        RequestAdapterV2.addExcludeProvidersFilter(filters, filter);
        verify(filters, times(1)).setProviderFilter(any());
    }

    @Test
    public void testSituationFilterEmpty() throws Exception {
        final Filters filters = mock(Filters.class);
        RequestAdapterV2.addSituationFilter(filters, null,null);
        verify(filters, never()).setSituationFilter(any());
    }

    @Test
    public void testSituationFilterCombinedAccidentOnlyY() throws Exception {
        final Filters filters = mock(Filters.class);
        final Situation situation = mock(Situation.class);
        final HealthQuoteRequest quoteRequest = mock(HealthQuoteRequest.class);
        when(quoteRequest.getProductType()).thenReturn(ProductType.COMBINED);
        when(situation.getAccidentOnlyCover()).thenReturn("Y");
        RequestAdapterV2.addSituationFilter(filters, situation,quoteRequest);
        verify(filters, times(1)).setSituationFilter(Boolean.TRUE);
    }

    @Test
    public void testSituationFilterCombinedAccidentOnlyN() throws Exception {
        final Filters filters = mock(Filters.class);
        final Situation situation = mock(Situation.class);
        final HealthQuoteRequest quoteRequest = mock(HealthQuoteRequest.class);
        when(quoteRequest.getProductType()).thenReturn(ProductType.COMBINED);
        when(situation.getAccidentOnlyCover()).thenReturn("N");
        RequestAdapterV2.addSituationFilter(filters, situation,quoteRequest);
        verify(filters, times(1)).setSituationFilter(Boolean.FALSE);
    }

    @Test
    public void testSituationFilterHospitalAccidentOnlyY() throws Exception {
        final Filters filters = mock(Filters.class);
        final Situation situation = mock(Situation.class);
        final HealthQuoteRequest quoteRequest = mock(HealthQuoteRequest.class);
        when(quoteRequest.getProductType()).thenReturn(ProductType.HOSPITAL);
        when(situation.getAccidentOnlyCover()).thenReturn("Y");
        RequestAdapterV2.addSituationFilter(filters, situation,quoteRequest);
        verify(filters, times(1)).setSituationFilter(Boolean.TRUE);
    }

    @Test
    public void testSituationFilterHospitalAccidentOnlyN() throws Exception {
        final Filters filters = mock(Filters.class);
        final Situation situation = mock(Situation.class);
        final HealthQuoteRequest quoteRequest = mock(HealthQuoteRequest.class);
        when(quoteRequest.getProductType()).thenReturn(ProductType.HOSPITAL);
        when(situation.getAccidentOnlyCover()).thenReturn("N");
        RequestAdapterV2.addSituationFilter(filters, situation,quoteRequest);
        verify(filters, times(1)).setSituationFilter(Boolean.FALSE);
    }

    @Test
    public void testSituationFilterGeneralHealthAccidentOnlyN() throws Exception {
        final Filters filters = mock(Filters.class);
        final Situation situation = mock(Situation.class);
        final HealthQuoteRequest quoteRequest = mock(HealthQuoteRequest.class);
        when(quoteRequest.getProductType()).thenReturn(ProductType.GENERALHEALTH);
        when(situation.getAccidentOnlyCover()).thenReturn("N");
        RequestAdapterV2.addSituationFilter(filters, situation,quoteRequest);
        verify(filters, times(1)).setSituationFilter(Boolean.FALSE);
    }

    @Test
    public void testSituationFilterGeneralHealthAccidentOnlyY() throws Exception {
        final Filters filters = mock(Filters.class);
        final Situation situation = mock(Situation.class);
        final HealthQuoteRequest quoteRequest = mock(HealthQuoteRequest.class);
        when(quoteRequest.getProductType()).thenReturn(ProductType.GENERALHEALTH);
        when(situation.getAccidentOnlyCover()).thenReturn("Y");
        RequestAdapterV2.addSituationFilter(filters, situation,quoteRequest);
        verify(filters, times(1)).setSituationFilter(Boolean.FALSE);
    }
}