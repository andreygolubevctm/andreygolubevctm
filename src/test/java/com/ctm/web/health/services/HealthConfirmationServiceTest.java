package com.ctm.web.health.services;

import com.ctm.web.core.confirmation.model.Confirmation;
import com.ctm.web.core.confirmation.services.ConfirmationService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.apply.model.response.HealthApplicationResponse;
import com.ctm.web.health.model.form.*;
import com.ctm.web.health.model.providerInfo.ProviderInfo;
import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.beans.HasPropertyWithValue.hasProperty;
import static org.junit.Assert.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class HealthConfirmationServiceTest {

    private HealthConfirmationService healthConfirmationService;
    @Mock
    private ProviderContentService providerContentService;
    @Mock
    private ConfirmationService confirmationService;
    @Mock
    private HealthSelectedProductService selectedProductService;
    @Mock
    private HttpServletRequest request;
    private HealthRequest data;
    private String providerName = "TEST";

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        healthConfirmationService = new HealthConfirmationService( providerContentService,  confirmationService, selectedProductService );
         data = new HealthRequest();
        data.setTransactionId(10000L);
        HealthQuote health = new HealthQuote();
        Application application = new Application();
        application.setProviderName(providerName);
        Person primary = new Person();
        primary.setFirstname("Sergie");
        application.setPrimary(primary);
        health.setApplication(application);
        Payment payment = new Payment();
        PaymentDetails details = new PaymentDetails();
        details.setFrequency("monthly");
        details.setStart("06/01/2016");
        payment.setDetails(details);
        payment.setPolicyDate("06/01/2016");
        health.setPayment(payment);
        data.setHealth(health);
    }

    @Test
    public void shouldCreateAndSaveConfirmation() throws Exception {
        String expectedFirstName = "Sergie";
        String expectedLastName = "Meerkat";
        String expectedWebsite = "expectedWebsite";
        String expectedPhoneNumber = "expectedPhoneNumber";
        String expectedEmail = "expectedEmail";
        String policyNo = "policyNo";
        data.getQuote().getApplication().getPrimary().setFirstname(expectedFirstName);
        data.getQuote().getApplication().getPrimary().setSurname(expectedLastName);
        data.getQuote().getApplication().setProductId("1234567");
        HealthApplicationResponse response = new HealthApplicationResponse();
        response.productId = policyNo;
        String confirmationId = "123456";
        Data dataBucket = new Data();
        ProviderInfo providerInfo = ProviderInfo.newProviderInfo()
                .website(expectedWebsite)
                .phoneNumber(expectedPhoneNumber).email(expectedEmail).build();
        when(providerContentService.getProviderInfo( request,  providerName)).thenReturn(providerInfo);
        healthConfirmationService.createAndSaveConfirmation( request, data, response, confirmationId, dataBucket);
        String expectedData = "<data><transID>10000</transID><status>OK</status>" +
                "<vertical>CTMH</vertical><startDate>06/01/2016</startDate>" +
                "<frequency>M</frequency><about/>" +
                "<firstName>"+ expectedFirstName + "</firstName>" +
                "<lastName>" + expectedLastName + "</lastName>" +
                "<providerInfo>" +
                "<phoneNumber>" + expectedPhoneNumber + "</phoneNumber>" +
                "<email>" + expectedEmail + "</email>" +
                "<website>" + expectedWebsite + "</website>" +
                "</providerInfo><whatsNext/><product/><policyNo>"+policyNo+"</policyNo><paymentType/><redemptionId></redemptionId><voucherValue></voucherValue></data>";

        ArgumentCaptor<Confirmation> argument = ArgumentCaptor.forClass(Confirmation.class);
        verify(confirmationService).addConfirmation(argument.capture());

        assertThat(argument.getValue(), hasProperty("xmlData", is(expectedData)));
    }

}