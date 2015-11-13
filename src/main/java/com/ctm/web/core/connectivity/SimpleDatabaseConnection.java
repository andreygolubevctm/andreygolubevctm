package com.ctm.web.core.connectivity;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import static com.ctm.web.core.logging.LoggingArguments.kv;

@Component
public class SimpleDatabaseConnection implements AutoCloseable, InitializingBean {

    private static final Logger LOGGER = LoggerFactory.getLogger(SimpleDatabaseConnection.class);

    public static final String JDBC_CTM = "jdbc/ctm";

    private Connection connection;

    @Autowired
    private DataSource dataSourceJdbcCtmInstance;

    private static DataSource dataSourceJdbcCtm;

    private static SimpleDatabaseConnection instance;

    public SimpleDatabaseConnection() {

    }

    public static SimpleDatabaseConnection getInstance() {
        if (instance == null) {
            instance = new SimpleDatabaseConnection();
        }
        return instance;
    }

    public Connection getConnection() throws SQLException, NamingException {
        return getConnection(JDBC_CTM);
    }

    public Connection getConnection(boolean fresh) throws SQLException, NamingException {
        return getConnection(JDBC_CTM, fresh);
    }

    public Connection getConnection(String context) throws SQLException, NamingException {
        return getConnection(context, false);
    }

    public Connection getConnection(String context, boolean fresh) throws SQLException, NamingException {
        LOGGER.trace("Calling getConnection({},{})", kv("context", context), kv("fresh", fresh));
        Connection conn = null;
        if (context.equals(JDBC_CTM)) {
            if (fresh) {
                return dataSourceJdbcCtm.getConnection();
            } else {
                if (connection == null || connection.isClosed()) {
                    setConnection(dataSourceJdbcCtm.getConnection());
                }
                conn = connection;
            }
        }
        return conn;
    }

    @Override
    public void close() throws Exception {
        closeConnection();
    }

    public void closeConnection() {
        try {
            if (this.connection != null && !this.connection.isClosed()) {
                this.connection.close();
            }
        } catch (SQLException e) {
            LOGGER.error("Failed to close db connection", e);
        }
    }

    public void closeConnection(Connection connection, Statement statement) {
        closeStatement(statement);
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            LOGGER.error("Failed to close db connection", e);
        }
    }

    public void closeStatement(Statement statement) {
        try {
            if (statement != null && !statement.isClosed()) {
                statement.close();
            }
        } catch (SQLException e) {
            LOGGER.error("Failed to close statement", e);
        }
    }

    private void setConnection(Connection connection) {
        this.connection = connection;
    }

    public static String createSqlArrayParams(int numParams) {
        StringBuilder sb = new StringBuilder();
        if (numParams <= 0) return sb.toString();
        for (int i = 0; i < numParams - 1; i++) {
            sb.append("?,");
        }
        sb.append("?");
        return sb.toString();
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        dataSourceJdbcCtm = dataSourceJdbcCtmInstance;
    }

    public static DataSource getDataSourceJdbcCtm() {
        return dataSourceJdbcCtm;
    }
}
