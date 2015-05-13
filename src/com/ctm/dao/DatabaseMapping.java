package com.ctm.dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;

public abstract class DatabaseMapping {
	private int count;
	private PreparedStatement stmt;

	public void handleParams(PreparedStatement stmt) throws SQLException {
		count = 0;
		this.stmt = stmt;
		mapParams();
		this.stmt = null;
	};
	protected abstract void mapParams() throws SQLException;

	protected void set(Object value) throws SQLException {
		if(value == null){
			stmt.setNull(++count, Types.NULL);
		} else if(value instanceof Integer){
			stmt.setInt(++count, (Integer) value);
		} else if(value instanceof String){
			stmt.setString(++count, (String) value);
		} else if(value instanceof java.util.Date){
			setDate(stmt, (java.util.Date) value);
		}else if(value instanceof Long){
			stmt.setLong(++count, (Long) value);
		}
	}


	private void setDate(PreparedStatement stmt, java.util.Date value) throws SQLException {
		stmt.setDate(++count, new Date(value.getTime()));
	}
}
