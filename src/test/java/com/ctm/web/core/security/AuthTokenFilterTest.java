package com.ctm.web.core.security;


import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.mock.web.MockFilterChain;
import org.springframework.mock.web.MockFilterConfig;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;
import java.security.Key;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.util.Date;

import static com.ctm.web.core.security.AuthTokenFilter.AUTH_HEADER_KEY;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = {AuthTokenFilterTest.class,AuthTokenFilter.class,JwksStore.class})
@TestPropertySource("classpath:application-INTG.properties")
public class AuthTokenFilterTest {

    static final String BEARER_FORMAT = "Bearer %1$s";

    //anonymous V2 tokens. Generated using key: jwks/test_anon_v2_private_key.cert
    private static final String VALID_ANON_V2_TOKEN = "eyJhbGciOiJSUzI1NiIsImtpZCI6IkFOT05fVjIiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJqb3VybmV5IiwiZXhwIjoyMDU2NzU3NzA4LCJodHRwOi8vY29tcGFyZXRoZW1hcmtldC5jb20uYXUvc2Vzc2lvbklkIjoiNGFmNmYxNzEtN2I2ZC00YzJkLTg5YjgtMGEzYTc0ZmVmNmI3IiwiaWF0IjoxNTU2NDk4NTA4LCJpc3MiOiJjdG0iLCJzY29wZSI6IkpPVVJORVkifQ.E7h5979fwv_ovqyG1XuYrH__3-JXgMXHyU8ca37GYWbb0XIr59OJP-Tqwmp16_6RJ7M9RSGD0k9eb1lKAXCWJOsxmFHoah3VuJ22Yyqlu8KkGEeLhGlGEAvuNT80g_-gx2u-ckXy5Wddz9YLwNWyXuAi1ZXPBu0oLQbg-iu33jp-SOCW-R2mS8dfEm3KmlNsdxucDWfHoliJOGH2U6rl25nCH5ckPVBxuQSKQQyK6EuOIfp7ds9HXu_tfSCTPd5R9druvNvFIDJwWYIMt6LHKOy_3w7vJDOuApVF3-poWBWBeaZQa1oP6jjykvdEknos0Q3kXYKtjB9o6xFqLpUz3g";
    private static final String EXPIRED_ANON_V2_TOKEN = "eyJhbGciOiJSUzI1NiIsImtpZCI6IkFOT05fVjIiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJqb3VybmV5IiwiZXhwIjoxMDU2NzU3NzA4LCJodHRwOi8vY29tcGFyZXRoZW1hcmtldC5jb20uYXUvc2Vzc2lvbklkIjoiNGFmNmYxNzEtN2I2ZC00YzJkLTg5YjgtMGEzYTc0ZmVmNmI3IiwiaWF0IjoxNTU2NDk4NTA4LCJpc3MiOiJjdG0iLCJzY29wZSI6IkpPVVJORVkifQ.ECx-yBnwR_ReO_4sVzO8aJRlNpC0bpxwzAIrgaCGKSEsaqxZq9KwVjq_gO_do0HmCZa2TVxs5_s5cj5U03IAjZq16wyNa2ORtoCUW6c-W24JF-3pZoXfSdr75mPN5xFOczf11mTPEwUN0bJtlPc06I1mhhhs_EnRevlxexzLNvYj1ywfbFsW99k83-i5ANzzrLsRVCuQIz96xDSoNUglKnRVNWWEJlLUpLAZQoegZ3V3Sb7yDhtMHv2s1bOQnP9UHyY_KwAVG_DXXT8g-oojbxKGHiTv3qGbyHM5FEXGjW4RK1Ef6nGYGfA4S1ofQF1I5KFKZmLCellirHXmyTWqoA";

    //Logged In tokens
    //Note, for security reasons, the key used to generate these tokens, is not the actual one used in prod/dev.
    //The rest of the token is an exact match (header, claims etc.)
    //Generated using key: jwks/test_logged_in_private_key.cert
    private static final String EXPIRED_LOGGED_IN_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik5VVkdNek13UXpFNU9VUkVRVFl5TjBNMU1rRkROelExTmtNNE9URTBOVUl4TkRBeU5UTXlNZyJ9.eyJyZXF1ZXN0LnBhcmFtLmFjY291bnRfaWQiOlsiNjk1MzIiXSwiYXVkIjpbImpvdXJuZXkiXSwidXNlcl9uYW1lIjoiYW5vbnltb3VzIiwic2NvcGUiOlsiSk9VUk5FWSJdLCJleHAiOjE1MzU2MDcyMjksImF1dGhvcml0aWVzIjpbIkFOT05ZTU9VUyJdLCJqdGkiOiJiZDcxZDQ2YS04Mzc1LTQ3NTUtYTI0OS00ZjQ2YWRhMmNhNTgiLCJjbGllbnRfaWQiOiJkZWZhdWx0IiwicmVxdWVzdC5wYXJhbS5pZF9wcm92aWRlciI6IkNUTSJ9.dfkhGCdRDgREvTzz6kraU0aUzJWG_RUxNPcm38FLlvfz2WogEvF-_gxnVFeEnLJ38E2tiU9EUzwmNjLP_s83gBPaxNoL953ySMhf27gMbG8ikj2EJ29aTCjEFuOWqUZpfhb5JzLIRvxpB_UWuY8kHEmsHnQ9kYb2phlIlcsAUI1A9bJhC4KdSfldVNF2ltLVLasrKfisntWudlG-oMOxnSGluva3lMIyQviYSz83EAdwk46K-UmsfiWhZhhZBX5zgIv7f9IxsqVtrwX9pq9Y8QRUbJWBPniFUEYZGk-Kvz5p_25QSl_Aj2NEJnPIuD5StoBzTl1drYThekNfYPB7fQ";
    private static final String VALID_LOGGED_IN_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik5VVkdNek13UXpFNU9VUkVRVFl5TjBNMU1rRkROelExTmtNNE9URTBOVUl4TkRBeU5UTXlNZyJ9.eyJpc3MiOiJodHRwczovL2N0bWRldi5hdS5hdXRoMC5jb20vIiwic3ViIjoiYXV0aDB8MzIxLTMyMSIsImh0dHA6Ly9jb21wYXJldGhlbWFya2V0LmNvbS5hdS9zZXNzaW9uSWQiOiIxMjMtMTIzIiwiYXVkIjpbImpvdXJuZXkiXSwiaWF0IjoxNTM1OTMxMjAyLCJleHAiOjMzMDkyNTE2MDI5LCJhenAiOiJmV1IzZHkzM0hOVTRQMVVWdXRzZ1RMYmduQ0hKbm9nSyIsInNjb3BlIjoicHJvZmlsZSByZWFkOmN1cnJlbnRfdXNlciB1cGRhdGU6Y3VycmVudF91c2VyX21ldGFkYXRhIGRlbGV0ZTpjdXJyZW50X3VzZXJfbWV0YWRhdGEgY3JlYXRlOmN1cnJlbnRfdXNlcl9tZXRhZGF0YSBjcmVhdGU6Y3VycmVudF91c2VyX2RldmljZV9jcmVkZW50aWFscyBkZWxldGU6Y3VycmVudF91c2VyX2RldmljZV9jcmVkZW50aWFscyB1cGRhdGU6Y3VycmVudF91c2VyX2lkZW50aXRpZXMgSk9VUk5FWSIsImd0eSI6InBhc3N3b3JkIn0.RXOA8uo0qpsEnwk7uFRd1FJrKrTxat2Xqd0sCF0Q37nmR9n9FFwctxReqKqpFcBleydkoLMtN-MOzQ9sbF8fqy8u--a5xnVNeVY460-zLFw-2jhIMB6dcWCyqZrOAKHRDLaSaQFIGzp5KS9YtfI8z84Ol4E-sNKmVltpq-4Vm18QjmMoBuGuA_e9jdSkPkpD0-cq6REevWE8_fMl88YVZHsfsQgXPP_KCNWD5W5DbvfQls9eVLLviOpgiDr0FbG8RgaYbKBhRdK_NW6VJc4okwVrk-f2PlogOx1hm3MCZIEj0pyrnIakwhq7I82oGPxtAfMwXD4rcwqvHnX6fP_roA";

    //this bean is required to convert the properties into the right formats for the @Value fields
    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }

    AuthTokenFilter authTokenFilter;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    ServletContext srvletCtx;

    @Mock
    FilterConfig filterConfig;

    @Captor
    private ArgumentCaptor<Integer> statusCodeCaptor;

    @Captor
    private ArgumentCaptor<String> attributeCaptor;

    @Mock
    WebApplicationContextUtils ebApplicationContextUtils;

    @Autowired
    public WebApplicationContext context;



    @Autowired
    JwksStore jwksStore;

    private MockMvc mockMvc;

    @Mock
    private FilterChain filterChain;

    private static KeyPair unverifiedKeyPair = null;
    private static SignatureAlgorithm unverifiedAlgo  = SignatureAlgorithm.RS256;


    @Before
    public void setUp() throws ServletException{
        MockitoAnnotations.initMocks(this);
        authTokenFilter = new AuthTokenFilter();
        mockMvc = MockMvcBuilders.webAppContextSetup(context).addFilter(authTokenFilter,"/*").build();
        Mockito.when(filterConfig.getServletContext()).thenReturn(context.getServletContext());
        authTokenFilter.init(filterConfig);
    }

    @Test
    public void givenNoAuthorizationHeader_thenIgnoreAuth() throws ServletException, IOException {
        Mockito.when(request.getHeader(AUTH_HEADER_KEY)).thenReturn(null);

        authTokenFilter.doFilter(request, response, filterChain);

        // the response should pass through the filter untouched. I.e. the status code should not be set.
        verify(response, times(0)).setStatus(0);
        assertEquals(0, response.getStatus());
    }


    @Test
    public void givenJWT_whenSignedWithUnknownKey_thenUnauthorized() throws Exception {
        String authHeader = String.format(BEARER_FORMAT, createToken(getUnverifiedKeyPair().getPrivate()));
        Mockito.when(request.getHeader(AUTH_HEADER_KEY)).thenReturn(authHeader);


        authTokenFilter.doFilter(request, response, filterChain);

        verify(response, times(1)).setStatus(statusCodeCaptor.capture());
        Integer statusCode = statusCodeCaptor.getValue();
        assertEquals(Integer.valueOf(HttpServletResponse.SC_UNAUTHORIZED), statusCode);
    }


    @Test
    public void givenValidAuth0Token_thenExtractUserIdAndSessionIdAndContinue() throws Exception {
        String authHeader = String.format(BEARER_FORMAT, VALID_LOGGED_IN_TOKEN);
        Mockito.when(request.getHeader(AUTH_HEADER_KEY)).thenReturn(authHeader);

        authTokenFilter.doFilter(request, response, filterChain);

        verify(request, times(1)).setAttribute(AuthorisationConstants.TOKEN_REQUEST_PARAM_ANONYMOUS_ID, "123-123");
        verify(request, times(1)).setAttribute(AuthorisationConstants.TOKEN_REQUEST_PARAM_USER_ID, "321-321");
    }

    @Test
    public void givenExpiredAuth0Token_thenUnauthorised() throws Exception {
        String authHeader = String.format(BEARER_FORMAT, EXPIRED_LOGGED_IN_TOKEN);
        Mockito.when(request.getHeader(AUTH_HEADER_KEY)).thenReturn(authHeader);

        authTokenFilter.doFilter(request, response, filterChain);

        verify(response, times(1)).setStatus(statusCodeCaptor.capture());
        Integer statusCode = statusCodeCaptor.getValue();
        assertEquals(Integer.valueOf(HttpServletResponse.SC_UNAUTHORIZED), statusCode);
    }


    @Test
    public void givenValidAnonymous0Token_thenExtractSessionIdAndContinue() throws Exception {
        String authHeader = String.format(BEARER_FORMAT, VALID_ANON_V2_TOKEN);
        Mockito.when(request.getHeader(AUTH_HEADER_KEY)).thenReturn(authHeader);

        authTokenFilter.doFilter(request, response, filterChain);

        verify(request, times(1)).setAttribute(AuthorisationConstants.TOKEN_REQUEST_PARAM_ANONYMOUS_ID, "4af6f171-7b6d-4c2d-89b8-0a3a74fef6b7");
    }

    @Test
    public void givenExpiredAnonymousToken_thenUnauthorised() throws Exception {
        String authHeader = String.format(BEARER_FORMAT, EXPIRED_ANON_V2_TOKEN);
        Mockito.when(request.getHeader(AUTH_HEADER_KEY)).thenReturn(authHeader);

        authTokenFilter.doFilter(request, response, filterChain);

        verify(response, times(1)).setStatus(statusCodeCaptor.capture());
        Integer statusCode = statusCodeCaptor.getValue();
        assertEquals(Integer.valueOf(HttpServletResponse.SC_UNAUTHORIZED), statusCode);
    }


    private KeyPair getUnverifiedKeyPair()  {
        try {
            if (unverifiedKeyPair==null) {
                KeyPairGenerator kpg = KeyPairGenerator.getInstance(unverifiedAlgo.getFamilyName());
                kpg.initialize(2048);
                unverifiedKeyPair=kpg.generateKeyPair();
            }

            return unverifiedKeyPair;
        } catch (NoSuchAlgorithmException e) {
            fail("You messed up your test setup - Pass the correct value to 'KeyPairGenerator.getInstance'");
        }
        return unverifiedKeyPair;
    }

    private static String createToken(Key signingKey) {
        return Jwts.builder().setId("123")
                .setIssuedAt(new Date())
                .setSubject("123-123-123")
                .setIssuer("CTM")
                .signWith(SignatureAlgorithm.RS256, signingKey)
                .compact();

    }


    /**
     * Utility class to encapsulate test data.
     */
    private static class TokenTestSupport {
        static final String AUTH_PUB_KEY_PATH = "src/test/resources/com/ctm/web/core/security/auth-public-key.pem";
        static final String AUTH_PRIV_KEY_PATH = "src/test/resources/com/ctm/web/core/security/auth-private-key.pem";

        static final String ANON_PUB_KEY_PATH = "src/test/resources/com/ctm/web/core/security/anon-public.pem";
        static final String ANON_PRIV_KEY_PATH = "src/test/resources/com/ctm/web/core/security/anon-private.pem";

        static final String UNVERIFIED_SIGNING_KEY_PATH = "src/test/resources/com/ctm/web/core/security/unverified-signing-key.pem";






    }
}
