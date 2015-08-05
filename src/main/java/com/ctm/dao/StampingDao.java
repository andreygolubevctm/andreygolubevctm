package com.ctm.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Stamping;

public class StampingDao {

	private int styleCodeId;
	private String brand;
	private String vertical;
	private SimpleDatabaseConnection dbSource;

	public StampingDao(int styleCodeId,String brand,String vertical) {
		this.styleCodeId = styleCodeId;
		this.brand = brand;
		this.vertical = vertical;
		dbSource = new SimpleDatabaseConnection();
	}

	public StampingDao() {
		dbSource = new SimpleDatabaseConnection();
	}

	@SuppressWarnings("unused")
	private static Logger logger = Logger.getLogger(StampingDao.class.getName());

	public void add(Stamping stamping) throws DaoException {
		try {
			PreparedStatement stmt;
			Connection conn = dbSource.getConnection();
			if(conn != null) {
				stmt = conn.prepareStatement(
					"INSERT INTO ctm.stamping (styleCodeId,action,brand,vertical,target,value,operatorId,comment,datetime,IpAddress) " +
					"VALUES (?,?,?,?,?,?,?,?,NOW(),?);"
				);
				stmt.setInt(1, stamping.getStyleCodeId());
				stmt.setString(2, stamping.getAction());
				stmt.setString(3, stamping.getBrand());
				stmt.setString(4, stamping.getVertical());
				stmt.setString(5, stamping.getTarget());
				stmt.setString(6, stamping.getValue());
				stmt.setString(7, stamping.getOperatorId());
				stmt.setString(8, stamping.getComment());
				stmt.setString(9, stamping.getIpAddress());

				stmt.executeUpdate();
		}
		} catch (SQLException e) {
			throw new DaoException(e.getMessage(), e);
		} catch (NamingException e) {
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}
	}

	public Stamping add(String action, String target, String value, String operatorId, String comment, String ipAddress) throws DaoException {
		Stamping stamping = new Stamping();
		stamping.setStyleCodeId(styleCodeId);
		stamping.setAction(action);
		stamping.setBrand(brand);
		stamping.setVertical(vertical);
		stamping.setTarget(target);
		stamping.setValue(value);
		stamping.setOperatorId(operatorId);
		stamping.setComment(comment);
		stamping.setIpAddress(ipAddress);
		add(stamping);
		return stamping;

	}

}
