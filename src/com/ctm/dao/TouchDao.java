package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.AccessTouch;
import com.ctm.model.Touch;
import com.ctm.model.Touch.TouchType;

import javax.naming.NamingException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TouchDao {

	public TouchDao(){
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
	private Touch getBy(String method, String parameter) throws DaoException{
		SimpleDatabaseConnection dbSource = null;
		Touch touch = null;

		try{

			dbSource = new SimpleDatabaseConnection();

			PreparedStatement stmt = null;

			if (method.equals("operator")) {
				stmt = dbSource.getConnection().prepareStatement(
					"SELECT id, transaction_id, operator_id, type, CONCAT(date, ' ', time) AS dateTime " +
					"FROM ctm.touches " +
					"WHERE operator_id = ? " +
					"ORDER BY id desc " +
					"LIMIT 1 ;"
				);
				stmt.setString(1, parameter);
			}
			else {
				stmt = dbSource.getConnection().prepareStatement(
					"SELECT id, transaction_id, operator_id, type, CONCAT(date, ' ', time) AS dateTime " +
					"FROM ctm.touches " +
					"WHERE transaction_id = ? AND operator_id = ? " +
					"ORDER BY id desc " +
					"LIMIT 1 ;"
				);
				stmt.setString(1, parameter);
				stmt.setString(2, "online");
			}

			ResultSet resultSet = stmt.executeQuery();

			ArrayList<Touch> touches = new ArrayList<Touch>();

			while (resultSet.next()) {
				Touch touchObject = new Touch();
				mapToObject(touchObject,resultSet);
				touches.add(touchObject);
			}

			if(touches.size() == 1){
				touch = touches.get(0);
			}

		}
		catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		}
		catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return touch;
	}

	/**
	 * Return the most recent simples or online touch recorded against a transaction id.
	 *
	 * @param transactionId
	 * @return
	 * @throws DaoException
	 */
	public AccessTouch getlatestAccessTouch(long transactionId) throws DaoException{
		SimpleDatabaseConnection dbSource = null;
		AccessTouch touch = null;

		try{

			dbSource = new SimpleDatabaseConnection();

			PreparedStatement stmt = null;


			stmt = dbSource.getConnection().prepareStatement(
				"SELECT id, transaction_id, operator_id, type, CONCAT(date, ' ', time) AS dateTime, " +
				"IF(TIMESTAMP(NOW() - INTERVAL 45 MINUTE) > TIMESTAMP(CONCAT(date, ' ', time)), 1, 0) AS expired " +
				"FROM ctm.touches " +
				"WHERE transaction_id = ? " +
				"ORDER BY id desc " +
				"LIMIT 1 ;"
			);
			stmt.setLong(1, transactionId);

			ResultSet resultSet = stmt.executeQuery();

			while (resultSet.next()) {
				touch = new AccessTouch();
				mapToObject(touch, resultSet);
				touch.setExpired(resultSet.getInt("expired"));
			}

		}
		catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		}
		catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}

		return touch;
	}

	private void mapToObject(Touch touch, ResultSet resultSet) throws SQLException {
		touch.setId(resultSet.getInt("id"));
		touch.setTransactionId(resultSet.getLong("transaction_id"));
		touch.setDatetime(resultSet.getTimestamp("dateTime"));
		touch.setOperator(resultSet.getString("operator_id"));
		touch.setType(TouchType.findByCode(resultSet.getString("type")));
	}

	private String questionMarksBuilder(int length) {
		StringBuilder stringBuilder = new StringBuilder();
		for( int i = 0; i< length; i++){
			stringBuilder.append(" ?");
			if(i != length -1) stringBuilder.append(",");
		}
		return stringBuilder.toString();
	}

	public ArrayList<Touch> getTouchesForTransactionId(long transactionId) throws DaoException {
		List<Long> transactionIds = new ArrayList<Long>();
		transactionIds.add(transactionId);
		return getTouchesForTransactionIds(transactionIds);
	}

	/**
	 *
	 */
	public ArrayList<Touch> getTouchesForTransactionIds(List<Long> transactionIds) throws DaoException {
		SimpleDatabaseConnection dbSource = null;
		ArrayList<Touch> touches = new ArrayList<Touch>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			//
			// Get the touches on the provided transaction and others related by root ID
			//

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT DISTINCT t.transaction_id, CONCAT(t.date, ' ', t.time) as dateTime, " +
				"t.operator_id, t.type , t.description " +

				"FROM aggregator.transaction_header AS th  " +

				"	INNER JOIN aggregator.transaction_header AS th2 " +
				"	ON th.rootId = th2.rootId " +

				"	INNER JOIN ctm.touches AS t " +
				"	ON t.transaction_id = th2.transactionid " +

				"	WHERE th.transactionId  IN ( " + questionMarksBuilder(transactionIds.size()) + ") " +

				"	ORDER BY t.id DESC, t.date DESC, t.time DESC LIMIT 50"
			);

			int i = 1;

			for(long transactionId : transactionIds){
				stmt.setLong(i++, transactionId);
			}

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				Touch touch = new Touch();
				touch.setTransactionId(results.getLong("transaction_id"));
				touch.setOperator(results.getString("operator_id"));
				touch.setType(TouchType.findByCode(results.getString("type")));
				touch.setDatetime(results.getTimestamp("dateTime"));
				touch.setDescription(results.getString("description"));
				touches.add(touch);
			}
		}
		catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		}
		catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
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
			return resultSet.getInt(1) == 1;
		} catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
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
	public Touch getLatestByOperatorId(String operatorId) throws DaoException{
		return getBy("operator", operatorId);

	}

	/**
	 * Get the most recent touch recorded against a transaction id for an online customer.
	 *
	 * @param transactionId
	 * @return
	 * @throws DaoException
	 */
	public Touch getLatestByTransactionId(String transactionId) throws DaoException{
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
		return record( transactionId,  type,  operator,  null);
	}

	/**
	 * record() records a touch event against a transaction
	 *
	 * @param transactionId
	 * @param type
	 * @throws DaoException
	 */
	private Touch record(Long transactionId, String type, String operator, String description) throws DaoException {
		Touch touch = new Touch();
		touch.setTransactionId(transactionId);
		touch.setType(TouchType.findByCode(type));
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		if(description != null && description.length() > 200){
			description = description.substring(0 ,200);
		}

		try {
			if(operator == null || operator.isEmpty()) {
				operator = Touch.ONLINE_USER;
			}
			touch.setOperator(operator);

			PreparedStatement stmt = dbSource.getConnection().prepareStatement(
					"INSERT INTO ctm.touches (transaction_id, date, time, operator_id, type, description) " +
							"VALUES (?, NOW(), NOW(), ?, ?, ?);" , Statement.RETURN_GENERATED_KEYS
			);

			stmt.setLong(1, transactionId);
			stmt.setString(2, operator);
			stmt.setString(3, type);
			stmt.setString(4, description);

			stmt.executeUpdate();
			// Update the comment model with the insert ID
			ResultSet rs = stmt.getGeneratedKeys();
			if (rs != null && rs.next()) {
				touch.setId(rs.getInt(1));
			}
		}
		catch (SQLException | NamingException e) {
			throw new DaoException(e.getMessage(), e);
		}
		finally {
			dbSource.closeConnection();
		}
		return touch;
	}



	/**
	 * record() records a touch event against a transaction
	 *
	 * @param transactionId
	 * @param type
	 * @throws DaoException
	 */
	public Touch record(Touch touch) throws DaoException {
		return record( touch.getTransactionId(),  touch.getType().getCode(),  touch.getOperator(),  touch.getDescription());
	}


}
