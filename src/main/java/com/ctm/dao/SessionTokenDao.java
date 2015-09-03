package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.session.SessionToken;
import com.mysql.jdbc.Statement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static com.ctm.logging.LoggingArguments.kv;


public class SessionTokenDao {
	private static final Logger logger = LoggerFactory.getLogger(SessionTokenDao.class);

	public SessionTokenDao(){

	}

	/**
	 * Returns a session token object for the matching encoded token string.
	 * Tokens are either for LDAP users (simples) or for Email master table - used for forgot password.
	 * To return a token, the token must not be consumed before and must have been created less than 30 minutes ago.
	 *
	 * @param token
	 * @param identityType
	 * @return
	 */
	public SessionToken getToken(String token, SessionToken.IdentityType identityType) throws DaoException{

		SessionToken sessionToken = null;
		SimpleDatabaseConnection dbSource = null;

		try{

			dbSource = new SimpleDatabaseConnection();

			PreparedStatement stmt = null;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT sessionTokenId, identity, token " +
				"FROM ctm.session_tokens " +
				"WHERE token = ? AND " +
					"identityType = ? AND " +
					"timestamp > DATE_SUB(NOW(), INTERVAL 30 MINUTE) AND " +
					"consumed = 0 ;"
			);
			stmt.setString(1, token);
			stmt.setString(2, identityType.toString());

			ResultSet resultSet = stmt.executeQuery();

			if(resultSet.next() != false){
				sessionToken = new SessionToken();
				sessionToken.setId(resultSet.getInt("sessionTokenId"));
				sessionToken.setIdentity(resultSet.getString("identity"));
				sessionToken.setToken(resultSet.getString("token"));
				sessionToken.setIdentityType(identityType);

				return sessionToken;
			}

		} catch (SQLException | NamingException e) {
			logger.error("Failed to get session token {}, {}", kv("token", token), kv("identityType", identityType));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return sessionToken;
	}

	/**
	 * Mark this SessionToken as consumed.
	 *
	 * @param token
	 */
	public void consumeToken(SessionToken token) throws DaoException{
		SimpleDatabaseConnection dbSource = null;

		try{

			dbSource = new SimpleDatabaseConnection();

			PreparedStatement stmt = null;

			stmt = dbSource.getConnection().prepareStatement(
				"UPDATE ctm.session_tokens " +
				"SET consumed = 1 " +
				"WHERE sessionTokenId = ? ;"
			);

			stmt.setInt(1, token.getId());
			stmt.executeUpdate();

		} catch (SQLException | NamingException e) {
			logger.error("Failed marking session token as consumed {}", kv("token", token));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

	}

	/**
	 * Save a new token to the database.
	 *
	 * @param sessionToken
	 * @return
	 */
	public SessionToken addToken(SessionToken sessionToken) throws DaoException{
		SimpleDatabaseConnection dbSource = null;

		try{

			dbSource = new SimpleDatabaseConnection();

			PreparedStatement stmt = null;

			stmt = dbSource.getConnection().prepareStatement(
				"INSERT INTO ctm.session_tokens " +
				"(token, identityType, identity, timestamp)" +
				"VALUES" +
				"(?, ?, ?, NOW());", Statement.RETURN_GENERATED_KEYS
			);

			stmt.setString(1, sessionToken.getToken());
			stmt.setString(2, sessionToken.getIdentityType().toString());
			stmt.setString(3, sessionToken.getIdentity());

			stmt.executeUpdate();

			ResultSet rs = stmt.getGeneratedKeys();
			if (rs.next()){
				sessionToken.setId(rs.getInt(1));
				return sessionToken;
			}

		} catch (SQLException | NamingException e) {
			logger.error("Failed saving session token to database {}", kv("token", sessionToken));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return null;

	}
}
