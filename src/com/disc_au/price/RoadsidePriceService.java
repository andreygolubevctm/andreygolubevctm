package com.disc_au.price;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.disc_au.web.go.Data;

public class RoadsidePriceService extends PriceService {

	public List<Data> getResults(Integer providerId, String state, String commercial) {
		List<Data> rows = new ArrayList<Data>();
		ResultSet rs = null;
		// Allocate and use a connection from the pool
		Connection conn;
		try {
		conn = getConnection();
		PreparedStatement stmt;
			stmt = conn.prepareStatement("	SELECT " +
					"rr.ProductId as productid, \n" +
					"rr.SequenceNo, " +
					"rr.propertyid, " +
					"rr.value, \n" +
					"b.productCat, " +
					"b.longTitle, " +
					"b.shortTitle, \n" +
					"b.providerId, " +
					"pm.Name as providerName, " +
					"pr.value as premium, \n" +
					"pr.text as premiumText \n" +
					"FROM aggregator.roadside_rates rr " +
					"INNER JOIN aggregator.product_master b on rr.ProductId = b.ProductId \n" +
					"INNER JOIN aggregator.provider_master pm  on pm.providerId = b.providerId \n" +
					"INNER JOIN aggregator.roadside_rates pr on pr.ProductId = rr.ProductId \n" +
					"WHERE b.providerId = ? \n" +
					"AND pr.propertyid = ? \n" +
					"AND ( (rr.propertyid = ?) \n" +
						"OR " +
						"(rr.propertyid = 'commercial' and rr.text LIKE ? ) \n" +
						")" +
					"GROUP BY rr.ProductId, rr.SequenceNo \n" +
					"Having count(*) = 2");
			stmt.setInt(1, providerId);
			stmt.setString(2,state);
			stmt.setString(3, state);
			stmt.setString(4,"%" + commercial + "%");
			rs = stmt.executeQuery();

			convetRStoData(rows, rs);
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return rows;
	}



	public List<Data> getResults(Integer providerId, String state, Integer commercial, String odometer, String year) {
		List<Data> rows = new ArrayList<Data>();
		ResultSet rs = null;
		// Allocate and use a connection from the pool
		Connection conn;
		try {
		conn = getConnection();
		PreparedStatement stmt;
			stmt = conn.prepareStatement("SELECT " +
					"rr.ProductId as productid, " +
					"rr.SequenceNo, " +
					"rr.propertyid, " +
					"rr.value, " +
					"prodm.productCat, " +
					"prodm.longTitle, " +
					"prodm.shortTitle, " +
					"prodm.providerId, " +
					"pm.Name as providerName, \n" +
					"pr.value as premium, \n" +
					"pr.text as premiumText " +
					"FROM aggregator.roadside_rates rr \n" +
					"INNER JOIN aggregator.product_master prodm on rr.ProductId = prodm.ProductId \n" +
					"INNER JOIN aggregator.provider_master pm  on pm.providerId = prodm.providerId \n" +
					"INNER JOIN aggregator.roadside_rates pr on pr.ProductId = rr.ProductId \n" +
					"WHERE prodm.providerId = ? \n" +
					"AND pr.propertyid = ? \n" +
					"AND ( " +
						"(rr.propertyid = ?) \n" +
						"OR " +
						"(rr.propertyid = 'commercial' and rr.value = ? ) \n" +
						"OR " +
						"(rr.propertyid = 'maxKm' and rr.value = ?  ) " +
						"OR " +
						"(rr.propertyid = 'carAgeMax' and rr.value >= (year(CURRENT_TIMESTAMP ) - ?)  ) \n" +
					")" +
					"GROUP BY rr.ProductId, rr.SequenceNo " +
					"Having count(*) = 4");

			System.out.println("SELECT " +
					"rr.ProductId as productid, " +
					"rr.SequenceNo, " +
					"rr.propertyid, " +
					"rr.value, " +
					"prodm.productCat, " +
					"prodm.longTitle, " +
					"prodm.shortTitle, " +
					"prodm.providerId, " +
					"pm.Name as providerName, \n" +
					"pr.value as premium, \n" +
					"pr.text as premiumText " +
					"FROM aggregator.roadside_rates rr \n" +
					"INNER JOIN aggregator.product_master prodm on rr.ProductId = prodm.ProductId \n" +
					"INNER JOIN aggregator.provider_master pm  on pm.providerId = prodm.providerId \n" +
					"INNER JOIN aggregator.roadside_rates pr on pr.ProductId = rr.ProductId \n" +
					"WHERE prodm.providerId = " + providerId + " \n" +
					"AND pr.propertyid = \'" + state + "\' \n" +
					"AND ( " +
						"(rr.propertyid = \'" + state + "\') \n" +
						"OR " +
						"(rr.propertyid = 'commercial' and rr.value = \'" + commercial + "\' ) \n" +
						"OR " +
						"(rr.propertyid = 'maxKm' and rr.value = " + odometer + "  ) " +
						"OR " +
						"(rr.propertyid = 'carAgeMax' and rr.value >= (year(CURRENT_TIMESTAMP ) - " + year + ")  ) \n" +
					")" +
					"GROUP BY rr.ProductId, rr.SequenceNo " +
					"Having count(*) = 4");

			stmt.setInt(1, providerId);
			stmt.setString(2,state);
			stmt.setString(3, state);
			stmt.setInt(4,commercial );

			stmt.setString(5, odometer);
			stmt.setString(6,year);
			rs = stmt.executeQuery();

			convetRStoData(rows, rs);
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return rows;
	}


	public List<Data> getResultsAllProviders(String state, String commercial, String odometer) {
		List<Data> rows = new ArrayList<Data>();
		ResultSet rs = null;
		// Allocate and use a connection from the pool
		Connection conn;
		try {
		conn = getConnection();
		PreparedStatement stmt;
			stmt = conn.prepareStatement("SELECT " +
					"rr.ProductId as as productid, " +
					"rr.SequenceNo, " +
					"rr.propertyid, " +
					"rr.value, " +
					"prodm.productCat, " +
					"prodm.longTitle, " +
					"prodm.shortTitle, " +
					"prodm.providerId, " +
					"pm.Name as providerName, \n" +
					"pr.value as premium, \n" +
					"pr.text as premiumText, \n" +
					"FROM aggregator.roadside_rates rr \n" +
					"INNER JOIN aggregator.product_master prodm on rr.ProductId = prodm.ProductId \n" +
					"INNER JOIN aggregator.provider_master pm  on pm.providerId = prodm.providerId \n" +
					"INNER JOIN aggregator.roadside_rates pr on pr.ProductId = rr.ProductId \n" +
					"AND pr.propertyid = ? \n" +
					"AND ( " +
						"(rr.propertyid = ?) \n" +
						"OR " +
						"(rr.propertyid = 'commercial' and rr.text LIKE ? ) \n" +
						"OR " +
						"(rr.propertyid = 'maxKm' and rr.value = ?  ) " +
					")" +
					"GROUP BY rr.ProductId, rr.SequenceNo " +
					"Having count(*) = 3");
			stmt.setString(2,state);
			stmt.setString(3, state);
			stmt.setString(4,commercial);

			stmt.setString(5, odometer);
			rs = stmt.executeQuery();

			convetRStoData(rows, rs);
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return rows;
	}



	public List<Data> getDetails(String productid) {
		List<Data> rows = new ArrayList<Data>();
		ResultSet rs = null;
		// Allocate and use a connection from the pool
		Connection conn;
		try {
		conn = getConnection();
		PreparedStatement stmt;
			stmt = conn.prepareStatement(
					"SELECT " +
					"b.label, " +
					"b.longlabel, " +
					"a.Value, " +
					"a.propertyid, " +
					"a.Text " +
					"FROM aggregator.roadside_details a " +
					"JOIN aggregator.property_master b on a.propertyid = b.propertyid " +
					"where a.productid = ? " +
					"ORDER BY b.label"
				);
			stmt.setString(1, productid);
			rs = stmt.executeQuery();

			rows = convertDetailsRowsToData(rs);
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return rows;
	}

	protected List<Data> convertDetailsRowsToData(ResultSet rs)
			throws SQLException {
		List<Data> rows = new ArrayList<Data>();
		while (rs.next()) {

			Data data = new Data();
			data.put("productInfo/propertyid", rs.getString("propertyid"));
			data.put("productInfo/label", rs.getString("label"));
			data.put("productInfo/longlabel", rs.getString("longlabel"));
			data.put("productInfo/value", rs.getString("Value"));
			data.put("productInfo/text", rs.getString("text"));
			rows.add(data);
		}
		return rows;
	}

}
