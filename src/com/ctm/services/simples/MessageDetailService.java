package com.ctm.services.simples;

import com.ctm.dao.CommentDao;
import com.ctm.dao.TouchDao;
import com.ctm.dao.TransactionDao;
import com.ctm.dao.simples.MessageAuditDao;
import com.ctm.dao.simples.MessageDetailDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Transaction;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.model.simples.Message;
import com.ctm.model.simples.MessageAudit;
import com.ctm.model.simples.MessageDetail;
import org.apache.log4j.Logger;

import java.util.ArrayList;

public class MessageDetailService {

	@SuppressWarnings("unused")
	private static final Logger logger = Logger.getLogger(MessageDetailService.class.getName());



	public MessageDetail getMessageDetail(Message message) throws DaoException {
		MessageDetail messageDetail = new MessageDetail();

		Transaction transaction = new Transaction();
		TransactionDao transactionDao = new TransactionDao();
		transaction.setTransactionId(message.getTransactionId());
		transactionDao.getCoreInformation(transaction);

		CommentDao comments = new CommentDao();
		messageDetail.setComments(comments.getCommentsForTransactionId(message.getTransactionId()));

		TouchDao touches = new TouchDao();
		messageDetail.setTouches(touches.getTouchesForTransactionId(message.getTransactionId()));

		MessageAuditDao messageAuditDao = new MessageAuditDao();
		messageDetail.setAudits(messageAuditDao.getMessageAudits(message.getMessageId()));

		messageDetail.setMessage(message);
		messageDetail.setTransaction(transaction);

		if (VerticalType.HEALTH.getCode().equalsIgnoreCase(transaction.getVerticalCode())) {
			MessageDetailDao messageDetailDao = new MessageDetailDao();
			messageDetail.setVerticalProperties(messageDetailDao.getHealthProperties(transaction.getNewestTransactionId()));
		}

		return messageDetail;
	}
}
