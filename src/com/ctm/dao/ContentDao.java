package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.content.Content;
import com.ctm.model.content.ContentSupplement;

public class ContentDao {

	private static Logger logger = Logger.getLogger(ContentDao.class.getName());

	public ContentDao(){

	}

	/**
	 * Queries the content_control table. Must provide key, the brand and the effective date to return content.
	 * Multiple keys can be stored in the DB with different date ranges.
	 * Supplementary content is additional key/value paired data linked to a single content item.
	 *
	 * @param contentKey
	 * @param brandId
	 * @param effectiveDate
	 * @param includeSupplementary
	 * @return
	 */
	public Content getByKey(String contentKey, int brandId, Date effectiveDate, boolean includeSupplementary) throws DaoException{

		SimpleDatabaseConnection dbSource = null;
		Content content = null;

		try{
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT contentControlId, styleCodeId, contentKey, contentCode, contentValue, effectiveStart, effectiveEnd " +
				"FROM ctm.content_control cc " +
				"WHERE cc.contentKey = ? " +
					"AND cc.styleCodeId = ? " +
					"AND cc.effectiveStart < ? " +
					"AND (cc.effectiveEnd > ? OR cc.effectiveEnd = '0000-00-00') ;"
			);

			stmt.setString(1, contentKey);
			stmt.setInt(2, brandId);
			stmt.setDate(3, new java.sql.Date(effectiveDate.getTime()));
			stmt.setDate(4, new java.sql.Date(effectiveDate.getTime()));

			ResultSet resultSet = stmt.executeQuery();

			ArrayList<Content> contents = new ArrayList<Content>();

			while (resultSet.next()) {

				Content contentItem = new Content();
				contentItem.setId(resultSet.getInt("contentControlId"));
				contentItem.setStyleCodeId(resultSet.getInt("styleCodeId"));
				contentItem.setContentKey(resultSet.getString("contentKey"));
				contentItem.setContentCode(resultSet.getString("contentCode"));
				contentItem.setContentValue(resultSet.getString("contentValue"));
				contentItem.setEffectiveStart(resultSet.getDate("effectiveStart"));
				contentItem.setEffectiveEnd(resultSet.getDate("effectiveEnd"));

				contents.add(contentItem);

			}

			if(contents.size() > 1){
				logger.error("There is more than one content value for this content code: "+contentKey);
			}else if(contents.size() == 0){
				logger.error("There is no record of this content key: "+contentKey);
			}else{
				content = contents.get(0);

				if(includeSupplementary){
					PreparedStatement stmtSup = dbSource.getConnection().prepareStatement(
						"SELECT contentControlId, supplementaryKey, supplementaryValue " +
						"FROM ctm.content_supplementary cs " +
						"WHERE cs.contentControlId = ? ;"
					);

					stmtSup.setInt(1, content.getId());

					ResultSet resultSetSup = stmtSup.executeQuery();

					content.setSupplementary(new ArrayList<ContentSupplement>());

					while (resultSetSup.next()) {

						ContentSupplement contentSupItem = new ContentSupplement();
						contentSupItem.setContentControlId(resultSetSup.getInt("contentControlId"));
						contentSupItem.setSupplementaryKey(resultSetSup.getString("supplementaryKey"));
						contentSupItem.setSupplementaryValue(resultSetSup.getString("supplementaryValue"));

						content.getSupplementary().add(contentSupItem);

					}
				}
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
		return content;
	}

}
