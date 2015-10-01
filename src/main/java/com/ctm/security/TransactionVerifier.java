package com.ctm.security;

import com.ctm.model.Touch;
import com.ctm.model.request.TokenRequest;
import io.jsonwebtoken.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.ctm.logging.LoggingArguments.kv;

public class TransactionVerifier {

    private static final Logger LOGGER = LoggerFactory.getLogger(TransactionVerifier.class);

    /**
     * TODO: There are a number of secret keys in the database we should handle this better
     */
    private static final String SECRET_KEY = "hqZjD9B4pONP1GNJw4NM_gxItwsPm4aGjKIc83wS";

    public String createToken(String source , Long transactionId , Touch.TouchType touchType, int secondsUntilToken, long expiresSec) {
        JwtBuilder builder = createBuilder(source, transactionId, touchType);
        Date notBefore = Date.from(LocalDateTime.now().plusSeconds(secondsUntilToken).atZone(ZoneId.systemDefault()).toInstant());
        Date notAfter = Date.from(LocalDateTime.now().plusSeconds(expiresSec).atZone(ZoneId.systemDefault()).toInstant());
        builder =builder.setNotBefore(notBefore).setExpiration(notAfter);
        return builder.signWith(SignatureAlgorithm.HS512, SECRET_KEY).compact();
    }

    public String createToken(String source , Long transactionId , Touch.TouchType touchType, int secondsUntilToken) {
        return  createToken(source, transactionId, touchType, secondsUntilToken, 3300);
    }

    public String createToken(String source , Long transactionId , Touch.TouchType touchType) {
        return createBuilder(source, transactionId, touchType).signWith(SignatureAlgorithm.HS512, SECRET_KEY).compact();
    }

    private JwtBuilder createBuilder(String source, Long transactionId, Touch.TouchType touchType) {
        Map<String,Object> claims = new HashMap<>();
        claims.put("transactionId", transactionId);
        claims.put("touch", touchType.getCode());
        return Jwts.builder().setClaims(claims).setSubject(source);
    }

    public void validateToken(TokenRequest request , List<Touch.TouchType> validTouches) throws InvalidTokenException {
        if(request.getToken() == null){
            throw new InvalidTokenException("Token cannot be null");
        }
        try {
            Jws<Claims> decodedPayload = Jwts.parser().setSigningKey(SECRET_KEY).parseClaimsJws(request.getToken());
            if(!decodedPayload.getHeader().getAlgorithm().equals(SignatureAlgorithm.HS512.getValue())){
                throw new  InvalidTokenException("invalid algorithm");
            }
            validateMatchesTransactionId(request.getTransactionId(), decodedPayload.getBody());
            validateTouch(validTouches, decodedPayload.getBody());
        } catch (ClaimJwtException e) {
            throw new InvalidTokenException(e);
        }
    }

    public String refreshToken(String token, long timeoutSeconds) {
        String newToken = null;
        try {
            Claims decodedPayload = Jwts.parser().setSigningKey(SECRET_KEY).parseClaimsJws(token).getBody();
            Touch.TouchType touchType = Touch.TouchType.findByCode((String) decodedPayload.get("touch"));
            newToken =  createToken((String) decodedPayload.get("source") , getTransactionId(decodedPayload) , touchType, 0 , timeoutSeconds);
        } catch (ClaimJwtException  e) {
            LOGGER.error("Failed to update token. {}", kv("originalToken", token), e);
        }
        return newToken;
    }

    private void validateTouch(List<Touch.TouchType> validTouches, Claims decodedPayload) throws InvalidTokenException {
        Touch.TouchType touch = Touch.TouchType.findByCode((String) decodedPayload.get("touch"));
        if(!validTouches.contains(touch)) {
            throw new InvalidTokenException("Touch doesn't match recieved " + touch + " expected one of " + validTouches);
        }
    }

    private void validateMatchesTransactionId(Long expectedTransactionId, Claims decodedPayload) throws InvalidTokenException {
        Long transactionId = getTransactionId(decodedPayload);
        if(!expectedTransactionId.equals(transactionId)) {
            throw new InvalidTokenException("transaction id doesn't match recieved " + transactionId + " expected " + expectedTransactionId);
        }
    }

    private Long getTransactionId(Claims decodedPayload) {
        Long transactionId = null;
        Object transactionIdObj= decodedPayload.get("transactionId");
        if(transactionIdObj instanceof Integer){
            transactionId = Long.valueOf((Integer)transactionIdObj);
        } else if(transactionIdObj instanceof Long){
            transactionId = (Long)transactionIdObj;
        } else if(transactionIdObj instanceof String){
            transactionId = Long.parseLong((String)transactionIdObj);
        }
        return transactionId;
    }

}