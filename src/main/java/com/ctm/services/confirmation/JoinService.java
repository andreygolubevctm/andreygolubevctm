package com.ctm.services.confirmation;

import java.sql.SQLException;

import org.apache.log4j.Logger;

import com.ctm.dao.JoinDao;

public class JoinService {

	@SuppressWarnings("unused")
	private static Logger logger = Logger.getLogger(JoinService.class.getName());

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
