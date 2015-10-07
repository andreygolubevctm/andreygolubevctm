package com.ctm.services;

import com.ctm.dao.EmailMasterDao;
import com.ctm.dao.TokenDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.EmailMaster;
import com.ctm.model.email.EmailMode;
import com.ctm.model.email.IncomingEmail;
import com.ctm.security.StringEncryption;
import com.ctm.services.email.EmailUrlService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.security.GeneralSecurityException;
import java.util.HashMap;
import java.util.Map;

import static com.ctm.logging.LoggingArguments.kv;

/**
 * Created by voba on 14/08/2015.
 */
public class TokenService {
    private static final Logger LOGGER = LoggerFactory.getLogger(TokenService.class);

    private static final String privateKey = "7T7XVh0UCtM7JNzcZX1e-2";

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
        EmailMaster emailMaster = null;

        Long transactionId = Long.parseLong(params.get(EmailUrlService.TRANSACTION_ID));
        String emailTokenType = params.get(EmailUrlService.EMAIL_TOKEN_TYPE);
        String emailTokenAction = params.get(EmailUrlService.EMAIL_TOKEN_ACTION);
        String hashedEmail = params.get(EmailUrlService.HASHED_EMAIL);
        int styleCodeId = Integer.parseInt(params.get(EmailUrlService.STYLE_CODE_ID));

        try {
            if(createEmailTokenRecord) {
                emailMaster = insertEmailTokenRecord(transactionId, hashedEmail, styleCodeId, emailTokenType, emailTokenAction);
            } else {
                EmailMasterDao emailMasterDao = new EmailMasterDao();
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

            return StringEncryption.encrypt(privateKey, content.toString());
        } catch (DaoException | GeneralSecurityException e) {
            LOGGER.error("Error generating token {},{},{},{},{}",
                    kv("hashedEmail", hashedEmail),
                    kv("transactionId", transactionId),
                    kv("styleCodeId", styleCodeId),
                    kv("emailTokenType", emailTokenType),
                    kv("emailTokenAction", emailTokenAction));
            FatalErrorService.logFatalError(e, styleCodeId, "failed to generate token", "", true);
        }
        throw new RuntimeException("Unable to generate token");
    }

    public EmailMaster insertEmailTokenRecord(Long transactionId, String hashedEmail, int styleCodeId, String emailTokenType, String action) throws DaoException, GeneralSecurityException {
        EmailMasterDao emailMasterDao = new EmailMasterDao();
        EmailMaster emailMaster = emailMasterDao.getEmailMasterFromHashedEmail(hashedEmail, styleCodeId);

        TokenDao tokenDao = new TokenDao();
        tokenDao.addEmailToken(transactionId, new Long(emailMaster.getEmailId()), emailTokenType, action);

        return emailMaster;
    }

    public Map<String, String> decryptToken(String token) {
        Map<String, String> map = new HashMap<>();

        try {
            String decrypted[] = StringEncryption.decrypt(privateKey, token).split("&");
            for(String param : decrypted) {
                map.put(param.split("=")[0], param.split("=")[1]);
            }
        } catch (GeneralSecurityException e) {
            LOGGER.error("Error decrypting token {},{},{}", kv("token", token));
        }

        return map;
    }

    public EmailMaster getEmailAddressDetails(String token) {
        Map<String, String> map = decryptToken(token);

        TokenDao tokenDao = new TokenDao();

        Long transactionId = Long.parseLong(map.get(EmailUrlService.TRANSACTION_ID));
        Long emailId = Long.parseLong(map.get(EmailUrlService.EMAIL_ID));
        String emailTokenType = map.get(EmailUrlService.EMAIL_TOKEN_TYPE);
        String emailTokenAction = map.get(EmailUrlService.EMAIL_TOKEN_ACTION);

        return tokenDao.getEmailDetails(transactionId, emailId, emailTokenType, emailTokenAction);
    }

    public IncomingEmail getIncomingEmailDetails(String token) {
        Map<String, String> map = decryptToken(token);

        TokenDao tokenDao = new TokenDao();

        Long transactionId = Long.parseLong(map.get(EmailUrlService.TRANSACTION_ID));
        Long emailId = Long.parseLong(map.get(EmailUrlService.EMAIL_ID));
        String emailTokenType = map.get(EmailUrlService.EMAIL_TOKEN_TYPE);
        String emailTokenAction = map.get(EmailUrlService.EMAIL_TOKEN_ACTION);

        EmailMaster emailMaster = tokenDao.getEmailDetails(transactionId, emailId, emailTokenType, emailTokenAction);

        IncomingEmail incomingEmail = null;
        if(emailMaster != null) {
            incomingEmail = new IncomingEmail();
            incomingEmail.setCampaignId(map.get(EmailUrlService.CAMPAIGN_ID));
            incomingEmail.setEmailAddress(EmailUrlService.decodeEmailAddress(emailMaster.getEmailAddress()));
            incomingEmail.setEmailHash(emailMaster.getHashedEmail());
            incomingEmail.setEmailType(EmailMode.findByCode(emailTokenType));
            incomingEmail.setProductId(map.get(EmailUrlService.PRODUCT_ID));
            incomingEmail.setTransactionId(transactionId);
        }
        return incomingEmail;
    }

    public boolean hasLogin(String token) {
        Map<String, String> map = decryptToken(token);

        TokenDao tokenDao = new TokenDao();

        Long transactionId = Long.parseLong(map.get(EmailUrlService.TRANSACTION_ID));
        Long emailId = Long.parseLong(map.get(EmailUrlService.EMAIL_ID));
        String emailTokenType = map.get(EmailUrlService.EMAIL_TOKEN_TYPE);
        String emailTokenAction = map.get(EmailUrlService.EMAIL_TOKEN_ACTION);

        return tokenDao.hasLogin(transactionId, emailId, emailTokenType, emailTokenAction);
    }
}
