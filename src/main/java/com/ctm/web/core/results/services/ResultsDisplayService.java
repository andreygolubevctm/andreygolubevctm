package com.ctm.web.core.results.services;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.results.model.ResultsSimpleItem;
import com.ctm.web.core.results.model.ResultsTemplateItem;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.JSONException;
import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ResultsDisplayService {

    private DataSource ds;
    private ArrayList<ResultsTemplateItem> unorganisedList;
    private static Logger LOGGER = LoggerFactory.getLogger(ResultsDisplayService.class);

    public ResultsDisplayService() {
        ds = SimpleDatabaseConnection.getDataSourceJdbcCtm();
    }

    public List<ResultsTemplateItem> getResultsPageStructure(String vertical) throws SQLException {

        Connection conn = null;

        unorganisedList = new ArrayList<>();

        try {
            PreparedStatement stmt;
            conn = ds.getConnection();
            stmt = conn.prepareStatement(
                    "SELECT * " +
                            "FROM aggregator.features_details " +
                            "WHERE vertical = ? AND status = ? " +
                            "ORDER BY parentId;"
            );
            stmt.setString(1, vertical);
            stmt.setString(2, "1");
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
                item.setFlag(result.getInt("flag"));
                item.setGroups(result.getString("groups"));
                item.setCaption(result.getString("caption"));
                item.setDescription(result.getString("description"));
                unorganisedList.add(item);
            }

        } finally {
            if(conn != null) {
                conn.close();
            }
        }

        ArrayList<ResultsTemplateItem> list = new ArrayList<>();
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
                    "SELECT name, resultPath, className " +
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
                item.setClassName(result.getString("className"));
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
        return JSONArray.toJSONString(list);
    }

    public String getPageStructureAsJsonString(String vertical) throws SQLException, JsonProcessingException, JSONException {
        List<ResultsTemplateItem> results = getResultsPageStructure(vertical);
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.writeValueAsString(results);
    }

    public List<ResultsTemplateItem> getResultsTemplateItems(final String vertical) {
        Connection conn = null;

        List<ResultsTemplateItem> list = new ArrayList<ResultsTemplateItem>();

        try {
            PreparedStatement stmt;
            conn = ds.getConnection();
            stmt = conn.prepareStatement(
                    "SELECT * " +
                            "FROM aggregator.features_details " +
                            "WHERE vertical = ? AND shortlistKey IS NOT NULL " +
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
                item.setFlag(result.getInt("flag"));
                list.add(item);
            }
        } catch (SQLException e) {
            LOGGER.error("Error querying feature details", e);
        } finally {
            if(conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.error("Error closing connection", e);
                }
            }
        }

        return list;
    }
}
