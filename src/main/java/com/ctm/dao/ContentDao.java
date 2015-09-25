package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import javax.naming.NamingException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.content.Content;
import com.ctm.model.content.ContentProvider;
import com.ctm.model.content.ContentSupplement;

import static com.ctm.logging.LoggingArguments.kv;

public class ContentDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(ContentDao.class);
	private int brandId;
	private int verticalId;

	public ContentDao(){

	}

	public ContentDao(int brandId, int verticalId){
		this.brandId = brandId;
		this.verticalId = verticalId;
	}

	/**
	 * Queries the content_control table. Must provide key and the effective date to return content.
	 * Multiple keys can be stored in the DB with different date ranges.
	 * Supplementary content is additional key/value paired data linked to a single content item.
	 *
	 * @param contentKey
	 * @param effectiveDate
	 * @param includeSupplementary
	 * @return
	 */
	public Content getByKey(String contentKey, Date effectiveDate, boolean includeSupplementary) throws DaoException{
		return getByKey(contentKey, this.brandId, this.verticalId, effectiveDate, includeSupplementary);
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
	public Content getByKey(String contentKey, int brandId, int verticalId, Date effectiveDate, boolean includeSupplementary) throws DaoException{

		SimpleDatabaseConnection dbSource = null;
		Content content = null;

		try{
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT contentControlId, styleCodeId, contentKey, contentCode, contentValue, effectiveStart, effectiveEnd " +
				"FROM ctm.content_control cc " +
				"WHERE cc.contentKey = ? " +
					"AND (styleCodeId = ? OR styleCodeId = 0) " +
					"AND (verticalId = ? OR verticalId = 0) " +
					"AND ? Between cc.effectiveStart AND cc.effectiveEnd " +
				"ORDER BY styleCodeId desc, verticalId desc " +
				"LIMIT 1;"
			);

			stmt.setString(1, contentKey);
			stmt.setInt(2, brandId);
			stmt.setInt(3, verticalId);
			stmt.setTimestamp(4, new java.sql.Timestamp(effectiveDate.getTime()));

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

			if(contents.size() == 0){
				LOGGER.debug("Content key not found. Defaulting to empty string. {}", kv("contentKey", contentKey));
			}else{
				if(contents.size() > 1){
					LOGGER.warn("More than one content value found. Will use the first one found. {}", kv("contentKey", contentKey));
				}

				content = contents.get(0);

				if(includeSupplementary){
					PreparedStatement stmtSup = dbSource.getConnection().prepareStatement(
						"SELECT contentControlId, supplementaryKey, supplementaryValue " +
						"FROM ctm.content_supplementary cs " +
						"WHERE cs.contentControlId = ? ;"
					);

					stmtSup.setInt(1, content.getId());

					ResultSet resultSetSup = stmtSup.executeQuery();

					content.setSupplementary(new ArrayList<>());

					while (resultSetSup.next()) {

						ContentSupplement contentSupItem = new ContentSupplement();
						contentSupItem.setContentControlId(resultSetSup.getInt("contentControlId"));
						contentSupItem.setSupplementaryKey(resultSetSup.getString("supplementaryKey"));
						contentSupItem.setSupplementaryValue(resultSetSup.getString("supplementaryValue"));

						content.getSupplementary().add(contentSupItem);

					}
				}
			}

		} catch (SQLException | NamingException e) {
			LOGGER.error("failed getting content {}", kv("contentKey", contentKey), e);
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}
		return content;
	}

	/**
	 * Queries the content_control table. Must provide key, providerId, the brand and the effective date to return content.
	 *
	 * This method supports duplicate keys and returns a list of matching items (conversely, the getByKey function only supports one key).
	 * This method supports specific content for a brand, or generic content for all brands by settings brandId to 0 in the DB.
	 * Keys can be enabled for different date ranges.
	 * Supplementary content is additional key/value paired data linked to a single content item.
	 *
	 * @param contentKey
	 * @param providerId
	 * @param brandId
	 * @param effectiveDate
	 * @param includeSupplementary
	 * @return
	 * @throws DaoException
	 */
	public ArrayList<Content> getMultipleByKeyAndProvider(String contentKey, int providerId, int brandId, Date effectiveDate, boolean includeSupplementary) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		ArrayList<Content> contents = new ArrayList<Content>();

		try{
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT cc.contentControlId as contentControlId, styleCodeId, contentKey, contentCode, contentValue, effectiveStart, effectiveEnd, providerId " +
				"FROM ctm.content_control cc " +
					"INNER JOIN ctm.content_control_provider p " +
					"ON cc.contentControlId = p.contentControlId " +
				"WHERE cc.contentKey = ? " +
					"AND (cc.styleCodeId = ? OR cc.styleCodeId = 0) " +
					"AND p.providerId = ? " +
					"AND ? Between cc.effectiveStart AND cc.effectiveEnd; "
			);

			stmt.setString(1, contentKey);
			stmt.setInt(2, brandId);
			stmt.setInt(3, providerId);
			stmt.setTimestamp(4, new java.sql.Timestamp(effectiveDate.getTime()));

			ResultSet resultSet = stmt.executeQuery();

			ArrayList<Integer> contentIds = new ArrayList<Integer>();

			while (resultSet.next()) {

				Content contentItem = new Content();
				contentItem.setId(resultSet.getInt("contentControlId"));
				contentItem.setStyleCodeId(resultSet.getInt("styleCodeId"));
				contentItem.setContentKey(resultSet.getString("contentKey"));
				contentItem.setContentCode(resultSet.getString("contentCode"));
				contentItem.setContentValue(resultSet.getString("contentValue"));
				contentItem.setEffectiveStart(resultSet.getDate("effectiveStart"));
				contentItem.setEffectiveEnd(resultSet.getDate("effectiveEnd"));

				ContentProvider provider = new ContentProvider();
				provider.setProviderId(resultSet.getInt("providerId"));
				contentItem.setProvider(provider);

				contentItem.setSupplementary(new ArrayList<>());

				contentIds.add(contentItem.getId());

				contents.add(contentItem);

			}

			if(contents.size() == 0){
				LOGGER.debug("no content found {}, {}", kv("contentKey", contentKey), kv("providerId", providerId));
			} else {
				if(includeSupplementary){

					PreparedStatement stmtSup = dbSource.getConnection().prepareStatement(
						"SELECT cs.contentControlId as contentControlId, supplementaryKey, supplementaryValue " +
						"FROM ctm.content_supplementary cs " +
							"INNER JOIN ctm.content_control_provider p " +
							"ON cs.contentControlId = p.contentControlId " +
						"WHERE cs.contentControlId IN ("+ SimpleDatabaseConnection.createSqlArrayParams(contentIds.size()) + ") ;"
					);

					int counter = 1;
					for(int contentId: contentIds){
						stmtSup.setInt(counter, contentId);
						counter++;
					}

					ResultSet resultSetSup = stmtSup.executeQuery();

					while (resultSetSup.next()) {

						ContentSupplement contentSupItem = new ContentSupplement();
						contentSupItem.setContentControlId(resultSetSup.getInt("contentControlId"));
						contentSupItem.setSupplementaryKey(resultSetSup.getString("supplementaryKey"));
						contentSupItem.setSupplementaryValue(resultSetSup.getString("supplementaryValue"));

						contents.stream().filter(contentItem -> contentItem.getId() == contentSupItem.getContentControlId()).forEach(contentItem -> {
							contentItem.getSupplementary().add(contentSupItem);
						});
					}
				}

			}

		} catch (SQLException | NamingException e) {
			LOGGER.error("failed getting content {}", kv("contentKey", contentKey), e);
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return contents;

	}


}
