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
	 * 2) by transctionid - online users only.
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

			if(method.equals("operator")){
				stmt = dbSource.getConnection().prepareStatement(
					"SELECT id, transaction_id, operator_id, type, CONCAT(date, ' ', time) as dateTime " +
					"FROM ctm.touches " +
					"WHERE operator_id = ? " +
					"ORDER BY id desc " +
					"LIMIT 1 ;"
				);
				stmt.setString(1, parameter);
			}else{
				stmt = dbSource.getConnection().prepareStatement(
					"SELECT id, transaction_id, operator_id, type, CONCAT(date, ' ', time) as dateTime " +
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

		} catch (SQLException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			e.printStackTrace();
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return touch;
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
