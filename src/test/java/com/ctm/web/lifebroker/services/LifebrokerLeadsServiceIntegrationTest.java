package com.ctm.web.lifebroker.services;

import com.ctm.httpclient.jackson.DefaultJacksonMappers;
import com.ctm.web.core.config.AsyncRestTemplateConfig;
import com.ctm.web.lifebroker.model.LifebrokerLeadResponse;
import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {LifebrokerLeadsServiceIntegrationTest.Config.class, Jackson2ObjectMapperBuilder.class, DefaultJacksonMappers.class, AsyncRestTemplateConfig.class})
@TestPropertySource("classpath:application.properties")
public class LifebrokerLeadsServiceIntegrationTest {

    @Autowired
    private LifebrokerLeadsService lifeBrokerLeadsService;

    @Test
    public void getLeadResponse() {
            LifebrokerLeadResponse lifebrokerLeadResponse = lifeBrokerLeadsService.getLeadResponse("1234567", "john.doe@email.com", "123456789", "4037", "John Doe", "CTMREF01");
            Assert.assertNull(lifebrokerLeadResponse.getMessage());
            Assert.assertNotNull(lifebrokerLeadResponse.getClientReference());
    }

    @Configuration
    static class Config {

        @Bean
        public LifebrokerLeadsService lifebrokerLeadsService() {
            return new LifebrokerLeadsService();
        }


        @Bean
        public static PropertySourcesPlaceholderConfigurer propertiesResolver() {
            return new PropertySourcesPlaceholderConfigurer();
        }

    }

}
