package com.ctm.web.energy.product.adapter;

import com.ctm.energy.product.request.model.EnergyProductRequest;
import com.ctm.interfaces.common.types.ProductId;
import com.ctm.web.energy.form.model.EnergyProductInfoWebRequest;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class EnergyProductServiceRequestAdapterTest {

    @Mock
    private EnergyProductInfoWebRequest request;

    private EnergyProductServiceRequestAdapter requestAdapter = new EnergyProductServiceRequestAdapter();

    @Before
    public void setup() {
        initMocks(this);
    }

    @Test
    public void adapt() throws Exception {
        when(request.getProductId()).thenReturn("2213");
        final EnergyProductRequest productRequest = requestAdapter.adapt(request);
        assertEquals(ProductId.instanceOf("2213"), productRequest.getProductId());
    }

    @Test(expected = IllegalArgumentException.class)
    public void adaptWithException() throws Exception {
        requestAdapter.adapt(request);
    }

}