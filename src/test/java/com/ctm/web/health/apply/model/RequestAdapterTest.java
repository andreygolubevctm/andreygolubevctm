package com.ctm.web.health.apply.model;

import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import org.junit.Test;

import static org.mockito.Mockito.*;

public class RequestAdapterTest {

    @Test
    public void adaptTest() throws Exception {
        final HealthRequest healthRequest = mock(HealthRequest.class);
        final HealthQuote healthQuote = mock(HealthQuote.class);
        final Application application = mock(Application.class);

        when(healthRequest.getQuote()).thenReturn(healthQuote);
        when(healthQuote.getApplication()).thenReturn(application);
        when(application.getProvider()).thenReturn("");

        RequestAdapter.adapt(healthRequest);

        verify(application, atLeast(1)).getProvider();

    }

}