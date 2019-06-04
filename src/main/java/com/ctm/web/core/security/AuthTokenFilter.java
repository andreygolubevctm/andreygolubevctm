package com.ctm.web.core.security;


import com.auth0.jwk.InvalidPublicKeyException;
import com.auth0.jwk.Jwk;
import com.auth0.jwk.JwkException;
import com.auth0.jwk.JwkProvider;
import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTDecodeException;
import com.auth0.jwt.exceptions.SignatureVerificationException;
import com.auth0.jwt.exceptions.TokenExpiredException;
import com.auth0.jwt.interfaces.Claim;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.JWTVerifier;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.interfaces.RSAPublicKey;
import java.util.Map;
import java.util.Optional;


// Currenlty set to filter all requests. This could be refined if/when necessary
@WebFilter(
        urlPatterns = {"/*"},
        asyncSupported = true
)
public class AuthTokenFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(AuthTokenFilter.class);
    private final JwtHeaderConverter jwtHeaderConverter = new JwtHeaderConverter();
    private static final Logger LOGGER = LoggerFactory.getLogger(AuthTokenFilter.class);

    public static final String DEFAULT_ALGORITHM = "RS256";
    public static final String AUTH_HEADER_KEY = "Authorization";
    public static final String AUTH_HEADER_VALUE_PREFIX = "Bearer "; // with trailing space to separate token
    public static final String ANON_V1_KID_HEADER = "ANON_V1";
    public static final String ANONYMOUS_ID_CLAIM = "http://comparethemarket.com.au/sessionId";// as enforced by Auth0
    private static final String USER_ID_SUBJECT_CLAIM = "sub";
    private static final String VERIFICATION_ERROR_STRING = "Provided JWT could not be verified";

    private JwkProvider jwkProvider;

    private boolean isEnabled = false;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

        WebApplicationContext ctx = WebApplicationContextUtils
                .getRequiredWebApplicationContext(filterConfig.getServletContext());
        ctx.getBean(JwksStore.class);
        if (ctx!=null) {
            JwksStore jwksStore = ctx.getBean(JwksStore.class);
            if (jwksStore!=null && jwksStore.isFilterEnabled()) {
                jwkProvider=jwksStore.getJwkProvider();
                isEnabled=jwksStore.isFilterEnabled();
            }
        }
    }

    @Override
    public void doFilter(final ServletRequest servletRequest,
                         final ServletResponse servletResponse,
                         final FilterChain filterChain) throws IOException, ServletException {


        if (isEnabled) {
            HttpServletRequest httpRequest = (HttpServletRequest)servletRequest;
        HttpServletResponse httpResponse = (HttpServletResponse)servletResponse;
                //If there is an Auth Header present, it has to conform to CTM's tokens, otherwise just ignore it
                 getBearerToken((httpRequest))
                    .ifPresent(stringToken->{
                     String kid=getKid(stringToken);
                     try {
                         Jwk jwk = jwkProvider.get(kid);
                         Algorithm algo = getAlgorithm(jwk);
                         if (algo==null) {
                             unauthorized(httpResponse,new RuntimeException("Provided JWT was signed with an unsupported algorithm"));
                         }

                         JWTVerifier verifier = JWT.require(algo).build();
                         DecodedJWT decodedJWT = verifier.verify(stringToken);
                         Map<String,Claim> claims = decodedJWT.getClaims();

                         //Add anonymousId to HTTP Request if present
                         Optional.ofNullable(claims.get(ANONYMOUS_ID_CLAIM))
                                 .ifPresent(sessionId->httpRequest.setAttribute(
                                         AuthorisationConstants.TOKEN_REQUEST_PARAM_ANONYMOUS_ID,sessionId.asString()));
                         //Add userId to HTTP Request if present, and in the expected format
                         Optional.ofNullable(claims.get(USER_ID_SUBJECT_CLAIM))
                                 .ifPresent(uid->{
                                     if (uid.asString().contains("|")) {
                                         String rawUserId = uid.asString();
                                         String userId = StringUtils.substring(rawUserId,rawUserId.indexOf("|")+1,rawUserId.length());
                                         httpRequest.setAttribute(AuthorisationConstants.TOKEN_REQUEST_PARAM_USER_ID, userId);
                                     }
                                 });

                     } catch (JwkException e) {
                        LOGGER.error("Auth header was present, but token signature does not match any of CTM's keys",e);
                        unauthorized(httpResponse,new RuntimeException(VERIFICATION_ERROR_STRING));
                     } catch (SignatureVerificationException e) {
                         LOGGER.error("Token signature verification failure",e);
                         unauthorized(httpResponse,new RuntimeException(VERIFICATION_ERROR_STRING));
                     }
                      catch (JWTDecodeException e) {
                          LOGGER.error("Error decoding provided token",e);
                          unauthorized(httpResponse,new RuntimeException(VERIFICATION_ERROR_STRING));
                     }
                     catch (TokenExpiredException e) {
                         LOGGER.error("The provided token has expired",e);
                         unauthorized(httpResponse,new RuntimeException("The provided token has expired"));
                     }
        });

    }
        filterChain.doFilter(servletRequest, servletResponse);
    }

    private String getKid(String stringToken) {
        Map<String,String> headers = jwtHeaderConverter.convert(stringToken);
        String kid = headers.get("kid");
        // If no kid header is present, we assume it is an ANON_V1 token and default the header to its appropriate
        // value.
        if (kid==null) {
            kid=ANON_V1_KID_HEADER;
        }
        return kid;
    }

    // Currently all CTM's Auth tokens are RSA tokens. This method can be extended in the future to include more signing algorithms.
    private Algorithm getAlgorithm(Jwk jwk) {
        // If no algorithm has been supplied, we assume that it is RS256.
        String algorithmVal=Optional.ofNullable(jwk.getAlgorithm()).orElse(DEFAULT_ALGORITHM);
        Algorithm algorithm = null;
        try {
            if ("RS256".equals(algorithmVal)) {
                algorithm = Algorithm.RSA256((RSAPublicKey)jwk.getPublicKey(), null);
            } else if ("RS512".equals(algorithmVal)) {
                algorithm = Algorithm.RSA512((RSAPublicKey)jwk.getPublicKey(), null);
            }
        } catch (InvalidPublicKeyException e) {
            LOGGER.error(String.format("Incorrect public key. Provided public key is not of type: %s",jwk.getAlgorithm()),e);
        }
        return algorithm;
    }

    private void unauthorized(HttpServletResponse httpResponse, Exception e) {
        LOGGER.info("Failed to verify Authorization token: {}", e.getMessage());
        httpResponse.setContentLength(0);
        httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
    }

    @Override
    public void destroy() {
        LOGGER.info("JWTTokenValidationFilter  destroyed");
    }

    /**
     * Get the bearer token from the HTTP request.
     * The token is in the HTTP request "Authorization" header in the form of: "Bearer [token]"
     */
    private static Optional<String> getBearerToken(HttpServletRequest request) {
        return Optional.ofNullable(request.getHeader(AUTH_HEADER_KEY))
                .filter(authHeader -> authHeader.startsWith(AUTH_HEADER_VALUE_PREFIX))
                .map(authHeader -> authHeader.substring(AUTH_HEADER_VALUE_PREFIX.length()));
    }
}
