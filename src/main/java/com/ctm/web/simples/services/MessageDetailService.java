package com.ctm.web.simples.services;

import com.ctm.web.core.dao.CommentDao;
import com.ctm.web.core.dao.TouchDao;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.simples.dao.MessageAuditDao;
import com.ctm.web.simples.dao.MessageDetailDao;
import com.ctm.web.simples.dao.MessageDuplicatesDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.transaction.model.Transaction;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.simples.model.Message;
import com.ctm.web.simples.model.MessageDetail;

import java.util.List;
import java.util.Collections;

public class MessageDetailService {

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
