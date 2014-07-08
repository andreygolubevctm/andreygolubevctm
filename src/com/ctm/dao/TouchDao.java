package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Touch;

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
				touchObject.setId(resultSet.getInt("id"));
				touchObject.setTransactionId(resultSet.getString("transaction_id"));
				touchObject.setDatetime(resultSet.getDate("dateTime"));
				touchObject.setOperator(resultSet.getString("operator_id"));
				touchObject.setType(resultSet.getString("type"));
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
	 *
	 */
	public ArrayList<Touch> getTouchesForTransactionId(long transactionId) throws DaoException {

		SimpleDatabaseConnection dbSource = null;
		ArrayList<Touch> touches = new ArrayList<Touch>();

		try {
			PreparedStatement stmt;
			dbSource = new SimpleDatabaseConnection();

			//
			// Get the touches on the provided transaction and others related by root ID
			//

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT DISTINCT t2.transaction_id, CONCAT(t2.date, ' ', t2.time) as dateTime, " +
				"t2.operator_id, t2.type " +

				"FROM ctm.touches t " +

				"	INNER JOIN aggregator.transaction_header AS th " +
				"		ON th.transactionid  = t.transaction_id " +

				"	INNER JOIN aggregator.transaction_header AS th2 " +
				"		ON th.rootId = th2.rootId " +

				"	INNER JOIN ctm.touches AS t2 " +
				"	ON t2.transaction_id = th2.transactionid " +

				"	WHERE t.transaction_id  = ? " +
				"	ORDER BY t2.id DESC, t2.date DESC, t2.time DESC LIMIT 50"
			);
			stmt.setLong(1, transactionId);

			ResultSet results = stmt.executeQuery();

			while (results.next()) {
				Touch touch = new Touch();
				touch.setTransactionId(results.getString("transaction_id"));
				touch.setOperator(results.getString("operator_id"));
				touch.setType(results.getString("type"));
				touch.setDatetime(results.getTimestamp("dateTime"));
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
}
