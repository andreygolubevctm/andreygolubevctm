package com.ctm.web.email;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.model.settings.Brand;
import org.apache.commons.lang3.StringUtils;
import org.junit.Assert;
import org.junit.Test;
import org.mockito.Mockito;

import javax.servlet.http.HttpServletRequest;

import java.util.Arrays;
import java.util.List;

import static org.mockito.Mockito.when;

public class MarketingAutomationEmailServiceTest {


    public static final String CAR = "car";
    public static final String TRAVEL = "travel";
    public static final String HEALTH = "health";
    public static final String TEST = "test";
    public static final long TRANSACTION_ID = 111l;
    public static final String ADDRESS = "Springfield";
    public static final String NAME = "Homer Simpson";
    public static final String CTM = "ctm";

    @Test
    public void givenValidRequest_whenGetEmailRequest_thenReturnValidEmailRequest() {

        //given
        final HttpServletRequest httpServletRequest = Mockito.mock(HttpServletRequest.class);
        when(httpServletRequest.getParameter("name")).thenReturn(NAME);
        when(httpServletRequest.getParameter("address")).thenReturn(ADDRESS);

        //when
        EmailRequest emailRequest = MarketingAutomationEmailService.getEmailRequest(httpServletRequest, getBrand(), TRANSACTION_ID);

        //then
        Assert.assertNotNull(emailRequest);
        Assert.assertEquals(NAME, emailRequest.getFirstName());
        Assert.assertEquals(ADDRESS, emailRequest.getAddress());
        Assert.assertEquals(CTM, emailRequest.getBrand());
        Assert.assertEquals("111", emailRequest.getTransactionId());
    }

    @Test
    public void givenValidVerticalCodeBrandTranId_whenValidateRequest_thenReturnTrue() {
        testValidateRequest(CAR, getBrand().getCode(), TRANSACTION_ID, true, MarketingAutomationEmailService.VALID_EMAIL_VERTICAL_LIST);
    }

    @Test
    public void givenEmptyVerticalCode_whenValidateRequest_thenReturnFalse() {
        testValidateRequest(StringUtils.EMPTY, getBrand().getCode(), TRANSACTION_ID,false, MarketingAutomationEmailService.VALID_EMAIL_VERTICAL_LIST);
    }

    @Test
    public void givenInvalidVerticalCode_whenValidateRequest_thenReturnFalse() {
        testValidateRequest(TEST, getBrand().getCode(), TRANSACTION_ID, false, MarketingAutomationEmailService.VALID_EMAIL_VERTICAL_LIST);
    }

    @Test
    public void givenInvalidBrand_whenValidateRequest_thenReturnFalse() {
        testValidateRequest(CAR, null, TRANSACTION_ID, false, MarketingAutomationEmailService.VALID_EMAIL_VERTICAL_LIST);
    }

    @Test
    public void givenInvalidTranId_whenValidateRequest_thenReturnFalse() {
        testValidateRequest(CAR, getBrand().getCode(), null, false, MarketingAutomationEmailService.VALID_EMAIL_VERTICAL_LIST);
    }

    @Test
    public void givenInvalidEmailEventVertical_whenValidateRequest_thenReturnFalse() {
        testValidateRequest(CAR, getBrand().getCode(), TRANSACTION_ID, false, MarketingAutomationEmailService.VALID_EMAIL_EVENT_VERTICAL_LIST);
    }

    @Test
    public void givenTravelEmailWithEmailAddress_thenAttemptEmailDistributionIsTrue(){
        EmailRequest emailRequest = new EmailRequest();
        emailRequest.setVertical(TRAVEL);
        emailRequest.setEmailAddress("test@comparethenmarket.com.au");
        Assert.assertTrue(MarketingAutomationEmailService.attemptEmailDistribution(emailRequest));
    }

    @Test
    public void givenTravelEmailWithOutEmailAddress_thenAttemptEmailDistributionIsFalse(){
        EmailRequest emailRequest = new EmailRequest();
        emailRequest.setVertical(TRAVEL);
        Assert.assertFalse(MarketingAutomationEmailService.attemptEmailDistribution(emailRequest));
    }

    @Test
    public void givenHealthEmailWithPopularProductSelected_thenAttemptEmailDistributionIsFalse(){
        EmailRequest emailRequest = new EmailRequest();
        emailRequest.setVertical(HEALTH);
        emailRequest.setPopularProductsSelected(true);
        Assert.assertFalse(MarketingAutomationEmailService.attemptEmailDistribution(emailRequest));
    }

    @Test
    public void givenHealthEmailWithOutPopularProductSelected_thenAttemptEmailDistributionIsTrue(){
        EmailRequest emailRequest = new EmailRequest();
        emailRequest.setVertical(HEALTH);
        emailRequest.setPopularProductsSelected(false);
        emailRequest.setEmailAddress("preload.testing@comparethemarket.com.au");
        Assert.assertTrue(MarketingAutomationEmailService.attemptEmailDistribution(emailRequest));
    }

    @Test
    public void givenCarEmail_thenAttemptEmailDistributionIsTrue(){
        EmailRequest emailRequest = new EmailRequest();
        emailRequest.setVertical(CAR);
        emailRequest.setEmailAddress("preload.testing@comparethemarket.com.au");
        Assert.assertTrue(MarketingAutomationEmailService.attemptEmailDistribution(emailRequest));
    }

    private static void testValidateRequest(final String verticalCode, final String brandCode, final Long transactionId, final boolean isValid, final List<VerticalType> validVerticalList) {
        //when
        boolean isValidRequest = MarketingAutomationEmailService.isValidRequest(verticalCode, brandCode, transactionId, validVerticalList);
        //then
        if (isValid) {
            Assert.assertTrue(isValidRequest);
        } else {
            Assert.assertFalse(isValidRequest);
        }
    }

    private Brand getBrand() {
        final Brand brand = new Brand();
        brand.setCode(CTM);
        return brand;
    }
}