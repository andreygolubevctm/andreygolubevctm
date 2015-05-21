package com.ctm.dao.simples;

import com.ctm.dao.SqlDao;
import com.ctm.exceptions.DaoException;

public class MessageDeferDao {
	private final SqlDao<MessageDeferDao> sqlDao = new SqlDao<>();

	public void deferAll() throws DaoException {
		sqlDao.update(
			"UPDATE simples.message " +
			"SET whenToAction = CONCAT(DATE_ADD(CURDATE(), INTERVAL (9 - IF(DAYOFWEEK(CURDATE())=1, 8, DAYOFWEEK(CURDATE()))) DAY), ' 01:00:00') " +
			"WHERE statusId NOT IN (2, 7, 33) " +
			"AND ( " +
			"	hawkingOptin = 'N' " +
			"	OR " +
			"	YEARWEEK(created, 1) <> YEARWEEK(CURDATE(), 1) " +
			");"
		);
	}
}