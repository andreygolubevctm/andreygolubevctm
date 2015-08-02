package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;

public class ScrapesDao {

	private static Logger logger = Logger.getLogger(ScrapesDao.class.getName());

	/**
	 * Return html based off given id
	 *
	 * @return
	 * @throws DaoException
	 */
	public String getScrapeHtml(int id) throws DaoException{
		logger.debug("getting html for id: " + id);
		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();

		String html = "";

		try{
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT html FROM ctm.scrapes WHERE id = ? "
			);

			stmt.setLong(1, id);

			ResultSet result = stmt.executeQuery();

			while (result.next()) {
				html = result.getString("html");
			}

		} catch (SQLException | NamingException e) {
			logger.error("Failed to get html for id:" + id , e);
			throw new DaoException("Failed to get html for id:" + id + " error message:" + e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return html;
	}
}
