package com.ctm.web.health.quote.model;

import com.ctm.web.health.model.form.Filter;
import com.ctm.web.health.quote.model.request.Filters;
import org.junit.Test;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.*;

public class RequestAdapterTest {

    @Test
    public void testAddExcludeProvidersFilterEmpty() throws Exception {
        final Filters filters = mock(Filters.class);
        final Filter filter = mock(Filter.class);
        RequestAdapter.addExcludeProvidersFilter(filters, filter);
        verify(filters, never()).setProviderFilter(any());
    }

    @Test
    public void testAddExcludeProvidersFilterHealthFundNotFound() throws Exception {
        final Filters filters = mock(Filters.class);
        final Filter filter = mock(Filter.class);
        when(filter.getProviderExclude()).thenReturn("XX");
        RequestAdapter.addExcludeProvidersFilter(filters, filter);
        verify(filters, never()).setProviderFilter(any());
    }

    @Test
    public void testAddExcludeProvidersFilter() throws Exception {
        final Filters filters = mock(Filters.class);
        final Filter filter = mock(Filter.class);
        when(filter.getProviderExclude()).thenReturn("AUF");
        RequestAdapter.addExcludeProvidersFilter(filters, filter);
        verify(filters, times(1)).setProviderFilter(any());
    }

}