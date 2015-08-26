package com.ctm.services.simples;

import com.ctm.dao.CommentDao;
import com.ctm.dao.TouchDao;
import com.ctm.dao.transaction.TransactionDao;
import com.ctm.dao.simples.MessageAuditDao;
import com.ctm.dao.simples.MessageDetailDao;
import com.ctm.dao.simples.MessageDuplicatesDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Transaction;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.model.simples.Message;
import com.ctm.model.simples.MessageDetail;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Collections;

public class MessageDetailService {

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(MessageDetailService.class.getName());



	public MessageDetail getMessageDetail(Message message) throws DaoException {
		MessageDetail messageDetail = new MessageDetail();

		MessageDuplicatesDao messageDuplicatesDao = new MessageDuplicatesDao();
		messageDuplicatesDao.setDupeTransactionIds(message);
		List<Long> transactionIds = message.getDupeTransactionIds();
		transactionIds.add(message.getTransactionId());

		Transaction transaction = new Transaction();
		TransactionDao transactionDao = new TransactionDao();
		transaction.setTransactionId(Collections.max(transactionIds));
		transactionDao.getCoreInformation(transaction);

		CommentDao comments = new CommentDao();
		messageDetail.setComments(comments.getCommentsForTransactionId(message.getTransactionId()));

		TouchDao touches = new TouchDao();
		messageDetail.setTouches(touches.getTouchesForRootIds(transactionIds));

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
