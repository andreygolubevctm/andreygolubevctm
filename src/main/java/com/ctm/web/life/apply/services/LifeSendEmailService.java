package com.ctm.web.life.apply.services;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.EmailService;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.Optional;

@Component
public class LifeSendEmailService {

    private static final String OZICARE = "ozicare";
    private final TransactionDetailsDao transactionDetailsDao;
    private final EmailService emailService;

    @Deprecated // use only in jsp
    public LifeSendEmailService(){
        SqlDao sqlDao = new SqlDao();
        NamedParameterJdbcTemplate jdbcTemplate = new NamedParameterJdbcTemplate(SimpleDatabaseConnection.getDataSourceJdbcCtm());
        this.transactionDetailsDao = new TransactionDetailsDao( jdbcTemplate,  sqlDao);
        this.emailService = new EmailService();

    }

    @Autowired
    public LifeSendEmailService(TransactionDetailsDao transactionDetailsDao, EmailService emailService){
        this.transactionDetailsDao = transactionDetailsDao;
        this.emailService = emailService;

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
