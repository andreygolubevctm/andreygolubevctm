package com.ctm.security;

import com.ctm.model.Touch;
import com.ctm.model.settings.Vertical;
import com.ctm.security.model.TransactionVerifierConfig;
import io.jsonwebtoken.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import static com.ctm.logging.LoggingArguments.kv;
import static com.ctm.security.model.TransactionVerifierConfig.SIGNATURE_ALGORITHM;
import static com.ctm.security.model.TransactionVerifierConfig.TRANSACTION_ID_CLAIM;

public class JwtTokenCreator {

    private static final Logger LOGGER = LoggerFactory.getLogger(JwtTokenCreator.class);

    private final TransactionVerifierConfig transactionVerifierConfig;
    private final String secretKey;

    public JwtTokenCreator(Vertical vertical, Touch.TouchType touchType, HttpServletRequest request) {
        this.secretKey = TransactionVerifierConfig.getJwtSecretKey(vertical);
        this.transactionVerifierConfig =  new TransactionVerifierConfig(vertical, touchType, request);
    }

    public String createToken(String source , Long transactionId, long expiresSec) {
        Date notBefore = Date.from(LocalDateTime.now().plusSeconds(transactionVerifierConfig.getSecondsUntilNextToken()).atZone(ZoneId.systemDefault()).toInstant());
        return createToken(source, transactionId, notBefore, expiresSec, transactionVerifierConfig.getTouchType().getCode());
    }

    private String createToken(String source , Object transactionId , Date notBefore, long expiresSec , Object touchType) {
        JwtBuilder builder = createBuilder(source, transactionId, touchType);
        Date notAfter = Date.from(LocalDateTime.now().plusSeconds(expiresSec).atZone(ZoneId.systemDefault()).toInstant());
        builder =builder.setNotBefore(notBefore).setExpiration(notAfter);
        return builder.signWith(SIGNATURE_ALGORITHM, secretKey).compact();
    }

    public String createToken(String source , Long transactionId , Touch.TouchType touchType) {
        return createBuilder(source, transactionId, touchType.getCode()).signWith(SIGNATURE_ALGORITHM, secretKey).compact();
    }

    private JwtBuilder createBuilder(String source, Object transactionId, Object touchType) {
        Map<String,Object> claims = new HashMap<>();
        claims.put(TRANSACTION_ID_CLAIM, transactionId);
        claims.put("touch", touchType);
        return Jwts.builder().setClaims(claims).setSubject(source);
    }

    public String refreshToken(String token, long timeoutSeconds) {
        String newToken = null;
        try {
            Claims decodedPayload = Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token).getBody();
            newToken =  createToken((String) decodedPayload.get("source") ,  decodedPayload.get(TRANSACTION_ID_CLAIM) , decodedPayload.getNotBefore() , timeoutSeconds, decodedPayload.get("touch"));
        } catch (ClaimJwtException  e) {
            LOGGER.error("Failed to update token. {}", kv("originalToken", token), e);
        }
        return newToken;
    }

}