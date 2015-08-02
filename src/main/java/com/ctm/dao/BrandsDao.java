package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.Brand;

public class BrandsDao {

	public BrandsDao(){

	}

	/**
	 * Return all brands in the database
	 *
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<Brand> getBrands() throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		ArrayList<Brand> brands = new ArrayList<Brand>();

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT styleCodeId, styleCodeName, styleCode  " +
				"FROM ctm.stylecodes s " +
				"ORDER BY s.styleCodeId;"
			);

			ResultSet brandResult = stmt.executeQuery();

			while (brandResult.next()) {

				Brand brand = new Brand();
				brand.setId(brandResult.getInt("styleCodeId"));
				brand.setName(brandResult.getString("styleCodeName"));
				brand.setCode(brandResult.getString("styleCode"));
				brands.add(brand);

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

		return brands;
	}
}
