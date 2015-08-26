package com.ctm.services.confirmation;

import java.sql.SQLException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.dao.JoinDao;

public class JoinService {

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(JoinService.class.getName());

	private JoinDao joinDao;

	public JoinService() {
		this.joinDao = new JoinDao();
	}

	/**
	 * Write join details to `ctm`.`joins`
	 * @param transactionId
	 * @param productId
	 * @return joinDate
	 * @throws SQLException
	 **/
	public void writeJoin(long transactionId, String productId) {
		joinDao.writeJoin(transactionId, productId);
	}

}
