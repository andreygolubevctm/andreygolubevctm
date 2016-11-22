package com.ctm.web.core.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import javax.naming.NamingException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Repository
public class VerticalsDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(VerticalsDao.class);

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
				"SELECT verticalId, verticalName, verticalCode, seq " +
				"FROM ctm.vertical_master " +
				"WHERE seq > 0 " +
				"ORDER BY seq;"
			);

			ResultSet verticalResult = stmt.executeQuery();

			while (verticalResult.next()) {
				Vertical vertical = new Vertical();
				vertical.setId(verticalResult.getInt("verticalId"));
				vertical.setType(VerticalType.findByCode(verticalResult.getString("verticalCode") ));
				vertical.setName(verticalResult.getString("verticalName") );
				vertical.setSequence(verticalResult.getInt("seq"));
				verticals.add(vertical);

			}

		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to retrieve verticals", e);
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return verticals;
	}

	/**
	 * Return a vertical base on Code
	 *
	 * @return
	 * @throws DaoException
	 */
	public Vertical getVerticalByCode(String verticalCode) throws DaoException{

		SimpleDatabaseConnection dbSource = null;


		try{

			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT verticalId, verticalName, verticalCode " +
				"FROM ctm.vertical_master v " +
				"WHERE v.verticalCode = ?;"
			);

			stmt.setString(1, verticalCode);

			ResultSet verticalResult = stmt.executeQuery();

			while (verticalResult.next()) {
				Vertical vertical = new Vertical();
				vertical.setId(verticalResult.getInt("verticalId"));
				vertical.setType(VerticalType.findByCode(verticalResult.getString("verticalCode") ));
				vertical.setName(verticalResult.getString("verticalName") );
				return vertical;

			}

		} catch (SQLException | NamingException e) {
			LOGGER.error("Failed to get vertical {}", kv("verticalCode", verticalCode));
			throw new DaoException(e);
		} finally {
			dbSource.closeConnection();
		}

		return null;

	}
}
