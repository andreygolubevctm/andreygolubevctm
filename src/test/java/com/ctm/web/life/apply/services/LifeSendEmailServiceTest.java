package com.ctm.web.life.apply.services;

import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.EmailService;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;

import java.util.Optional;

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyZeroInteractions;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class LifeSendEmailServiceTest {

    LifeSendEmailService lifeSendEmailService;

    @Mock
    private TransactionDetailsDao transactionDetailsDao;
    @Mock
    private EmailService emailService;
    @Mock
    private HttpServletRequest request;

    private long transactionId = 1000L;
    private String emailAddress = "Sergie39@grubmail.com";

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        lifeSendEmailService = new LifeSendEmailService(transactionDetailsDao,  emailService);
    }

    @Test
    public void shouldNotSendEmailIfAlreadySent() throws Exception {
        TransactionDetail existingDetails = new TransactionDetail();
        existingDetails.setTextValue("ozicare");
        when(transactionDetailsDao.getTransactionDetailWhereXpathLike(transactionId, "%/emailSentBy")).thenReturn(Optional.of(existingDetails));
        lifeSendEmailService.sendEmail( transactionId,  emailAddress,  request);
        verifyZeroInteractions(emailService);

    }

    @Test
    public void shouldSendEmailIfSendButNotToOzicare() throws Exception {
        TransactionDetail existingDetails = new TransactionDetail();
        existingDetails.setTextValue("lifebroker");
        when(transactionDetailsDao.getTransactionDetailWhereXpathLike(transactionId, "%/emailSentBy")).thenReturn(Optional.of(existingDetails));
        lifeSendEmailService.sendEmail( transactionId,  emailAddress,  request);
        verify(emailService).send( request, EmailMode.BEST_PRICE,
                emailAddress,  transactionId);

    }

    @Test
    public void shouldSendEmailIfNotAlreadySent() throws Exception {
        when(transactionDetailsDao.getTransactionDetailWhereXpathLike(transactionId, "%/emailSentBy")).thenReturn(Optional.empty());
        lifeSendEmailService.sendEmail( transactionId,  emailAddress,  request);
        verify(emailService).send( request, EmailMode.BEST_PRICE,
                 emailAddress,  transactionId);

    }
}