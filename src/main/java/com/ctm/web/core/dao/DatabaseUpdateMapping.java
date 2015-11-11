package com.ctm.web.core.dao;

import java.sql.SQLException;

public abstract class DatabaseUpdateMapping extends DatabaseMapping {
	private int count;
	protected abstract void mapParams() throws SQLException;
    public abstract String getStatement() ;
}
