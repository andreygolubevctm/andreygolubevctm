package com.ctm.web.email.integration.emailservice;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.model.EmailMaster;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

import static com.ctm.web.email.integration.emailservice.EmailTokenType.APP;
import static java.lang.Integer.valueOf;
import static java.util.Arrays.asList;
import static java.util.Optional.empty;

/**
 * Email-service integration.
 * <p>
 * Created by lna on 19/12/17.
 */
@Service
public class EmailServiceClient {

    private static final String URI_NEW_TOKEN = "/token/new";

    @Autowired
    private Client<List<TokenRequest>, List<TokenResponse>> client;

    @Value("${emails-service.url}")
    private String baseUrl;

    @Value("${emails-service.timeout.millis}")
    private Long timeout;

    private static final Logger LOGGER = LoggerFactory.getLogger(EmailServiceClient.class);

    public Optional<TokenResponse> createEmailToken(final Integer styleCodeId,
                                                    final VerticalType verticalType,
                                                    final Long transactionId,
                                                    final EmailTokenAction emailTokenAction,
                                                    final EmailMaster emailMaster) {

        try {
            // prepare token request to communicate with email-service
            final TokenRequest request = TokenRequest.newBuilder()
                    .emailTokenType(APP)
                    .action(emailTokenAction)
                    .styleCodeId(styleCodeId)
                    .vertical(verticalType)
                    .source("Web_CTM")
                    .transactionId(transactionId)
                    .emailId(Optional.ofNullable(emailMaster.getEmailId()).map(eid -> valueOf(eid).longValue()).orElse(null))
                    .hashedEmail(emailMaster.getHashedEmail())
                    .emailAddress(emailMaster.getEmailAddress())
                    .build();

            // send request in a list
            final RestSettings<List<TokenRequest>> settings =
                    RestSettings.<List<TokenRequest>>builder()
                            .jsonHeaders()
                            .request(asList(request))
                            .response(new ParameterizedTypeReference<List<TokenResponse>>() {
                            })
                            .url(baseUrl + URI_NEW_TOKEN)
                            .timeout(timeout)
                            .retryAttempts(2)
                            .build();

            return client.post(settings).toBlocking().first().stream().findFirst();

        } catch (Exception ex) {
            LOGGER.error("Failed to create EVT email token. Reason: " + ex.getMessage(), ex);
            return empty();
        }

    }

}
