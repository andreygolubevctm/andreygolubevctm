package com.ctm.web.email;

import com.ctm.web.core.model.settings.Brand;
import org.apache.commons.lang3.StringUtils;
import org.junit.Assert;
import org.junit.Test;
import org.mockito.Mockito;

import javax.servlet.http.HttpServletRequest;

import static org.mockito.Mockito.when;

public class MarketingAutomationEmailServiceTest {


    public static final String CAR = "car";
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
        testValidateRequest(CAR, getBrand(), TRANSACTION_ID, true);
    }

    @Test
    public void givenEmptyVerticalCode_whenValidateRequest_thenReturnFalse() {
        testValidateRequest(StringUtils.EMPTY, getBrand(), TRANSACTION_ID,false);
    }

    @Test
    public void givenInvalidVerticalCode_whenValidateRequest_thenReturnFalse() {
        testValidateRequest(TEST, getBrand(), TRANSACTION_ID, false);
    }

    @Test
    public void givenInvalidBrand_whenValidateRequest_thenReturnFalse() {
        testValidateRequest(CAR, null, TRANSACTION_ID, false);
    }

    @Test
    public void givenInvalidTranId_whenValidateRequest_thenReturnFalse() {
        testValidateRequest(CAR, getBrand(), null, false);
    }

    private static void testValidateRequest(final String verticalCode, final Brand brand, final Long transactionId, final boolean isValid) {
        //when
        boolean isValidRequest = MarketingAutomationEmailService.isValidRequest(verticalCode, brand, transactionId);
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