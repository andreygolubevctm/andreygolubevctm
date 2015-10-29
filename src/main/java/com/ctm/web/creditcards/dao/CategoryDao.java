package com.ctm.web.creditcards.dao;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.creditcards.category.model.Category;
import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CategoryDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(CategoryDao.class);

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

		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to retrieve categories", e);
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return categories;
	}
}
