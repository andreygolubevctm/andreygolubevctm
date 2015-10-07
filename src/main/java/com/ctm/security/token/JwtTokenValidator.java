package com.ctm.security.token;

import com.ctm.model.Touch;
import com.ctm.model.request.TokenRequest;
import com.ctm.security.token.exception.InvalidTokenException;
import io.jsonwebtoken.*;

import java.util.List;

import static com.ctm.security.token.config.TokenCreatorConfig.SIGNATURE_ALGORITHM;
import static com.ctm.security.token.config.TokenCreatorConfig.TRANSACTION_ID_CLAIM;


public class JwtTokenValidator {

    private final String secretKey;

    public JwtTokenValidator(String secretKey){
        this.secretKey = secretKey;
    }

    public void validateToken(TokenRequest request , List<Touch.TouchType> validTouches) throws InvalidTokenException {
        if(request.getToken() == null){
            throw new InvalidTokenException("Token cannot be null");
        }
        try {
            Jws<Claims> decodedPayload = Jwts.parser().setSigningKey(secretKey).parseClaimsJws(request.getToken());
            if(!decodedPayload.getHeader().getAlgorithm().equals(SIGNATURE_ALGORITHM.getValue())){
                throw new  InvalidTokenException("invalid algorithm");
            }
            validateMatchesTransactionId(request.getTransactionId(), decodedPayload.getBody());
            validateTouch(validTouches, decodedPayload.getBody());
        } catch (ClaimJwtException | MalformedJwtException e) {
            throw new InvalidTokenException(e);
        }
    }

    private void validateTouch(List<Touch.TouchType> validTouches, Claims decodedPayload) throws InvalidTokenException {
        Touch.TouchType touch = Touch.TouchType.findByCode((String) decodedPayload.get("touch"));
        if(!validTouches.contains(touch)) {
            throw new InvalidTokenException("Touch doesn't match received " + touch + " expected one of " + validTouches);
        }
    }

    private void validateMatchesTransactionId(Long expectedTransactionId, Claims decodedPayload) throws InvalidTokenException {
        Long transactionId = getTransactionId(decodedPayload);
        if(!expectedTransactionId.equals(transactionId)) {
            throw new InvalidTokenException("transaction id doesn't match received " + transactionId + " expected " + expectedTransactionId);
        }
    }

    private Long getTransactionId(Claims decodedPayload) {
        Long transactionId = null;
        Object transactionIdObj= decodedPayload.get(TRANSACTION_ID_CLAIM);
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
