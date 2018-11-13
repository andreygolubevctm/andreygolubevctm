package com.ctm.web.email.car;

import com.ctm.web.core.email.services.token.EmailTokenService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.XmlNode;
import com.ctm.web.email.EmailRequest;
import com.ctm.web.email.EmailUtils;
import com.ctm.web.email.car.CarModelTranslator;
import org.junit.Test;
import org.mockito.Mockito;

import javax.validation.ValidationException;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.anyBoolean;
import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Matchers.anyString;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.when;

/**
 * Responsible for testing CarModelTranslator.
 *
 * @See test/resources/email/car for example session data for different cases.
 */
public class CarModelTranslatorTest {

    public static final String BUDD_05_04 = "BUDD-05-04";
    public static final String BUDD_05_04_TPPD = "BUDD-05-04_TPPD";
    public static final String BASE_URL = "http://localhost:8080/ctm/";
    public static final String APPLY_URL_PREFIX = "email/incoming/gateway.json?gaclientid=";
    public static final String APPLY_URL_SUFFIX = "&cid=em:cm:car:200518:car_bp&et_rid=172883275&utm_source=car_quote_bp&utm_medium=email&utm_campaign=car_quote_bp&token=";
    public static final String TOKEN_BUDD = "TOKEN_BUDD";
    public static final String TOKEN_WOOL = "TOKEN_WOOL";
    public static final String GA_CLIENT_ID = "GA_CLIENT_ID";
    public static final String PRODUCT_ID_BUDD_01_01 = "BUDD-01-01";
    public static final String PRODUCT_ID_WOOL_01_01 = "WOOL-01-01";
    public static final String PROPERTY_PRODUCT_ID = "productId";
    public static final String TRANSACTION_ID = "1234";
    public static final int LUMP_SUM_TOTAL_BUDD_01_01 = 1111;
    public static final int LUMP_SUM_TOTAL_WOOL_01_01 = 2222;
    public static final int EXPECTED_NUMBER_OF_APPLY_URLS = 2;
    public static final String HASHED_EMAIL = "HASHED_EMAIL";
    public static final String TOKEN = "TOKEN";
    public static final String UNSUBSCRIBE_URL = "unsubscribe.jsp?token=";

    @Test
    public void givenSessionDataWithSingleTransaction_whenGetPremium_thenReturnValidPremium() {

        //given
        final Data sessionData = new Data();
        final XmlNode xmlNodeTempResultDetailsForComprehensiveCover = getXmlNodeForTempResultDetails(BUDD_05_04, 1111);
        sessionData.addChild(xmlNodeTempResultDetailsForComprehensiveCover);

        //when
        final String premiumFromSessionData = CarModelTranslator.getPremiumFromSessionData(sessionData, BUDD_05_04);

        //then
        assertEquals("1111", premiumFromSessionData);
    }

    @Test
    public void givenSessionDataWithMultipleTransactionsButDifferentCoverType_whenGetPremium_thenReturnValidPremium() {

        //given
        final Data sessionData = new Data();
        final XmlNode xmlNodeTempResultDetailsForComprehensiveCover = getXmlNodeForTempResultDetails(BUDD_05_04, 1111);
        final XmlNode xmlNodeTempResultDetailsForThirdPartyCover = getXmlNodeForTempResultDetails(BUDD_05_04_TPPD, 800);
        //multiple transactions but of different cover type hence different product ids.
        sessionData.addChild(xmlNodeTempResultDetailsForComprehensiveCover);
        sessionData.addChild(xmlNodeTempResultDetailsForThirdPartyCover);

        //when
        final String premiumFromSessionDataComprehensiveCover = CarModelTranslator.getPremiumFromSessionData(sessionData, BUDD_05_04);
        final String premiumFromSessionDataThirdPartyCover = CarModelTranslator.getPremiumFromSessionData(sessionData, BUDD_05_04_TPPD);

        //then
        assertEquals(2, sessionData.size());
        assertEquals("1111", premiumFromSessionDataComprehensiveCover);
        assertEquals("800", premiumFromSessionDataThirdPartyCover);
    }

    @Test
    public void givenSessionDataWithMultipleTransactionsWithSameCoverType_whenGetPremium_thenReturnValidPremium() {

        //given
        final Data sessionData = new Data();
        final XmlNode xmlNodeTempResultDetailsForComprehensiveCover = getXmlNodeForTempResultDetails(BUDD_05_04, 1111);
        final XmlNode xmlNodeTempResultDetailsForComprehensiveCoverEdited1 = getXmlNodeForTempResultDetails(BUDD_05_04, 2222);
        final XmlNode xmlNodeTempResultDetailsForComprehensiveCoverEdited2 = getXmlNodeForTempResultDetails(BUDD_05_04, 3333);
        //multiple transactions
        sessionData.addChild(xmlNodeTempResultDetailsForComprehensiveCover);
        sessionData.addChild(xmlNodeTempResultDetailsForComprehensiveCoverEdited1);
        sessionData.addChild(xmlNodeTempResultDetailsForComprehensiveCoverEdited2);

        //when
        final String premiumFromSessionData = CarModelTranslator.getPremiumFromSessionData(sessionData, BUDD_05_04);

        //then
        assertEquals(3, sessionData.size());
        assertEquals("3333", premiumFromSessionData);
    }

    @Test(expected = ValidationException.class)
    public void givenEmptySessionData_whenGetPremium_thenThrowException() {
        //given
        final Data sessionData = new Data();
        //when
        CarModelTranslator.getPremiumFromSessionData(sessionData, BUDD_05_04);
        //then exception thrown
    }

    @Test
    public void givenValidEmailRequest_whenGetUnsubscribeUrl_thenReturnValidUnsubscribeUrlWithToken() throws ConfigSettingException {

        //given
        EmailTokenService emailTokenService = Mockito.mock(EmailTokenService.class);
        EmailRequest emailRequest = Mockito.mock(EmailRequest.class);
        PageSettings pageSettings = Mockito.mock(PageSettings.class);

        when(emailTokenService.generateToken(anyLong(), anyString(), anyInt(), anyString(), anyString(), anyString(), anyObject(), anyObject(), anyString(), anyBoolean())).thenReturn(TOKEN);
        when(pageSettings.getBaseUrl()).thenReturn(BASE_URL);
        when(emailRequest.getTransactionId()).thenReturn(TRANSACTION_ID);

        //when
        final String unsubscribeUrl = CarModelTranslator.getUnsubscribeUrl(emailTokenService, emailRequest, HASHED_EMAIL, pageSettings);

        //then
        assertEquals(BASE_URL + UNSUBSCRIBE_URL + TOKEN, unsubscribeUrl);
    }

    @Test
    public void givenTwoProductsForTransaction_whenGetApplyUrls_thenReturnTwoValidApplyUrls() throws ConfigSettingException, DaoException, GeneralSecurityException {

        //given
        EmailTokenService emailTokenService = Mockito.mock(EmailTokenService.class);
        PageSettings pageSettings = Mockito.mock(PageSettings.class);
        EmailRequest emailRequest = Mockito.mock(EmailRequest.class);
        EmailUtils emailUtils = Mockito.mock(EmailUtils.class);

        when(emailRequest.getTransactionId()).thenReturn(TRANSACTION_ID);

        List<ResultProperty> resultProperties = new ArrayList<>();
        ResultProperty buddResultProperty = new ResultProperty();
        ResultProperty woolResultProperty = new ResultProperty();
        buddResultProperty.setProductId(PRODUCT_ID_BUDD_01_01);
        buddResultProperty.setProperty(PROPERTY_PRODUCT_ID);
        buddResultProperty.setValue(PRODUCT_ID_BUDD_01_01);
        woolResultProperty.setProductId(PRODUCT_ID_WOOL_01_01);
        woolResultProperty.setProperty(PROPERTY_PRODUCT_ID);
        woolResultProperty.setValue(PRODUCT_ID_WOOL_01_01);
        resultProperties.add(buddResultProperty);
        resultProperties.add(woolResultProperty);

        when(emailUtils.getResultPropertiesForTransaction(anyString())).thenReturn(resultProperties);

        final Data sessionData = new Data();
        final XmlNode buddPremiumData = getXmlNodeForTempResultDetails(PRODUCT_ID_BUDD_01_01, LUMP_SUM_TOTAL_BUDD_01_01);
        final XmlNode woolPremiumData = getXmlNodeForTempResultDetails(PRODUCT_ID_WOOL_01_01, LUMP_SUM_TOTAL_WOOL_01_01);
        sessionData.addChild(buddPremiumData);
        sessionData.addChild(woolPremiumData);

        when(pageSettings.getBaseUrl()).thenReturn(BASE_URL);
        when(emailTokenService.generateToken(anyLong(), anyString(), anyInt(), anyString(), anyString(), eq(PRODUCT_ID_BUDD_01_01), anyObject(), anyObject(), anyString(), anyBoolean())).thenReturn(TOKEN_BUDD);
        when(emailTokenService.generateToken(anyLong(), anyString(), anyInt(), anyString(), anyString(), eq(PRODUCT_ID_WOOL_01_01), anyObject(), anyObject(), anyString(), anyBoolean())).thenReturn(TOKEN_WOOL);
        when(emailRequest.getGaClientID()).thenReturn(GA_CLIENT_ID);

        //when
        final List<String> applyUrls = CarModelTranslator.getApplyUrls(emailTokenService, HASHED_EMAIL, pageSettings, emailRequest, sessionData, emailUtils);

        //then
        final String expectedApplyUrlForBudd = BASE_URL + APPLY_URL_PREFIX + GA_CLIENT_ID + APPLY_URL_SUFFIX + TOKEN_BUDD;
        final String expectedApplyUrlForWool = BASE_URL + APPLY_URL_PREFIX + GA_CLIENT_ID + APPLY_URL_SUFFIX + TOKEN_WOOL;

        assertEquals(EXPECTED_NUMBER_OF_APPLY_URLS, applyUrls.size());
        assertEquals(expectedApplyUrlForBudd, applyUrls.get(0));
        assertEquals(expectedApplyUrlForWool, applyUrls.get(1));

    }


    /* ***********************************************************************************************************
     * Helper methods
     */

    private XmlNode getXmlNodeForTempResultDetails(final String productId, final Integer lumpSumTotal) {
        final XmlNode xmlNodeTempResultDetails = new XmlNode("tempResultDetails");
        xmlNodeTempResultDetails
                .addChild(new XmlNode("results"))
                .addChild(new XmlNode(productId))
                .addChild(new XmlNode("headline"))
                .put("lumpSumTotal", lumpSumTotal);
        return xmlNodeTempResultDetails;
    }
}
