package com.ctm.web.simples.admin.model.capping.product;

import com.ctm.web.core.dao.DatabaseQueryMapping;
import com.ctm.web.core.dao.DatabaseUpdateMapping;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.exceptions.DaoException;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.ctm.web.simples.admin.dao.ProductCappingLimitSQL.*;

public class ProductCappingLimitDao {

    private final SqlDao<ProductCappingLimit> sqlDao = new SqlDao<>();

    private final SqlDao<String> productCodeLookup = new SqlDao<>();
    private final SqlDao<Integer> cappingIdLookup = new SqlDao<>();

    public List<ProductCappingLimit> findAllByProviderId(int providerId) throws DaoException {

        DatabaseQueryMapping<ProductCappingLimit> databaseMapping = new DatabaseQueryMapping<ProductCappingLimit>() {

            @Override
            public void mapParams() throws SQLException {
                set(providerId);
            }

            @Override
            public ProductCappingLimit handleResult(ResultSet rs) throws SQLException {
                return toProductCappingLimit(rs);
            }
        };

        return sqlDao.getList(databaseMapping, GET_ALL_RECORDS_BY_PROVIDER_ID);
    }

    public List<ProductCappingLimit> findAllByCappingLimitId(List<Integer> providerIds) throws DaoException {

        DatabaseQueryMapping<ProductCappingLimit> databaseMapping = new DatabaseQueryMapping<ProductCappingLimit>() {

            @Override
            public void mapParams() throws SQLException {
                set(providerIds.stream().map(i -> Integer.toString(i)).collect(Collectors.joining(",")));
            }

            @Override
            public ProductCappingLimit handleResult(ResultSet rs) throws SQLException {
                return toProductCappingLimit(rs);
            }
        };

        return sqlDao.getList(databaseMapping, GET_RECORDS_BY_ID);
    }

    public ProductCappingLimit create(CreateProductCappingLimitDTO fromRequest) throws DaoException {

        Integer providerId = fromRequest.getProviderId();
        String productName = fromRequest.getProductName();
        String state = fromRequest.getState();
        String healthCvr = fromRequest.getHealthCvr();
        LocalDate effectiveStart = fromRequest.getEffectiveStart();
        LocalDate effectiveEnd = fromRequest.getEffectiveEnd();


        final Optional<String> productCode = findProductCode(providerId, productName, state, healthCvr, effectiveStart, effectiveEnd);

        DatabaseQueryMapping databaseMapping = new DatabaseQueryMapping() {

            @Override
            public void mapParams() throws SQLException {
                set(fromRequest.getCappingAmount());
                set(fromRequest.getLimitType());
                set(fromRequest.getCappingLimitCategory());
                set(fromRequest.getEffectiveStart());
                set(fromRequest.getEffectiveEnd());
                set(productCode.orElse(""));
                set(fromRequest.getProviderId());
                set(fromRequest.getHealthCvr());
                set(fromRequest.getState());
            }

            @Override
            public ProductCappingLimit handleResult(ResultSet rs) throws SQLException {
                return toProductCappingLimit(rs);
            }
        };


        sqlDao.insert(databaseMapping, CREATE);
        return findOverlappingProductLimits(fromRequest).stream().findFirst().orElse(null);
    }

    public String delete(Integer cappingLimitId) throws DaoException {
        DatabaseUpdateMapping databaseMapping = new DatabaseUpdateMapping() {
            @Override
            public void mapParams() throws SQLException {
                set(cappingLimitId);
            }

            @Override
            public String getStatement() {
                return DELETE_BY_ID;
            }
        };
        return sqlDao.update(databaseMapping) > 0 ? "success" : "fail";
    }

    public ProductCappingLimit findById(Integer cappingLimitId) throws DaoException {
        return findAllByCappingLimitId(Collections.singletonList(cappingLimitId)).stream().findFirst().orElse(null);
    }

    public ProductCappingLimit update(UpdateProductCappingLimitDTO fromRequest) throws DaoException {
        DatabaseUpdateMapping updateMapping = new DatabaseUpdateMapping() {
            @Override
            protected void mapParams() throws SQLException {
                set(fromRequest.getLimitType());
                set(fromRequest.getCappingLimitCategory());
                set(fromRequest.getEffectiveStart());
                set(fromRequest.getEffectiveEnd());
                set(fromRequest.getCappingAmount());
                set(fromRequest.getCappingLimitId());
            }

            @Override
            public String getStatement() {
                return UPDATE_BY_ID;
            }
        };

        int updateCount = sqlDao.update(updateMapping);
        if (updateCount != 1) {
            throw new DaoException(String.format("Unexpected number of records updated (Expected '1'. Actual '%1$d')", updateCount));
        }
        return findById(fromRequest.getCappingLimitId());
    }


    public List<ProductCappingLimit> findOverlappingProductLimits(UpdateProductCappingLimitDTO updateDto) throws DaoException {
        ProductCappingLimit byId = this.findById(updateDto.getCappingLimitId());

        DatabaseQueryMapping<Integer> databaseQueryMapping = getOverlappingProductCapQueryMapping(byId.getProductCode(), updateDto.getLimitType(), updateDto.getEffectiveStart(), updateDto.getEffectiveEnd());
        List<Integer> idList = cappingIdLookup.getList(databaseQueryMapping, FIND_BY_LIMIT_PARAMS).stream().filter(i -> !i.equals(updateDto.getCappingLimitId())).collect(Collectors.toList());
        return findAllByCappingLimitId(idList);
    }


    public List<ProductCappingLimit> findOverlappingProductLimits(CreateProductCappingLimitDTO createDto) throws DaoException {
        Optional<String> productCode = this.findProductCode(createDto.getProviderId(), createDto.getProductName(), createDto.getState(), createDto.getHealthCvr(), createDto.getEffectiveStart(), createDto.getEffectiveEnd());
        DatabaseQueryMapping<Integer> databaseQueryMapping = getOverlappingProductCapQueryMapping(productCode.orElse(""), createDto.getLimitType(), createDto.getEffectiveStart(), createDto.getEffectiveEnd());
        List<Integer> idList = cappingIdLookup.getList(databaseQueryMapping, FIND_BY_LIMIT_PARAMS);
        return findAllByCappingLimitId(idList);
    }

    public Optional<String> findProductCode(Integer providerId, String productName, String state, String healthCvr, LocalDate effectiveStart, LocalDate effectiveEnd) throws DaoException {
        DatabaseQueryMapping<String> productCodeDatabaseMapping = getProductCodeDatabaseMapping(
                providerId, productName, state, healthCvr, effectiveStart, effectiveEnd);
        return Optional.ofNullable(productCodeLookup.get(productCodeDatabaseMapping, GET_PRODUCT_CODE));
    }

    private DatabaseQueryMapping<String> getProductCodeDatabaseMapping(Integer providerId, String productName, String state, String healthCvr, LocalDate effectiveStart, LocalDate effectiveEnd) {
        return new DatabaseQueryMapping<String>() {
            @Override
            protected void mapParams() throws SQLException {
                set(providerId);
                set(productName);
                set(state);
                set(healthCvr);
                set(effectiveStart);
                set(effectiveEnd);
            }

            @Override
            public String handleResult(ResultSet rs) throws SQLException {
                return rs.getString("productCode");
            }
        };
    }


    private DatabaseQueryMapping<Integer> getOverlappingProductCapQueryMapping(String productCode, final String limitType, final LocalDate effectiveStart, final LocalDate effectiveEnd) {
        return new DatabaseQueryMapping<Integer>() {
            @Override
            protected void mapParams() throws SQLException {
                set(limitType);
                set(productCode);
                set(effectiveStart);
                set(effectiveEnd);
            }

            @Override
            public Integer handleResult(ResultSet rs) throws SQLException {
                return rs.getInt("id");
            }
        };
    }

    private ProductCappingLimit toProductCappingLimit(ResultSet rs) throws SQLException {
        return new ProductCappingLimit(
                rs.getInt("providerId"),
                rs.getInt("cappingLimitId"),
                rs.getString("productCode"),
                rs.getString("productName"),
                rs.getString("state"),
                rs.getString("healthCvr"),
                rs.getString("limitType"),
                rs.getInt("cappingAmount"),
                rs.getInt("currentJoinCount"),
                rs.getDate("effectiveStart").toLocalDate(),
                rs.getDate("effectiveEnd").toLocalDate(),
                rs.getString("cappingLimitCategory"),
                rs.getBoolean("isCurrent")
        );
    }
}
