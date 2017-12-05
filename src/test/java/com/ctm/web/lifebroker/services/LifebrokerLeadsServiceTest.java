package com.ctm.web.lifebroker.services;

import com.ctm.httpclient.jackson.DefaultJacksonMappers;
import com.ctm.web.core.config.AsyncRestTemplateConfig;
import com.ctm.web.lifebroker.model.LifebrokerLeadResponse;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.AsyncRestTemplate;

import javax.faces.render.FacesBehaviorRenderer;

import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withServerError;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {LifebrokerLeadsServiceTest.Config.class, Jackson2ObjectMapperBuilder.class, DefaultJacksonMappers.class, AsyncRestTemplateConfig.class})
@TestPropertySource(properties = {"lifebroker.lead.endpoint=/2-7-0/lead/new", "lifebroker.lead.username=UATcompthemkt", "lifebroker.lead.password=lI9hW2qIlx2f4G"})
public class LifebrokerLeadsServiceTest {


    private MockRestServiceServer mockRestServiceServer;

    @Autowired
    private LifebrokerLeadsService lifeBrokerLeadsService;

    @Autowired
    private AsyncRestTemplate asyncRestTemplate;


    @Before
    public void setup() {
        mockRestServiceServer = MockRestServiceServer.createServer(asyncRestTemplate);
    }


    @Test
    public void getLeadResponse() {
        mockRestServiceServer.expect(requestTo("/2-7-0/lead/new"))
                .andExpect(method(HttpMethod.POST))
                .andRespond(withSuccess().contentType(MediaType.TEXT_XML).body("<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                        "<results xmlns=\"urn:Lifebroker.EnterpriseAPI\">\n" +
                        "    <client>\n" +
                        "        <reference>fea7c00759ebc77fd3bb0a</reference>\n" +
                        "    </client>\n" +
                        "</results>"));

        LifebrokerLeadResponse lifebrokerLeadResponse = lifeBrokerLeadsService.getLeadResponse("1234567", "john.doe@email.com", "123456789", "4037", "John Doe", "CTMREF01");
        Assert.assertNull(lifebrokerLeadResponse.getMessage());
        Assert.assertNotNull(lifebrokerLeadResponse.getClientReference());
        Assert.assertEquals("fea7c00759ebc77fd3bb0a", lifebrokerLeadResponse.getClientReference());
    }

    @Test
    public void getLeadResponseError() {
        mockRestServiceServer.expect(requestTo("/2-7-0/lead/new"))
                .andExpect(method(HttpMethod.POST))
                .andRespond(withSuccess().contentType(MediaType.TEXT_XML).body("<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                        "<results xmlns=\"urn:Lifebroker.EnterpriseAPI\">\n" +
                        "    <contact error=\"Email is required.\"/>\n" +
                        "</results>"));

        LifebrokerLeadResponse lifebrokerLeadResponse = lifeBrokerLeadsService.getLeadResponse("1234567", "", "123456789", "4037", "John Doe", "CTMREF01");
        Assert.assertNotNull(lifebrokerLeadResponse.getMessage());
        Assert.assertNull(lifebrokerLeadResponse.getClientReference());
        Assert.assertEquals("Email is required.", lifebrokerLeadResponse.getMessage());
    }

    @Test
    public void getLeadResponseErrorException() {
        mockRestServiceServer.expect(requestTo("/2-7-0/lead/new"))
                .andRespond(withServerError());

        LifebrokerLeadResponse lifebrokerLeadResponse = lifeBrokerLeadsService.getLeadResponse("1234567", "", "123456789", "4037", "John Doe", "CTMREF01");
        Assert.assertNotNull(lifebrokerLeadResponse.getMessage());
        Assert.assertNull(lifebrokerLeadResponse.getClientReference());
        Assert.assertEquals("org.springframework.web.client.HttpServerErrorException: 500 Internal Server Error", lifebrokerLeadResponse.getMessage());
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
