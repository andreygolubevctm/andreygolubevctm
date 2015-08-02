package com.ctm.dao;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by lbuchanan on 6/03/2015.
 */
public abstract class DatabaseQueryMapping<T> extends DatabaseMapping {
    protected abstract void mapParams() throws SQLException;

    public abstract T handleResult(ResultSet rs) throws SQLException;
}
