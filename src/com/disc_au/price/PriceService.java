package com.disc_au.price;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.disc_au.web.go.Data;

public abstract class PriceService {
	private DataSource ds;

	public PriceService() {
		Context initCtx;
		try {
			initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");
			// Look up our data source
			ds = (DataSource) envCtx.lookup("jdbc/aggregator");
		} catch (NamingException e) {
			e.printStackTrace();
		}

	}

	protected Connection getConnection() {
		Connection conn = null;
		try {
			conn = ds.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return conn;
	}

	protected void convetRStoData(List<Data> rows, ResultSet rs)
			throws SQLException {
		while (rs.next()) {
			Data data = new Data();
			data.put("result/productCat", rs.getString("productCat"));
			data.put("result/productid", rs.getString("productid"));
			data.put("result/provider", rs.getString("providerName"));
			data.put("result/name", rs.getString("shorttitle"));
			data.put("result/des", rs.getString("longtitle"));
			data.put("result/premium", rs.getDouble("premium"));
			data.put("result/premiumText", rs.getString("premiumText"));

			rows.add(data);
		}
	}

	protected List<Data> convertDetailsRowsToData(ResultSet rs)
			throws SQLException {
		List<Data> rows = new ArrayList<Data>();
		while (rs.next()) {

			Data data = new Data();
			data.put("productInfo/propertyid", rs.getString("propertyid"));
			data.put("productInfo/label", rs.getString("label"));
			data.put("productInfo/desc", rs.getString("longlabel"));
			data.put("productInfo/value", rs.getString("Value"));
			data.put("productInfo/text", rs.getString("Text"));
			data.put("productInfo/order", rs.getString("benefitOrder"));
			rows.add(data);
		}
		return rows;
	}
}
