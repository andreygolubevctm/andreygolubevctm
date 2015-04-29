package com.ctm.dao.transaction;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by lbuchanan on 6/03/2015.
 */
public interface DatabaseQueryMapping<T> {
    public void handleParams(PreparedStatement stmt) throws SQLException;
    public T handleResult(ResultSet rs) throws SQLException;
}
