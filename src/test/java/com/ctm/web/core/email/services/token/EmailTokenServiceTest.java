package com.ctm.web.core.email.services.token;

import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.email.dao.EmailTokenDao;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.model.IncomingEmail;
import com.ctm.web.core.email.services.EmailUrlService;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.security.StringEncryption;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.security.GeneralSecurityException;
import java.util.HashMap;
import java.util.Map;

import static org.mockito.Mockito.*;


public class EmailTokenServiceTest {
    private EmailTokenService emailTokenService;

    @Mock
    private EmailTokenDao emailTokenDao;

    @Mock
    private EmailMasterDao emailMasterDao;
    private String secretKey = "AAAAAAAAAAAAAAAAAAAAAA";

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
        emailTokenService = new EmailTokenService(secretKey, emailTokenDao, emailMasterDao);
    }

    @Test
    public void testGenerateToken() throws DaoException, GeneralSecurityException {
        Map<String, String> params = new HashMap<>();
        params.put(EmailUrlService.TRANSACTION_ID, "12345678");
        params.put(EmailUrlService.HASHED_EMAIL, "aaaaaaaa");
        params.put(EmailUrlService.STYLE_CODE_ID, "1");
        params.put(EmailUrlService.EMAIL_TOKEN_TYPE, "type");
        params.put(EmailUrlService.EMAIL_TOKEN_ACTION, "subscribe");

        EmailMaster emailMaster = new EmailMaster();
        emailMaster.setEmailId(1);
        when(emailMasterDao.getEmailMasterFromHashedEmail("aaaaaaaa", 1)).thenReturn(emailMaster);
        doNothing().when(emailTokenDao).addEmailToken(12345678L, 1L, "type", "subscribe");

        String token = emailTokenService.generateToken(params);
        Assert.assertNotNull(token);

        verify(emailMasterDao).getEmailMasterFromHashedEmail("aaaaaaaa", 1);
        verify(emailTokenDao).addEmailToken(12345678L, 1L, "type", "subscribe");

        String token2 = emailTokenService.generateToken(params);
        Assert.assertNotNull(token2);
        //encrypting the same params again should give different token
        Assert.assertNotEquals(token, token2);

        Map<String, String> decryptedMap = emailTokenService.decryptToken(token);
        Map<String, String> decryptedMap2 = emailTokenService.decryptToken(token2);
        Assert.assertEquals(decryptedMap, decryptedMap2);
    }


    @Test
    public void testSetProductName() throws DaoException, GeneralSecurityException {
        Map<String, String> params = new HashMap<>();
        EmailTokenService.setProductName("Silver Hospital Level 2 & Bronze Extras Set Benefits" , params);
        String expectedProductName = "Silver%20Hospital%20Level%202%20%26%20Bronze%20Extras%20Set%20Benefits";
        Assert.assertEquals(params.get(EmailUrlService.PRODUCT_NAME), expectedProductName);
    }

    @Test
    public void testGenerateTokenNoTokenInserted() throws DaoException, GeneralSecurityException {
        Map<String, String> params = new HashMap<>();
        params.put(EmailUrlService.TRANSACTION_ID, "12345678");
        params.put(EmailUrlService.HASHED_EMAIL, "aaaaaaaa");
        params.put(EmailUrlService.STYLE_CODE_ID, "1");
        params.put(EmailUrlService.EMAIL_TOKEN_TYPE, "type");
        params.put(EmailUrlService.EMAIL_TOKEN_ACTION, "subscribe");

        EmailMaster emailMaster = new EmailMaster();
        emailMaster.setEmailId(1);
        when(emailMasterDao.getEmailMasterFromHashedEmail("aaaaaaaa", 1)).thenReturn(emailMaster);
        doThrow(new RuntimeException("It should not be called")).when(emailTokenDao).addEmailToken(12345678L, 1L, "type", "subscribe");

        String token = emailTokenService.generateToken(params, false);

        verify(emailMasterDao, times(1)).getEmailMasterFromHashedEmail("aaaaaaaa", 1);
        verifyZeroInteractions(emailTokenDao);

        Assert.assertNotNull(token);
    }

    @Test
    public void testGenerateTokenAdditionalParameters() throws DaoException, GeneralSecurityException {
        String encodedProductId = "Silver%20Hospital%20Level%202%20%26%20Bronze%20Extras%20Set%20Benefits";
        String productId = "Silver Hospital Level 2 & Bronze Extras Set Benefits";

        Map<String, String> encypted = new HashMap<>();
        encypted.put(EmailUrlService.TRANSACTION_ID, "12345678");
        encypted.put(EmailUrlService.HASHED_EMAIL, "aaaaaaaa");
        encypted.put(EmailUrlService.STYLE_CODE_ID, "1");
        encypted.put(EmailUrlService.EMAIL_TOKEN_TYPE, "type");
        encypted.put(EmailUrlService.EMAIL_TOKEN_ACTION, "subscribe");
        encypted.put(EmailUrlService.PRODUCT_ID, "myProductId");
        encypted.put(EmailUrlService.CAMPAIGN_ID, "myCampaignId");
        encypted.put(EmailUrlService.VERTICAL, "myVertical");
        encypted.put(EmailUrlService.PRODUCT_NAME, encodedProductId);
        encypted.put(EmailUrlService.EMAIL_ID, "1");

        EmailMaster emailMaster = new EmailMaster();
        emailMaster.setEmailId(1);
        when(emailMasterDao.getEmailMasterFromHashedEmail("aaaaaaaa", 1)).thenReturn(emailMaster);
        doThrow(new RuntimeException("It should not be called")).when(emailTokenDao).addEmailToken(12345678L, 1L, "type", "subscribe");

        String token = emailTokenService.generateToken(encypted, false);

        HashMap<String, String> expectedDecrypted = new HashMap<>(encypted);
        expectedDecrypted.put(EmailUrlService.PRODUCT_NAME, productId);

        Map<String, String> params = emailTokenService.decryptToken(token);

        Assert.assertEquals(expectedDecrypted, params);
    }

    @Test
    public void testDecryptToken() throws DaoException, GeneralSecurityException {
        Map<String, String> expectedDecrypted = new HashMap<>();
        expectedDecrypted.put(EmailUrlService.TRANSACTION_ID, "12345678");
        expectedDecrypted.put(EmailUrlService.HASHED_EMAIL, "aaaaaaaa");
        expectedDecrypted.put(EmailUrlService.STYLE_CODE_ID, "1");
        expectedDecrypted.put(EmailUrlService.EMAIL_TOKEN_TYPE, "type");
        expectedDecrypted.put(EmailUrlService.EMAIL_TOKEN_ACTION, "subscribe");
        expectedDecrypted.put(EmailUrlService.EMAIL_ID, "1");

        Map<String, String> params = emailTokenService.decryptToken("nPW3GtW3yoy7Rj1q89phinxwXrp2n1NAayDJTVLFoYxMPle44-9Zum--dTpmVhL2z6GTo8rPq--pREg-0DO0kqNr2pbj5LzH1qcgR59zFiT81uilG5lTtTqXOmjnf-uOpIbNWEO33ItwEhMHShMDgygRakaAWn_jfGXWKPBuG329ATkM");

        Assert.assertEquals(expectedDecrypted, params);
    }

    @Test
    public void testDecryptECB_whenTokenIsECBEncrypted_tokenIsDecrypted() {
        Map<String, String> expectedDecrypted = new HashMap<>();
        expectedDecrypted.put(EmailUrlService.TRANSACTION_ID, "12345678");
        expectedDecrypted.put(EmailUrlService.HASHED_EMAIL, "aaaaaaaa");
        expectedDecrypted.put(EmailUrlService.STYLE_CODE_ID, "1");
        expectedDecrypted.put(EmailUrlService.EMAIL_TOKEN_TYPE, "type");
        expectedDecrypted.put(EmailUrlService.EMAIL_TOKEN_ACTION, "subscribe");
        expectedDecrypted.put(EmailUrlService.EMAIL_ID, "1");

        Map<String, String> params = emailTokenService.decryptToken("LxdLS6JbFjoGed60PhMBb1G3-LDbW7eH_b6UzsxF32x1vflt-b2Kg6lqkrma9fondcOBAusakomj5AT_3cgTTdeJqIxtnPeWlRODczy4fjaDoPV35IudpjTkY_4SqSn2daHWp25ImHWZ2OMxwI0mCw");

        Assert.assertEquals(expectedDecrypted, params);
    }


    @Test
    public void testDecryptTokenWithOut() throws DaoException, GeneralSecurityException {
        Map<String, String> expectedDecrypted = new HashMap<>();
        expectedDecrypted.put("productName" ,  "Silver Hospital Level 2 ");

        String token = StringEncryption.encrypt(secretKey, "productName=Silver Hospital Level 2 & Bronze Extras Set Benefits");

        Map<String, String> params = emailTokenService.decryptToken(token);

        Assert.assertEquals(expectedDecrypted, params);
    }

    @Test
    public void testGetIncomingEmailDetails() throws DaoException, GeneralSecurityException {
        Map<String, String> params = new HashMap<>();
        params.put(EmailUrlService.TRANSACTION_ID, "12345678");
        params.put(EmailUrlService.HASHED_EMAIL, "aaaaaaaa");
        params.put(EmailUrlService.STYLE_CODE_ID, "1");
        params.put(EmailUrlService.EMAIL_TOKEN_TYPE, "bestprice");
        params.put(EmailUrlService.EMAIL_TOKEN_ACTION, "unsubscribe");
        params.put(EmailUrlService.PRODUCT_ID, "myProductId");
        params.put(EmailUrlService.CAMPAIGN_ID, "myCampaignId");
        params.put(EmailUrlService.VERTICAL, "myVertical");
        params.put(EmailUrlService.PRODUCT_NAME, "myProductName");
        params.put(EmailUrlService.EMAIL_ID, "1");

        EmailMaster emailMaster = new EmailMaster();
        emailMaster.setEmailId(1);
        emailMaster.setEmailAddress("unit.test@comparethemarket.com.au");
        emailMaster.setHashedEmail("bbbbbbbb");
        when(emailMasterDao.getEmailMasterFromHashedEmail("aaaaaaaa", 1)).thenReturn(emailMaster);
        when(emailTokenDao.getEmailDetails(12345678L, 1L, "bestprice", "unsubscribe")).thenReturn(emailMaster);

        String token = emailTokenService.generateToken(params, false);
        IncomingEmail incomingEmail = emailTokenService.getIncomingEmailDetails(token);

        IncomingEmail expectedIncomingEmail = new IncomingEmail();
        expectedIncomingEmail.setCampaignId("myCampaignId");
        expectedIncomingEmail.setEmailAddress("unit.test@comparethemarket.com.au");
        expectedIncomingEmail.setEmailHash("bbbbbbbb");
        expectedIncomingEmail.setEmailType(EmailMode.BEST_PRICE);
        expectedIncomingEmail.setProductId("myProductId");
        expectedIncomingEmail.setTransactionId(12345678L);

        Assert.assertNotNull(incomingEmail);
        Assert.assertEquals(expectedIncomingEmail.toString(), incomingEmail.toString());
    }

    @Test
    public void testGetIncomingEmailDetailsNotFound() throws DaoException, GeneralSecurityException {
        Map<String, String> params = new HashMap<>();
        params.put(EmailUrlService.TRANSACTION_ID, "12345678");
        params.put(EmailUrlService.HASHED_EMAIL, "aaaaaaaa");
        params.put(EmailUrlService.STYLE_CODE_ID, "1");
        params.put(EmailUrlService.EMAIL_TOKEN_TYPE, "bestprice");
        params.put(EmailUrlService.EMAIL_TOKEN_ACTION, "unsubscribe");
        params.put(EmailUrlService.PRODUCT_ID, "myProductId");
        params.put(EmailUrlService.CAMPAIGN_ID, "myCampaignId");
        params.put(EmailUrlService.VERTICAL, "myVertical");
        params.put(EmailUrlService.PRODUCT_NAME, "myProductName");
        params.put(EmailUrlService.EMAIL_ID, "1");

        EmailMaster emailMaster = new EmailMaster();
        emailMaster.setEmailId(1);
        emailMaster.setEmailAddress("unit.test@comparethemarket.com.au");
        emailMaster.setHashedEmail("bbbbbbbb");
        when(emailMasterDao.getEmailMasterFromHashedEmail("aaaaaaaa", 1)).thenReturn(emailMaster);
        when(emailTokenDao.getEmailDetails(12345678L, 1L, "bestprice", "unsubscribe")).thenReturn(null);

        String token = emailTokenService.generateToken(params, false);
        IncomingEmail incomingEmail = emailTokenService.getIncomingEmailDetails(token);

        IncomingEmail expectedIncomingEmail = new IncomingEmail();
        expectedIncomingEmail.setCampaignId("myCampaignId");
        expectedIncomingEmail.setEmailAddress("unit.test@comparethemarket.com.au");
        expectedIncomingEmail.setEmailHash("bbbbbbbb");
        expectedIncomingEmail.setEmailType(EmailMode.BEST_PRICE);
        expectedIncomingEmail.setProductId("myProductId");
        expectedIncomingEmail.setTransactionId(12345678L);

        Assert.assertNull(incomingEmail);
    }
}
