package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.Vertical;

public class VerticalsDao {

	public VerticalsDao(){

	}


	/**
	 * Return all verticals from the database
	 *
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<Vertical> getVerticals() throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		ArrayList<Vertical> verticals = new ArrayList<Vertical>();

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT verticalId, verticalName, verticalCode " +
				"FROM ctm.vertical_master v " +
				"ORDER BY v.verticalCode;"
			);

			ResultSet verticalResult = stmt.executeQuery();

			while (verticalResult.next()) {

				Vertical vertical = new Vertical();
				vertical.setId(verticalResult.getInt("verticalId"));
				vertical.setName(verticalResult.getString("verticalName"));
				vertical.setCode(verticalResult.getString("verticalCode"));
				verticals.add(vertical);

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

		return verticals;
	}
}
