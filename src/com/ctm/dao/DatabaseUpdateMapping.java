package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;

public interface DatabaseUpdateMapping {
	public void handleParams(PreparedStatement stmt) throws SQLException;
}
