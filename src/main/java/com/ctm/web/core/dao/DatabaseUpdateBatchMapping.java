package com.ctm.web.core.dao;

import java.sql.SQLException;

public abstract class DatabaseUpdateBatchMapping extends DatabaseMapping {
	protected abstract void mapParams() throws SQLException;
    public abstract String getStatement() ;
	protected void addToBatch() throws SQLException {
		stmt.addBatch();
		count = 0;
	}
}
