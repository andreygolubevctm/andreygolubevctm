package com.ctm.web.core.email.services;

import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.dao.StampingDao;
import com.ctm.web.core.email.mapping.EmailDetailsMappings;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.web.go.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class EmailDetailsFactory {

	private final StampingDao stampingDao;
	private EmailMasterDao emailMasterDao;
	private final TransactionDao transactionDao;

	@Autowired
	public EmailDetailsFactory(EmailMasterDao emailMasterDao,
							   TransactionDao transactionDao,
							   StampingDao stampingDao) {
		this.emailMasterDao = emailMasterDao;
		this.transactionDao = transactionDao;
		this.stampingDao = stampingDao;
	}

	public EmailDetailsService getInstance(Data data,
										   String brandCode,
										   String vertical,
										   EmailDetailsMappings emailDetailMappings) {
		return new EmailDetailsService( emailMasterDao,  transactionDao,  data ,
				 brandCode,  emailDetailMappings,  stampingDao,  vertical);
	}

}
