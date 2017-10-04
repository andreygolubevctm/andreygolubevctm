package com.ctm.web.email;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import rx.schedulers.Schedulers;

/**
 * Created by akhurana on 25/09/17.
 */
@Component
public class EmailClient {
    @Autowired
    private Client<EmailRequest,EmailResponse> client;
    @Value("${marketing.automation.url}")
    private String url;
    @Value("${marketing.automation.timeout.millis}")
    private Long timeout;

    private static final Logger LOGGER = LoggerFactory.getLogger(EmailClient.class);

    public void send(EmailRequest emailRequest){
        LOGGER.info("Sending email request to marketing automation service" + url);
        EmailResponse emailResponse = client.post(RestSettings.<EmailRequest>builder().request(emailRequest).response(EmailResponse.class)
                .responseType(MediaType.APPLICATION_JSON).header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                .url(url)
                .timeout(timeout).retryAttempts(2).build()).observeOn(Schedulers.io()).toBlocking().first();
        LOGGER.info("Email response from marketing automation service" + emailResponse.getSuccess() + emailResponse.getMessage());
    }
}
