package com.ctm.web.life.services;

import com.ctm.web.core.services.RestClient;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.life.quote.adapter.LifeQuoteServiceRequestAdapter;
import com.ctm.web.life.quote.adapter.LifeQuoteServiceResponseAdapter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import static org.mockito.Mockito.mock;


@Configuration
public class TestConfig {

    private static RestClient restClient = mock(RestClient.class);
    private static ServiceConfigurationService serviceConfigurationService = mock(ServiceConfigurationService.class);
    private static LifeQuoteServiceRequestAdapter lifeQuoteServiceRequestAdapter = mock(LifeQuoteServiceRequestAdapter.class);
    private static LifeQuoteServiceResponseAdapter lifeQuoteServiceResponseAdapter = mock(LifeQuoteServiceResponseAdapter.class);

    @Bean
    public static RestClient getRestClient() {
        return restClient;
    }

    @Bean
    public static ServiceConfigurationService getServiceConfigurationService() {
        return serviceConfigurationService;
    }

    @Bean
    public static LifeQuoteServiceRequestAdapter getLifeQuoteServiceRequestAdapter() {
        return lifeQuoteServiceRequestAdapter;
    }

    @Bean
    public static LifeQuoteServiceResponseAdapter getLifeQuoteServiceResponseAdapter() {
        return lifeQuoteServiceResponseAdapter;
    }

    public static void reset(){
        restClient = mock(RestClient.class);
        serviceConfigurationService = mock(ServiceConfigurationService.class);
        lifeQuoteServiceRequestAdapter = mock(LifeQuoteServiceRequestAdapter.class);
        lifeQuoteServiceResponseAdapter = mock(LifeQuoteServiceResponseAdapter.class);
    }

}
