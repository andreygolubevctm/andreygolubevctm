package com.ctm.security.token;

import com.ctm.exceptions.DaoException;
import com.ctm.security.token.config.TokenConfigFactory;
import com.ctm.security.token.config.TokenCreatorConfig;
import com.ctm.services.SettingsService;
import io.jsonwebtoken.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import static com.ctm.logging.LoggingArguments.kv;
import static com.ctm.security.token.config.TokenCreatorConfig.SIGNATURE_ALGORITHM;
import static com.ctm.security.token.config.TokenCreatorConfig.TRANSACTION_ID_CLAIM;
import static com.ctm.security.token.config.TokenCreatorConfig.TOUCH_CLAIM;

public class JwtTokenCreator {

    private static final Logger LOGGER = LoggerFactory.getLogger(JwtTokenCreator.class);

    private final TokenCreatorConfig config;
    private SettingsService settingsService;

    public JwtTokenCreator(SettingsService settingsService , TokenCreatorConfig config) {
        this.config = config;
        this.settingsService = settingsService;
    }

    public String createToken(String source , Long transactionId, long expiresSec) {
        Date notBefore = Date.from(LocalDateTime.now().plusSeconds(config.getSecondsUntilNextToken()).atZone(ZoneId.systemDefault()).toInstant());
        return createToken(source, transactionId, notBefore, expiresSec, config.getTouchType().getCode());
    }

    private String createToken(String source, Object transactionId, Date notBefore, long expiresSec, Object touchType) {
        JwtBuilder builder = createBuilder(source, transactionId, touchType);
        Date notAfter = Date.from(LocalDateTime.now().plusSeconds(expiresSec).atZone(ZoneId.systemDefault()).toInstant());
        builder =builder.setNotBefore(notBefore).setExpiration(notAfter);
        builder.setHeaderParam("kid", config.getVertical());
        return builder.signWith(SIGNATURE_ALGORITHM, getSigningKey(config.getVertical())).compact();
    }


    private JwtBuilder createBuilder(String source, Object transactionId, Object touchType) {
        Map<String,Object> claims = new HashMap<>();
        claims.put(TRANSACTION_ID_CLAIM, transactionId);
        claims.put(TOUCH_CLAIM, touchType);
        return Jwts.builder().setClaims(claims).setSubject(source);
    }

    public String refreshToken(String token, long timeoutSeconds) {
        String tokenToReturn = token;
        Jws<Claims> decodedPayloadFull = null;
        try {
            JwtParser parser = Jwts.parser();
            decodedPayloadFull = parser.setSigningKeyResolver(new SigningKeyResolverAdapter() {
                @Override
                public byte[] resolveSigningKeyBytes(JwsHeader header, Claims claims) {
                    //inspect the header or claims, lookup and return the signing key
                    String keyId = header.getKeyId();
                    return getSigningKey(keyId);
                }}).parseClaimsJws(token);

        } catch (PrematureJwtException e) {
            // ignore as this is most likely to do with session poke calling before token is valid
        } catch (ClaimJwtException  e) {
            LOGGER.warn("Failed to update token. {},{}", kv("originalToken", token), kv("timeoutSeconds", timeoutSeconds), e);
        }
        if(decodedPayloadFull != null) {
            Claims decodedPayload = decodedPayloadFull.getBody();
            tokenToReturn = createToken((String) decodedPayload.get("source"), decodedPayload.get(TRANSACTION_ID_CLAIM), decodedPayload.getNotBefore(), timeoutSeconds, decodedPayload.get(TOUCH_CLAIM));
        }
        return tokenToReturn;
    }


    private byte[] getSigningKey(String keyId) {
        try {
            config.setVertical(keyId);
            return TokenConfigFactory.getJwtSecretKey(settingsService.getVertical(keyId)).getBytes();
        } catch (DaoException e) {
            throw new RuntimeException(e);
        }
    }

}