package com.ctm.web.core.dao;

import com.ctm.exceptions.DaoException;
import org.jsoup.helper.StringUtil;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class ProductPropertiesDao {

    public Long getProductPropertiesCount(ArrayList<String> productIds) throws DaoException {
        SqlDao<Long> dao = new SqlDao<>();
        return dao.get(new DatabaseQueryMapping<Long>(){
            @Override
            protected void mapParams() throws SQLException {}
            @Override
            public Long handleResult(ResultSet rs) throws SQLException {
                return (Long) rs.getObject("count");
            }
        }, "SELECT count(*) as count FROM ctm.product_properties WHERE ProductId IN("+ StringUtil.join(productIds, ",")+") AND SequenceNo > 0 LIMIT 999999");
    }
}
