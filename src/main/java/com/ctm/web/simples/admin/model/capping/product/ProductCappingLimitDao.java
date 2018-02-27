package com.ctm.web.simples.admin.model.capping.product;

import com.ctm.web.core.dao.DatabaseQueryMapping;
import com.ctm.web.core.dao.DatabaseUpdateMapping;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.exceptions.DaoException;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.ctm.web.simples.admin.dao.ProductCappingLimitSQL.*;

public class ProductCappingLimitDao {

    public static final String ALL_WILDCARD = "All";
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

        DatabaseQueryMapping databaseMapping = new DatabaseQueryMapping() {

            @Override
            public void mapParams() throws SQLException {
                set(fromRequest.getCappingAmount());
                set(fromRequest.getLimitType());
                set(fromRequest.getCappingLimitCategory());
                set(fromRequest.getEffectiveStart());
                set(fromRequest.getEffectiveEnd());
                set(fromRequest.getProductName());
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

        DatabaseQueryMapping<Integer> databaseQueryMapping = getOverlappingProductCapQueryMapping(byId.getProductName(), updateDto.getLimitType(), Optional.ofNullable(byId.getState()), Optional.ofNullable(byId.getHealthCvr()), updateDto.getEffectiveStart(), updateDto.getEffectiveEnd());
        List<Integer> idList = cappingIdLookup.getList(databaseQueryMapping, FIND_BY_LIMIT_PARAMS).stream().filter(i -> !i.equals(updateDto.getCappingLimitId())).collect(Collectors.toList());
        return findAllByCappingLimitId(idList);
    }


    public List<ProductCappingLimit> findOverlappingProductLimits(CreateProductCappingLimitDTO createDto) throws DaoException {
        Optional<String> productName = this.findProductName(createDto.getProviderId(), createDto.getProductName(), Optional.ofNullable(createDto.getState()), Optional.ofNullable(createDto.getHealthCvr()), createDto.getEffectiveStart(), createDto.getEffectiveEnd());
        DatabaseQueryMapping<Integer> databaseQueryMapping = getOverlappingProductCapQueryMapping(productName.orElse(""), createDto.getLimitType(), Optional.ofNullable(createDto.getState()), Optional.ofNullable(createDto.getHealthCvr()), createDto.getEffectiveStart(), createDto.getEffectiveEnd());
        List<Integer> idList = cappingIdLookup.getList(databaseQueryMapping, FIND_BY_LIMIT_PARAMS);
        return findAllByCappingLimitId(idList);
    }

    public Optional<String> findProductName(Integer providerId, String productName, Optional<String> state, Optional<String> healthCvr, LocalDate effectiveStart, LocalDate effectiveEnd) throws DaoException {

        final String lookupProductNameStatement;
        boolean isStateSelected = state.filter(s -> !ALL_WILDCARD.equalsIgnoreCase(s)).isPresent();
        boolean isMembershipSelected = healthCvr.filter(s -> !ALL_WILDCARD.equalsIgnoreCase(s)).isPresent();

        if (isStateSelected && isMembershipSelected) {
            lookupProductNameStatement = GET_PRODUCT_NAME_WITH_STATE_AND_MEMBERSHIP;
        }
        else if (isStateSelected && !isMembershipSelected) {
            lookupProductNameStatement = GET_PRODUCT_NAME_WITH_STATE;
        }
        else if (!isStateSelected && isMembershipSelected) {
            lookupProductNameStatement = GET_PRODUCT_NAME_WITH_MEMBERSHIP;
        }  else {
            lookupProductNameStatement = GET_PRODUCT_NAME;
        }
        DatabaseQueryMapping<String> productCodeDatabaseMapping = getProductNameDatabaseMapping(
                providerId, productName, state, healthCvr, effectiveStart, effectiveEnd);
        return Optional.ofNullable(productCodeLookup.get(productCodeDatabaseMapping, lookupProductNameStatement));
    }

    private DatabaseQueryMapping<String> getProductNameDatabaseMapping(Integer providerId, String productName, Optional<String> state, Optional<String> healthCvr, LocalDate effectiveStart, LocalDate effectiveEnd) {
        return new DatabaseQueryMapping<String>() {
            @Override
            protected void mapParams() throws SQLException {
                set(providerId);
                set(productName);
                set(effectiveStart);
                set(effectiveEnd);
                boolean isStateSelected = state.filter(s -> !ALL_WILDCARD.equalsIgnoreCase(s)).isPresent();
                boolean isMembershipSelected = healthCvr.filter(s -> !ALL_WILDCARD.equalsIgnoreCase(s)).isPresent();

                if (isStateSelected) {
                    set(state.get());
                }

                if (isMembershipSelected) {
                    set(healthCvr.get());
                }

            }

            @Override
            public String handleResult(ResultSet rs) throws SQLException {
                return rs.getString("productName");
            }
        };
    }


    private DatabaseQueryMapping<Integer> getOverlappingProductCapQueryMapping(String productCode, final String limitType, final Optional<String> state, final Optional<String> membership, final LocalDate effectiveStart, final LocalDate effectiveEnd) {
        return new DatabaseQueryMapping<Integer>() {
            @Override
            protected void mapParams() throws SQLException {
                set(limitType);
                set(productCode);
                set(state.orElse(ALL_WILDCARD));
                set(membership.orElse(ALL_WILDCARD));
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
                rs.getString("product_name"),
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
