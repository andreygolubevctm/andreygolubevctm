package com.ctm.web.core.dao;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class AuditTableDao {
    public final static String DELETE = "DELETE";
    public final static String CREATE = "CREATE";
    public final static String UPDATE = "UPDATE";
    private final String auditTablePrefix = "audit_";
    private final String loggingSchema = "logging";
	private static final Logger LOGGER = LoggerFactory.getLogger(AuditTableDao.class);

    public AuditTableDao() {
    }

    /**
     * This function audits data into respective audit tables of supplied database tables
     *
     * @param tableName          : Name of the database table where the action has made before calling this function
     * @param primaryColumnName  : Name of the Unique Primary column exist in the table
     * @param primaryColumnValue : Value of the primary key to identify the record
     * @param userName           : Username of the logged in person
     * @param action             : name of the action made on the table AuditTableDao.DELETE , AuditTableDao.CREATE ,AuditTableDao.CREATE
     * @param conn               : Instance of the active connection  and you must have executed any of above action using this connection before calling this method
     * @throws SQLException
     */
    public void auditAction(String tableName, String primaryColumnName, int primaryColumnValue, String userName,String ipAddress, String action, Connection conn) throws SQLException {
        String auditTableName = auditTablePrefix + tableName;
        String auditTableNameWithSchema = loggingSchema + "." + auditTableName;
        try {
            Map<String, String> columnValueMapMainTable = getColumnValueMap(primaryColumnName, primaryColumnValue, tableName, conn);
            final List<String> columnsNameList = getTableColumnNames(auditTableNameWithSchema, conn);
            columnValueMapMainTable = filterMapByListValues(columnValueMapMainTable, columnsNameList);
            int version = getLatestVersionOfRecord(auditTableNameWithSchema, primaryColumnValue, primaryColumnName, conn);
            columnValueMapMainTable.put("userName", userName);
            columnValueMapMainTable.put("action", action);
            columnValueMapMainTable.put("version", version+"");
            columnValueMapMainTable.put("IPAddress", ipAddress);
            PreparedStatement ps = buildSQLStatement(columnValueMapMainTable, auditTableNameWithSchema,conn);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.error("audit action failed to insert into table {}, {}", kv("action", action), kv("auditTableName", auditTableName), e);
            throw e;
        } finally {
            LOGGER.debug("audit action logged to table {}, {}", kv("action", action), kv("auditTableName", auditTableName));
        }
    }

    /**
     * This method get latest version that applies to specific record
     *
     * @param tableName
     * @param primaryColumnValue
     * @param primaryColumnName
     * @param conn
     * @return Integer
     * @throws SQLException
     */
    private int getLatestVersionOfRecord(String tableName, int primaryColumnValue, String primaryColumnName, Connection conn) throws SQLException {
        int version = 1;
        PreparedStatement ps = conn.prepareStatement("select (max(version)+1) " +
                "from " + tableName + " where " + primaryColumnName + "=" + primaryColumnValue);
        ResultSet resultSet = ps.executeQuery();
        while (resultSet.next()) {
            version = resultSet.getInt(1);
        }
        return version == 0 ? 1 : version;
    }

    /**
     * @param primaryColumnName
     * @param primaryColumnValue :
     * @param tableName
     * @param conn
     * @return
     * @throws SQLException
     */
    private Map<String, String> getColumnValueMap(String primaryColumnName, int primaryColumnValue, String tableName, Connection conn) throws SQLException {
        final Map<String, String> columnValueMap = new HashMap<>();
        String columnName, columnValue;
        PreparedStatement ps = conn.prepareStatement("select * from " + tableName + " where " + primaryColumnName + "=" + primaryColumnValue);
        ResultSet resultSet = ps.executeQuery();
        ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
        int totalColumns = resultSetMetaData.getColumnCount();
        while (resultSet.next()) {
            for (int i = 0; i < totalColumns; i++) {
                columnName = resultSetMetaData.getColumnName(i + 1);
                columnValue = resultSet.getString(columnName);
                columnValueMap.put(columnName, columnValue);
            }
        }
        return columnValueMap;
    }

    /**
     * @param tableName
     * @param conn
     * @return
     * @throws SQLException
     */
    private List<String> getTableColumnNames(String tableName, Connection conn) throws SQLException {
        final List<String> columnsNameList = new ArrayList<>();
        String columnName;
        PreparedStatement ps = conn.prepareStatement("select * from " + tableName + " where 1 = 0 ");
        ResultSet resultSet1 = ps.executeQuery();
        ResultSetMetaData resultSet = resultSet1.getMetaData();
        for (int i = 1; i <= resultSet.getColumnCount(); i++) {
            columnName = resultSet.getColumnName(i);
            columnsNameList.add(columnName);
        }
        return columnsNameList;
    }

    /**
     * @param columnValueMap
     * @param columnsNameList
     * @return
     */
    private Map<String, String> filterMapByListValues(Map<String, String> columnValueMap, List<String> columnsNameList) {
        Map<String, String> map = new HashMap<>();
        for (Map.Entry<String, String> pair : columnValueMap.entrySet()) {
            if (columnsNameList.contains(pair.getKey())) {
                map.put(pair.getKey(), pair.getValue());
            }
        }
        return map;
    }

    /**
     * @param columnValueMap
     * @param tableName
     * @param conn
     * @return
     */
    private PreparedStatement buildSQLStatement(Map<String, String> columnValueMap, String tableName,Connection conn) throws SQLException {
        List<String> objectList = new ArrayList<>();
        int count=1,paramCount=1,mapSize=columnValueMap.size();
        StringBuilder sql = new StringBuilder();
        StringBuilder sqlValues = new StringBuilder();
        sql.append("insert into ");
        sql.append(tableName);
        sql.append(" ( ");
        for (Map.Entry<String, String> pair : columnValueMap.entrySet()) {
            sql.append(pair.getKey());
            sqlValues.append("?");
            objectList.add(pair.getValue());
            if(paramCount++ < mapSize) {
                sql.append(",");
                sqlValues.append(",");
            }
        }
        sql.append(" ) values ( ");
        sql.append(sqlValues.toString());
        sql.append(" )");
        PreparedStatement ps = conn.prepareStatement(sql.toString());
        for (String obj : objectList) {
            if(obj == null)
                ps.setNull(count++,Types.NULL);
            else
                ps.setString(count++, obj);
        }
        return ps;
    }
}
