package com.ctm.web.core.confirmation.services;

import com.ctm.web.core.dao.JoinDao;
import org.springframework.stereotype.Component;

import java.sql.SQLException;

@Component
public class JoinService {

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
