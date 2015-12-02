package com.ctm.web.energy.provider.adapter;

import com.ctm.energy.provider.request.model.EnergyProviderRequest;
import com.ctm.energy.provider.request.model.types.PostCode;
import com.ctm.energy.provider.request.model.types.Suburb;
import com.ctm.web.energy.form.model.EnergyProviderWebRequest;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class EnergyProviderServiceRequestAdapterTest {

    @Mock
    private EnergyProviderWebRequest request;

    EnergyProviderServiceRequestAdapter requestAdapter = new EnergyProviderServiceRequestAdapter();

    @Before
    public void setup() {
        initMocks(this);
    }

    @Test
    public void adapt() throws Exception {
        when(request.getPostcode()).thenReturn("4000");
        final EnergyProviderRequest providerRequest = requestAdapter.adapt(request);
        assertEquals(PostCode.instanceOf("4000"), providerRequest.getPostCode());
        assertEquals(Suburb.instanceOf(""), providerRequest.getSuburb());
        verify(request, times(1)).getPostcode();
        verify(request, times(1)).getSuburb();
    }

    @Test
    public void adaptWithSuburb() throws Exception {
        when(request.getPostcode()).thenReturn("4000");
        when(request.getSuburb()).thenReturn("Brisbane");
        final EnergyProviderRequest providerRequest = requestAdapter.adapt(request);
        assertEquals(PostCode.instanceOf("4000"), providerRequest.getPostCode());
        assertEquals(Suburb.instanceOf("Brisbane"), providerRequest.getSuburb());
        verify(request, times(1)).getPostcode();
        verify(request, times(1)).getSuburb();
    }

    @Test(expected = IllegalArgumentException.class)
    public void adaptWithException() throws Exception {
        requestAdapter.adapt(request);
    }

}