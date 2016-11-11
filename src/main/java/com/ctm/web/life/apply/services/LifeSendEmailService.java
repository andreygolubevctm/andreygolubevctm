package com.ctm.web.life.apply.services;

import com.ctm.commonlogging.common.LoggingArguments;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.EmailService;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.Optional;

@Component
public class LifeSendEmailService {

    private static final Logger LOGGER = LoggerFactory.getLogger(LifeSendEmailService.class);

    private static final String OZICARE = "ozicare";
    private TransactionDetailsDao transactionDetailsDao;
    private EmailService emailService;

    @Deprecated // use only in jsp
    @SuppressWarnings("unused")
    public LifeSendEmailService(){}

    @Autowired
    public LifeSendEmailService(TransactionDetailsDao transactionDetailsDao, EmailService emailService){
        this.transactionDetailsDao = transactionDetailsDao;
        this.emailService = emailService;
    }

    @Deprecated
    private void init(ServletContext sc) {
        final WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(sc);
        this.transactionDetailsDao = applicationContext.getBean(TransactionDetailsDao.class);
        this.emailService = applicationContext.getBean(EmailService.class);
    }

    @Deprecated
    public void sendEmailJsp(long transactionId, String emailAddress, HttpServletRequest request) {
        init(request.getServletContext());
        try {
            this.sendEmail(transactionId, emailAddress, request);
        } catch (SendEmailException e) {
            LOGGER.error("Exception generated attempting to send email. {}", LoggingArguments.kv("transactionId", transactionId), e);
        }
    }

    public void sendEmail(long transactionId, String emailAddress, HttpServletRequest request) throws SendEmailException {
        Optional<TransactionDetail> sentBy = transactionDetailsDao.getTransactionDetailWhereXpathLike(transactionId, "%/emailSentBy");
        final boolean[] sendEmail = {true};
        sentBy.ifPresent(td -> sendEmail[0] = !td.getTextValue().equals(OZICARE));
        if( sendEmail[0]) {
            emailService.send( request, EmailMode.BEST_PRICE,emailAddress, transactionId);
        }
    }
}
