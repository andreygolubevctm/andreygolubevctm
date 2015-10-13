package com.ctm.security.token;

import com.ctm.model.Touch;
import com.ctm.model.request.TokenRequest;
import com.ctm.security.token.config.TokenCreatorConfig;
import com.ctm.security.token.exception.InvalidTokenException;
import io.jsonwebtoken.*;
import org.springframework.util.NumberUtils;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
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
            Jws<Claims> decodedPayload = Jwts.parser().setSigningKey(secretKey.getBytes()).parseClaimsJws(request.getToken());
            if(!decodedPayload.getHeader().getAlgorithm().equals(SIGNATURE_ALGORITHM.getValue())){
                throw new  InvalidTokenException("invalid algorithm");
            }
            Claims claims = decodedPayload.getBody();
            validateMatchesTransactionId(request.getTransactionId(), claims);
            validateTouch(validTouches, claims);
            validateSecondsUntilNextToken(claims);
        } catch (ClaimJwtException | MalformedJwtException e) {
            throw new InvalidTokenException(e);
        }
    }

    private void validateSecondsUntilNextToken(Claims body) throws InvalidTokenException {
        Date issuedAt = body.getIssuedAt();
        Object secondsUntilNextClaim = body.get(TokenCreatorConfig.SECONDS_UNTIL_NEXT_CLAIM);
        if(secondsUntilNextClaim instanceof String){
            String secondsUntilNext = ((String) secondsUntilNextClaim) ;
            if(secondsUntilNext != null && !secondsUntilNext.isEmpty()){
                Long seconds = NumberUtils.parseNumber(secondsUntilNext, Long.class);
                Date notBefore = Date.from(LocalDateTime.now().minusSeconds(seconds).atZone(ZoneId.systemDefault()).toInstant());
                if(issuedAt.after(notBefore)){
                    throw new InvalidTokenException("Token age is not valid must be at least " + seconds + "s old. ");
                }
            }
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
