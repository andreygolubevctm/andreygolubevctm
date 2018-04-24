package com.ctm.web.email;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by akhurana on 15/09/17.
 */
@RestController
@RequestMapping("/marketing-automation/")
public class EmailController {

    private static final Logger LOGGER = LoggerFactory.getLogger(EmailController.class);

    @Autowired
    private MarketingAutomationEmailService marketingAutomationEmailService;

    @RequestMapping("/sendEmail.json")
    public void sendEmail(HttpServletRequest request) {
        try {
            marketingAutomationEmailService.sendEmail(request);
        } catch (Exception e) {
            LOGGER.error(String.format("Unable to send email request for marketing automation service - Exception (%1$s): %2$s", e.getClass(), e.getMessage()));
        }
    }

}
