package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.Touch.TouchType;
import com.ctm.web.core.model.TouchProductProperty;
import com.ctm.web.core.services.AccessTouchService;
import org.springframework.stereotype.Repository;

import javax.naming.NamingException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class TouchDao {

    private final SqlDao<Touch> sqlDao;

    public TouchDao() {
        sqlDao = new SqlDao<Touch>();
    }

    /**
     * Return the most recent touch record by alternative means.
     * 1) by operator - simples only
     * 2) by transactionid - online users only.
     * This is a private method that should only be called by the two public methods below.
     *
     * @param method
     * @param parameter
     * @return
     * @throws DaoException
     */
    private Touch getBy(String method, final String parameter) throws DaoException {
        DatabaseQueryMapping<Touch> databaseMapping;
        String sql;
        if (method.equals("operator")) {
            sql = "SELECT id, transaction_id, operator_id, type, CONCAT(date, ' ', time) AS dateTime " +
                    "FROM ctm.touches " +
                    "WHERE operator_id = ? " +
                    "ORDER BY id desc " +
                    "LIMIT 1 ;";
            databaseMapping = new DatabaseQueryMapping<Touch>() {

                @Override
                public void mapParams() throws SQLException {
                    set(parameter);
                }

                @Override
                public Touch handleResult(ResultSet rs) throws SQLException {
                    return mapToObject(rs);
                }
            };
        } else {
            sql = "SELECT id, transaction_id, operator_id, type, CONCAT(date, ' ', time) AS dateTime " +
                    "FROM ctm.touches " +
                    "WHERE transaction_id = ? AND operator_id = ? " +
                    "ORDER BY id desc " +
                    "LIMIT 1 ;";

            databaseMapping = new DatabaseQueryMapping<Touch>() {

                @Override
                public void mapParams() throws SQLException {
                    set(parameter);
                    set("online");
                }

                @Override
                public Touch handleResult(ResultSet rs) throws SQLException {
                    return mapToObject(rs);
                }
            };
        }

        return sqlDao.get(databaseMapping, sql);
    }

    /**
     * Return the most recent simples or online touch recorded against a transaction id.
     *
     * @param transactionId
     * @return
     * @throws DaoException
     */
    public Touch getLatestTouchByTransactionId(final long transactionId) throws DaoException {
        DatabaseQueryMapping<Touch> databaseMapping = new DatabaseQueryMapping<Touch>() {

            @Override
            public void mapParams() throws SQLException {
                set(transactionId);
            }

            @Override
            public Touch handleResult(ResultSet rs) throws SQLException {
                return mapToObject(rs);
            }
        };
        return sqlDao.get(databaseMapping,
                "SELECT t.id, t.transaction_id, t.operator_id, t.type, CONCAT(date, ' ', time) AS dateTime " +
                        "FROM ctm.touches t " +
                        "WHERE transaction_id = ? " +
                        "ORDER BY id desc " +
                        "LIMIT 1 ;");
    }

    private String questionMarksBuilder(int length) {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < length; i++) {
            stringBuilder.append(" ?");
            if (i != length - 1) stringBuilder.append(",");
        }
        return stringBuilder.toString();
    }

    private void mapResult(ArrayList<Touch> touches, ResultSet results) throws SQLException {
        Touch touch = new Touch();
        touch.setTransactionId(results.getLong("transaction_id"));
        touch.setOperator(results.getString("operator_id"));
        touch.setType(TouchType.findByCode(results.getString("type")));
        touch.setDatetime(results.getTimestamp("dateTime"));

        String productCode = results.getString("productCode");
        if (productCode != null) {
            TouchProductProperty touchProductProperty = new TouchProductProperty();
            touchProductProperty.setProductCode(results.getString("productCode"));
            touchProductProperty.setProductName(results.getString("productName"));
            touchProductProperty.setProviderCode(results.getString("providerCode"));
            touchProductProperty.setProviderName(results.getString("providerName"));
            touch.setTouchProductProperty(touchProductProperty);
        }
        touches.add(touch);
    }

    public ArrayList<Touch> getTouchesForRootId(long transactionId) throws DaoException {
        List<Long> transactionIds = new ArrayList<Long>();
        transactionIds.add(transactionId);
        return getTouchesForRootIds(transactionIds);
    }

    /**
     *
     */
    public ArrayList<Touch> getTouchesForRootIds(List<Long> transactionIds) throws DaoException {

        String sql = " SELECT" +
                " 	DISTINCT t.touchId, t.transaction_id, t.dateTime, t.operator_id, t.type,  " +
                "     tp.productCode, pm.LongTitle as productName,  pp.providerCode, pp.name as providerName " +
                " FROM" +
                " 	(SELECT " +
                " 		DISTINCT t.id as touchId, t.transaction_id, CONCAT(t.date, ' ', t.time) as dateTime, " +
                " 		t.operator_id, t.type" +
                " 	FROM " +
                " 		ctm.touches AS t " +
                " 		INNER JOIN aggregator.transaction_header2_cold  AS th  " +
                " 		ON t.transaction_id = th.transactionid" +
                " 	WHERE th.rootId IN ( " + questionMarksBuilder(transactionIds.size()) + ")" +
                " 	UNION ALL" +
                " 	SELECT " +
                " 		DISTINCT t.id as touchId, t.transaction_id, CONCAT(t.date, ' ', t.time) as dateTime, " +
                " 		t.operator_id, t.type" +
                " 	FROM aggregator.transaction_header AS th  " +
                " 		INNER JOIN ctm.touches AS t " +
                " 		ON t.transaction_id = th.transactionid" +
                " 	WHERE th.rootId IN ( " + questionMarksBuilder(transactionIds.size()) + ") " +
                " 	) AS t" +
                " 	LEFT OUTER JOIN ctm.touches_products AS tp " +
                " 	ON t.touchId = tp.touchesId " +
                " 	LEFT OUTER JOIN ctm.product_master AS pm " +
                " 	ON pm.productId = tp.productCode and CURDATE() BETWEEN pm.effectiveStart and pm.effectiveEnd " +
                " 	LEFT OUTER JOIN ctm.provider_master AS pp " +
                " 	ON pm.providerId = pp.providerId" +
                " ORDER BY " +
                " 	t.touchId DESC, t.dateTime DESC" +
                " LIMIT 50;";
        SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
        ArrayList<Touch> touches = new ArrayList<>();

        try {
            //
            // Get the touches on the provided transaction and others related by root ID
            //

            PreparedStatement stmt = dbSource.getConnection().prepareStatement(sql);
            int i = 1;

            for (long transactionId : transactionIds) {
                stmt.setLong(i++, transactionId);
            }

            for (long transactionId : transactionIds) {
                stmt.setLong(i++, transactionId);
            }

            ResultSet results = stmt.executeQuery();

            while (results.next()) {
                mapResult(touches, results);
            }
            stmt.close();
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }

        return touches;
    }

    public boolean hasTouch(final long transactionId, final String type) throws DaoException {
        SimpleDatabaseConnection simpleDatabaseConnection = new SimpleDatabaseConnection();
        try {
            final Connection connection = simpleDatabaseConnection.getConnection();
            final PreparedStatement statement = connection.prepareStatement("" +
                    "SELECT count(transaction_id) FROM ctm.touches " +
                    "WHERE transaction_id=? AND type=?");
            statement.setLong(1, transactionId);
            statement.setString(2, type);
            final ResultSet resultSet = statement.executeQuery();
            resultSet.first();
            return resultSet.getInt(1) >= 1;
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        } finally {
            simpleDatabaseConnection.closeConnection();
        }
    }


    /**
     * Get the most recent touch recorded for an operatorId (their LDAP userid)
     *
     * @param operatorId
     * @return
     * @throws DaoException
     */
    public Touch getLatestByOperatorId(String operatorId) throws DaoException {
        return getBy("operator", operatorId);

    }

    /**
     * Get the most recent touch recorded against a transaction id for an online customer.
     *
     * @param transactionId
     * @return
     * @throws DaoException
     */
    public Touch getLatestOnlineTouchByTransactionId(String transactionId) throws DaoException {
        return getBy("transactionId", transactionId);
    }

    /**
     * record() records a touch event against a transaction
     *
     * @param transactionId
     * @param type
     * @throws DaoException
     */
    public Touch record(Long transactionId, String type, String operator) throws DaoException {
        Touch touch = AccessTouchService.createTouchObject(transactionId, type, operator);
        return record(touch);
    }

    /***
     * record() records a touch event against a transaction
     *
     * @param touch
     * @return
     * @throws DaoException
     */
    public Touch record(Touch touch) throws DaoException {
        SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

        try {
            PreparedStatement stmt = dbSource.getConnection().prepareStatement(
                    "INSERT INTO ctm.touches (transaction_id, date, time, operator_id, type) " +
                            "VALUES (?, NOW(), NOW(), ?, ?);", Statement.RETURN_GENERATED_KEYS
            );

            stmt.setLong(1, touch.getTransactionId());
            if (touch.getOperator() == null || touch.getOperator().isEmpty()) {
                touch.setOperator(Touch.ONLINE_USER);
            }
            stmt.setString(2, touch.getOperator());
            stmt.setString(3, touch.getType().getCode());

            stmt.executeUpdate();
            // Update the comment model with the insert ID
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs != null && rs.next()) {
                touch.setId(rs.getInt(1));
            }

            if (touch.getTouchProductProperty() != null) {
                stmt = dbSource.getConnection().prepareStatement(
                        "INSERT INTO ctm.touches_products (touchesId, productCode) " +
                                "VALUES (?, ?);", Statement.RETURN_GENERATED_KEYS
                );

                stmt.setLong(1, touch.getId());
                stmt.setString(2, touch.getTouchProductProperty().getProductCode());

                stmt.executeUpdate();
                // Update the comment model with the insert ID
                rs = stmt.getGeneratedKeys();
                if (rs != null && rs.next()) {
                    touch.getTouchProductProperty().setId(rs.getLong(1));
                }
            }

            if (touch.getTouchCommentProperty() != null) {
                stmt = dbSource.getConnection().prepareStatement(
                        "INSERT INTO ctm.touches_comments (touchesId, comment) " +
                                "VALUES (?, ?);", Statement.RETURN_GENERATED_KEYS
                );

                stmt.setLong(1, touch.getId());
                stmt.setString(2, touch.getTouchCommentProperty().getComment());

                stmt.executeUpdate();
                // Update the comment model with the insert ID
                rs = stmt.getGeneratedKeys();
                if (rs != null && rs.next()) {
                    touch.getTouchCommentProperty().setId(rs.getLong(1));
                }
            }
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
        return touch;
    }

    private Touch mapToObject(ResultSet rs) throws SQLException {
        Touch touch = new Touch();
        touch.setId(rs.getInt("id"));
        touch.setTransactionId(rs.getLong("transaction_id"));
        touch.setDatetime(rs.getTimestamp("dateTime"));
        touch.setOperator(rs.getString("operator_id"));
        touch.setType(TouchType.findByCode(rs.getString("type")));
        return touch;
    }

    /**
     * Supercede any previous touch-types defined for this touch-type with this one.
     * Primarily to allow prioritisation of one touch type over another where the existence of the original touch type
     * may affect functionality based on the new touch type.
     *
     * @see Touch.TouchType
     *
     * @param transactionId
     * @param type
     * @throws DaoException
     */
    public void updateTouch(long transactionId, Touch.TouchType type) throws DaoException {
        SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

        try {
            PreparedStatement stmt = dbSource.getConnection().prepareStatement("UPDATE ctm.touches SET type = '" + type.getCode() + "', date = NOW(), time = NOW() WHERE transaction_id = " + transactionId + " AND type IN ( " + type.getOverrides() + " )");
            stmt.executeUpdate();
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        } finally {
            dbSource.closeConnection();
        }
    }
}
