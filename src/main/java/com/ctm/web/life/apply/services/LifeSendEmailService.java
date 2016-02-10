package com.ctm.web.life.apply.services;

import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.EmailService;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.Optional;

@Component
public class LifeSendEmailService {

    private final TransactionDetailsDao transactionDetailsDao;
    private final EmailService emailService;

    @Deprecated // use only in jsp
    public LifeSendEmailService(){
        this.transactionDetailsDao = new TransactionDetailsDao();
        this.emailService = new EmailService();

    }

    public LifeSendEmailService(TransactionDetailsDao transactionDetailsDao, EmailService emailService){
        this.transactionDetailsDao = transactionDetailsDao;
        this.emailService = emailService;

    }

    public void sendEmail(long transactionId, String emailAddress, HttpServletRequest request) throws SendEmailException {
        Optional<TransactionDetail> sentBy = transactionDetailsDao.getTransactionDetailWhereXpathLike(transactionId, "%/emailSentBy");
        final boolean[] sendEmail = {true};
        sentBy.ifPresent(td -> {
            sendEmail[0] = !td.getTextValue().equals("ozicare");
        });
        if( sendEmail[0]) {
            emailService.send( request, EmailMode.BEST_PRICE,emailAddress, transactionId);
        }
    }
}
