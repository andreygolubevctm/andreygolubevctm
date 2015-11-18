package com.ctm.web.core.email.services.token;

import com.ctm.web.core.email.dao.EmailTokenDao;
import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.model.IncomingEmail;
import com.ctm.web.core.email.services.EmailUrlService;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.security.StringEncryption;
import com.ctm.web.core.services.FatalErrorService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.security.GeneralSecurityException;
import java.util.HashMap;
import java.util.Map;

import static com.ctm.web.core.logging.LoggingArguments.kv;


/**
 * Created by voba on 14/08/2015.
 */
public class EmailTokenService {
    private static final Logger LOGGER = LoggerFactory.getLogger(EmailTokenService.class);
    private String encryptionKey;
    private EmailTokenDao emailTokenDao;
    private EmailMasterDao emailMasterDao;

    public EmailTokenService(String encryptionKey, EmailTokenDao emailTokenDao, EmailMasterDao emailMasterDao) {
        this.encryptionKey = encryptionKey;
        this.emailTokenDao = emailTokenDao;
        this.emailMasterDao = emailMasterDao;
    }

    public String generateToken(Map<String, String> params) {
        return generateToken(params, true);
    }

    /**
     * Created to be called in JSP.
     */
    public String generateToken(Long transactionId, String hashedEmail, int styleCodeId, String emailTokenType, String action, String productId, String campaignId, String vertical, String productName, boolean createEmailTokenRecord) {
        Map<String, String> params = new HashMap<>();
        params.put(EmailUrlService.TRANSACTION_ID, Long.toString(transactionId));
        params.put(EmailUrlService.HASHED_EMAIL, hashedEmail);
        params.put(EmailUrlService.STYLE_CODE_ID, Integer.toString(styleCodeId));
        params.put(EmailUrlService.EMAIL_TOKEN_TYPE, emailTokenType);
        params.put(EmailUrlService.EMAIL_TOKEN_ACTION, action);

        if(productId != null && !productId.isEmpty()) {
            params.put(EmailUrlService.PRODUCT_ID, productId);
        }
        if(campaignId != null && !campaignId.isEmpty()) {
            params.put(EmailUrlService.CAMPAIGN_ID, campaignId);
        }
        if(vertical != null && !vertical.isEmpty()) {
            params.put(EmailUrlService.VERTICAL, vertical);
        }
        if(productName != null && !productName.isEmpty()) {
            params.put(EmailUrlService.PRODUCT_NAME, productName);
        }

        return generateToken(params, createEmailTokenRecord);
    }

    public String generateToken(Map<String, String> params, boolean createEmailTokenRecord) {
        Long transactionId = Long.parseLong(params.get(EmailUrlService.TRANSACTION_ID));
        String emailTokenType = params.get(EmailUrlService.EMAIL_TOKEN_TYPE);
        String emailTokenAction = params.get(EmailUrlService.EMAIL_TOKEN_ACTION);
        String hashedEmail = params.get(EmailUrlService.HASHED_EMAIL);
        int styleCodeId = Integer.parseInt(params.get(EmailUrlService.STYLE_CODE_ID));

        try {
            EmailMaster emailMaster = null;

            if(createEmailTokenRecord) {
                emailMaster = insertEmailTokenRecord(transactionId, hashedEmail, styleCodeId, emailTokenType, emailTokenAction);
            } else {
                emailMaster = emailMasterDao.getEmailMasterFromHashedEmail(hashedEmail, styleCodeId);
            }
            params.put(EmailUrlService.EMAIL_ID, Integer.toString(emailMaster.getEmailId()));

            StringBuilder content = new StringBuilder();
            int count = 1;
            for(String key : params.keySet()) {
                content.append(key);
                content.append("=");
                content.append(params.get(key));

                if(count != params.size()) {
                    content.append("&");
                }
                count++;
            }

            return StringEncryption.encrypt(encryptionKey, content.toString());
        } catch (DaoException | GeneralSecurityException e) {
            LOGGER.error("Error generating token {},{},{},{},{}",
                    kv("hashedEmail", hashedEmail),
                    kv("transactionId", transactionId),
                    kv("styleCodeId", styleCodeId),
                    kv("emailTokenType", emailTokenType),
                    kv("emailTokenAction", emailTokenAction));
            FatalErrorService.logFatalError(e, styleCodeId, "failed to generate token", "", true);

            throw new RuntimeException("Unable to generate token", e);
        }
    }

    public EmailMaster insertEmailTokenRecord(Long transactionId, String hashedEmail, int styleCodeId, String emailTokenType, String action) throws DaoException, GeneralSecurityException {
        EmailMaster emailMaster = emailMasterDao.getEmailMasterFromHashedEmail(hashedEmail, styleCodeId);

        emailTokenDao.addEmailToken(transactionId, new Long(emailMaster.getEmailId()), emailTokenType, action);

        return emailMaster;
    }

    public Map<String, String> decryptToken(String token) {
        Map<String, String> map = new HashMap<>();

        try {
            String decrypted[] = StringEncryption.decrypt(encryptionKey, token).split("&");
            for(String param : decrypted) {
                map.put(param.split("=")[0], param.split("=")[1]);
            }
            return map;
        } catch (GeneralSecurityException e) {
            LOGGER.error("Error decrypting token {}", kv("token", token));
            throw new RuntimeException("Unable to decrypt token", e);
        }
    }

    public EmailMaster getEmailAddressDetails(String token) {
        Map<String, String> map = decryptToken(token);

        Long transactionId = Long.parseLong(map.get(EmailUrlService.TRANSACTION_ID));
        Long emailId = Long.parseLong(map.get(EmailUrlService.EMAIL_ID));
        String emailTokenType = map.get(EmailUrlService.EMAIL_TOKEN_TYPE);
        String emailTokenAction = map.get(EmailUrlService.EMAIL_TOKEN_ACTION);

        try {
            return emailTokenDao.getEmailDetails(transactionId, emailId, emailTokenType, emailTokenAction);
        } catch (DaoException e) {
            LOGGER.error("Failed to get email details {},{},{},{},{}",
                    kv("emailId", emailId),
                    kv("transactionId", transactionId),
                    kv("emailTokenType", emailTokenType),
                    kv("emailTokenAction", emailTokenAction));
            throw new RuntimeException("Failed to get email details", e);
        }
    }

    public IncomingEmail getIncomingEmailDetails(String token) {
        Map<String, String> map = decryptToken(token);

        Long transactionId = Long.parseLong(map.get(EmailUrlService.TRANSACTION_ID));
        Long emailId = Long.parseLong(map.get(EmailUrlService.EMAIL_ID));
        String emailTokenType = map.get(EmailUrlService.EMAIL_TOKEN_TYPE);
        String emailTokenAction = map.get(EmailUrlService.EMAIL_TOKEN_ACTION);

        try {
            EmailMaster emailMaster = emailTokenDao.getEmailDetails(transactionId, emailId, emailTokenType, emailTokenAction);

            IncomingEmail incomingEmail = null;
            if (emailMaster != null) {
                incomingEmail = new IncomingEmail();
                incomingEmail.setCampaignId(map.get(EmailUrlService.CAMPAIGN_ID));
                incomingEmail.setEmailAddress(EmailUrlService.decodeEmailAddress(emailMaster.getEmailAddress()));
                incomingEmail.setEmailHash(emailMaster.getHashedEmail());
                incomingEmail.setEmailType(EmailMode.findByCode(emailTokenType));
                incomingEmail.setProductId(map.get(EmailUrlService.PRODUCT_ID));
                incomingEmail.setTransactionId(transactionId);
            }
            return incomingEmail;
        } catch (DaoException e) {
            LOGGER.error("Failed to get email details {},{},{},{},{}",
                    kv("emailId", emailId),
                    kv("transactionId", transactionId),
                    kv("emailTokenType", emailTokenType),
                    kv("emailTokenAction", emailTokenAction));
            throw new RuntimeException("Failed to get email details", e);
        }
    }

    public boolean hasLogin(String token) {
        Map<String, String> map = decryptToken(token);

        Long transactionId = Long.parseLong(map.get(EmailUrlService.TRANSACTION_ID));
        Long emailId = Long.parseLong(map.get(EmailUrlService.EMAIL_ID));
        String emailTokenType = map.get(EmailUrlService.EMAIL_TOKEN_TYPE);
        String emailTokenAction = map.get(EmailUrlService.EMAIL_TOKEN_ACTION);

        try {
            return emailTokenDao.hasLogin(transactionId, emailId, emailTokenType, emailTokenAction);
        } catch (DaoException e) {
            LOGGER.error("Failed to check if user has login {},{},{},{},{}",
                    kv("emailId", emailId),
                    kv("transactionId", transactionId),
                    kv("emailTokenType", emailTokenType),
                    kv("emailTokenAction", emailTokenAction));
            throw new RuntimeException("Failed to check if user has login", e);
        }
    }
}
