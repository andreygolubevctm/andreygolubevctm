package com.ctm.services.results;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.json.simple.JSONArray;

import com.ctm.model.results.ResultsSimpleItem;
import com.ctm.model.results.ResultsTemplateItem;

public class ResultsService {

	private DataSource ds;
	private ArrayList<ResultsTemplateItem> unorganisedList;

	public ResultsService() {
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

	public List<ResultsTemplateItem> getResultsPageStructure(String vertical) throws SQLException {

		Connection conn = null;

		unorganisedList = new ArrayList<ResultsTemplateItem>();

		try{
			PreparedStatement stmt;
			conn = ds.getConnection();
			stmt = conn.prepareStatement(
				"SELECT * " +
				"FROM aggregator.features_details " +
				"WHERE vertical = ?" +
				"ORDER BY parentId;"
			);

			stmt.setString(1, vertical);
			ResultSet result = stmt.executeQuery();

			while (result.next()) {

				ResultsTemplateItem item = new ResultsTemplateItem();
				item.setId(result.getInt("id"));
				item.setName(result.getString("name"));
				item.setType(result.getString("type"));
				item.setStatus(result.getBoolean("status"));
				item.setSequence(result.getInt("sequence"));
				item.setParentId(result.getInt("parentId"));
				item.setResultPath(result.getString("resultPath"));
				item.setVertical(result.getString("vertical"));
				item.setClassName(result.getString("className"));
				item.setExtraText(result.getString("extraText"));
				item.setMultiRow(result.getBoolean("multiRow"));
				item.setExpanded(result.getBoolean("expanded"));
				item.setHelpId(result.getInt("helpId"));
				item.setShortlistKey(result.getString("shortlistKey"));
				unorganisedList.add(item);

			}

		} finally {
			if(conn != null) {
				conn.close();
			}
		}

		ArrayList<ResultsTemplateItem> list = new ArrayList<ResultsTemplateItem>();
		list = findItemInList(0); // start at top level (0) and work recursively through the data.
		Collections.sort(list);

		return list;
	}

	public ArrayList<ResultsTemplateItem> findItemInList(Number parentId){

		ArrayList<ResultsTemplateItem> returns = new ArrayList<ResultsTemplateItem>();

		for (ResultsTemplateItem item : unorganisedList) {
			if(item.getParentId().equals(parentId)){
				returns.add(item);
			}
		}

		// remove found items.
		unorganisedList.removeAll(returns);

		// look for children of found items
		for (ResultsTemplateItem item : returns) {
			ArrayList<ResultsTemplateItem> children = findItemInList(item.getId());
			Collections.sort(children);
			item.setChildren(children);
		}

		return returns;
	}

	public List<ResultsSimpleItem> getResultItemsAsList(String vertical, String type) throws SQLException {

		Connection conn = null;

		ArrayList<ResultsSimpleItem> list = new ArrayList<ResultsSimpleItem>();

		try{
			PreparedStatement stmt;
			conn = ds.getConnection();
			stmt = conn.prepareStatement(
				"SELECT name, resultPath " +
				"FROM aggregator.features_details " +
				"WHERE vertical = ? AND type = ? " +
				"ORDER BY parentId;"
			);

			stmt.setString(1, vertical);
			stmt.setString(2, type);
			ResultSet result = stmt.executeQuery();

			while (result.next()) {

				ResultsSimpleItem item = new ResultsSimpleItem();
				item.setName(result.getString("name"));
				item.setResultPath(result.getString("resultPath"));
				list.add(item);

			}

		} finally {
			if(conn != null) {
				conn.close();
			}
		}

		return list;
	}

	public String getResultItemsAsJsonString(String vertical, String type) throws SQLException {
		List<ResultsSimpleItem> list = getResultItemsAsList(vertical, type);
		System.out.println(JSONArray.toJSONString(list));
		return JSONArray.toJSONString(list);
	}

}
