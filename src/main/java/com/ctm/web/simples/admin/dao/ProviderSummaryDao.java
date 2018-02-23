package com.ctm.web.simples.admin.dao;

import com.ctm.web.core.dao.DatabaseQueryMapping;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.simples.admin.model.capping.product.HealthProductProviderSummary;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import static com.ctm.web.simples.admin.dao.ProductCappingLimitSQL.GET_PROVIDER_SUMMARY;

public class ProviderSummaryDao {
    private final SqlDao<HealthProductProviderSummary> dao = new SqlDao<>();

    public List<HealthProductProviderSummary> findProviderSummary() throws DaoException {
        DatabaseQueryMapping<HealthProductProviderSummary> databaseQueryMapping = new DatabaseQueryMapping<HealthProductProviderSummary>() {
            @Override
            protected void mapParams() throws SQLException {
                /* Intentionally Empty. */
            }

            @Override
            public HealthProductProviderSummary handleResult(ResultSet rs) throws SQLException {
                return new HealthProductProviderSummary(
                        rs.getInt("providerId"),
                        rs.getString("providerName"),
                        rs.getString("providerCode"),
                        rs.getInt("currentProductCapCount")
                );
            }
        };

        return dao.getList(databaseQueryMapping, GET_PROVIDER_SUMMARY);
    }
}
