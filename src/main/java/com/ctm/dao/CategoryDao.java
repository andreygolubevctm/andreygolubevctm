package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Category;

public class CategoryDao {
	public ArrayList<Category> getCategories(int verticalId, int styleCodeId) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		ArrayList<Category> categories = new ArrayList<Category>();

		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT categoryId, categoryCode, categoryLabel " +
				"FROM ctm.category_master " +
						// This should probably be from page settings instead.
				" WHERE verticalId = ? AND styleCodeId = ?"
			);

			stmt.setInt(1, verticalId);
			stmt.setInt(2, styleCodeId);

			ResultSet categoryResult = stmt.executeQuery();

			while (categoryResult.next()) {

				Category category = new Category();
				category.setId(categoryResult.getInt("categoryId"));
				category.setLabel(categoryResult.getString("categoryLabel"));
				category.setCode(categoryResult.getString("categoryCode"));
				categories.add(category);

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

		return categories;
	}
}
