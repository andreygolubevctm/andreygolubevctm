package com.disc_au.price;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.disc_au.web.go.Data;

public class FeaturesService {
	private DataSource ds;

	public FeaturesService() {
		Context initCtx;
		try {
			initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");
			// Look up our data source
			ds = (DataSource) envCtx.lookup("jdbc/ctm");
		} catch (NamingException e) {
			e.printStackTrace();
		}

	}


	public String getResults(Integer styleCodeId, String category) {
		String results = "";
		ResultSet rs = null;
		// Allocate and use a connection from the pool
		Connection conn = null;
		try {
			conn = ds.getConnection();
			PreparedStatement stmt;
			stmt = conn.prepareStatement(
					"SELECT provm.name as providerName, " +
						" pm.productId, " +
						" pm.shortTitle as shortTitle, " +
						" pm.longTitle as longTitle, " +
						" pp.text as features" +
						" FROM ctm.stylecode_products pm " +
						"	 INNER JOIN ctm.stylecode_providers provm on pm.providerId = provm.providerId  AND pm.styleCodeId = provm.styleCodeId " +
						"    INNER JOIN ctm.product_properties_ext pp on pp.productId = pm.productId " +
						"WHERE pm.styleCodeId=?" +
						"    AND pm.ProductCat=?;");
			stmt.setInt(1,styleCodeId);
			stmt.setString(2,category);
			rs = stmt.executeQuery();

			results = convetRStoXMLString(rs);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if(conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {}
			}
		}
		return results;
	}

	protected String convetRStoXMLString(ResultSet rs)
			throws SQLException {
		StringBuffer sb = new StringBuffer();
		sb.append("<Results>");
		while (rs.next()) {
			Data data = new Data();
			data.put("result/providerName", rs.getString("providerName"));
			data.put("result/productId", rs.getString("productId"));
			data.put("result/shorttitle", rs.getString("shortTitle"));
			data.put("result/longTitle", rs.getString("longTitle"));
			data.put("result/features", rs.getString("features"));
			sb.append(data.getXML(false));
		}
		sb.append("</Results>");
		return sb.toString();
	}
}
