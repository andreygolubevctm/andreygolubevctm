package com.ctm.web.email;

import com.ctm.httpclient.Client;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by akhurana on 15/09/17.
 */
@Service
public class MarketingEmailService {

    @Autowired
    private Client<EmailRequest,EmailResponse> emailClient;

    public void send(EmailRequest emailRequest){

    }
}
