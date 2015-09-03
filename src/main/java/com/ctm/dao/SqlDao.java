package com.ctm.dao;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.NamingException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.logging.LoggingArguments.kv;

public class SqlDao<T> {
	
	private static final Logger logger = LoggerFactory.getLogger(SqlDao.class.getName());
	
	private final SimpleDatabaseConnection databaseConnection;
	private final String context;
	private PreparedStatement stmt;
	private Connection conn;
    private boolean autoCommit;

    public SqlDao() {
		databaseConnection = SimpleDatabaseConnection.getInstance();
		this.context = "jdbc/ctm";
	}


    /**
     * Run a sequence of updates in a single transaction
     * If any transactions fail all transactions will be rolled back
     * @param databaseMappings chain of updates to call
     * @throws DaoException updates will have rolled back
     */
    public void updateChain(List<DatabaseUpdateMapping> databaseMappings) throws DaoException {
        // Run update for each mapping
        for(DatabaseUpdateMapping databaseMapping :  databaseMappings){
            updateAsPartOfTransaction(databaseMapping);
        }
        // No exceptions have occurred so commit transaction
        commitTransaction();
    }

    /**
     * IMPORTANT: this will leave an open connection so it is very important to call either commitTransaction() or rollback()
     * When the transaction is complete
     * call commitTransaction() after all transactions have been completed successfully
     * call rollback() to roll back if issues occur exceptions in this method will autmatically rollback
     * @param databaseMapping
     * @throws DaoException
     */
    public void updateAsPartOfTransaction(DatabaseUpdateMapping databaseMapping) throws DaoException {
        try {
            if(conn == null || conn.isClosed()) {
                startTransaction();
            }
            stmt = conn.prepareStatement(databaseMapping.getStatement());
            databaseMapping.handleParams(stmt);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            rollback();
            logger.error("DB transaction update failed {}", kv("statement", databaseMapping.getStatement()), e);
            throw new DaoException("Error when performing update" , e);
        }
    }

    /**
     * Call this after updateAsPartOfTransaction
     */
    public void commitTransaction() throws DaoException {
        try {
            conn.commit();
        } catch (SQLException e) {
            throw new DaoException("DB transaction commit failed" , e);
        }
        cleanup(autoCommit);
    }

    /**
     * Call this after updateAsPartOfTransaction if commitTransaction() has not been called and you want to roll back changes
     */
    public void rollback() throws DaoException {
        try {
            if(conn != null){
                conn.rollback();
            }
        } catch (SQLException e) {
            throw new DaoException("DB transaction rollback failed", e);
        }
        cleanup(autoCommit);
    }

    public int update(DatabaseUpdateMapping databaseMapping) throws DaoException {
        final String statement = databaseMapping.getStatement();
        try {
			conn = databaseConnection.getConnection(context, true);
			stmt = conn.prepareStatement(statement);
			databaseMapping.handleParams(stmt);
			return stmt.executeUpdate();
		} catch (SQLException | NamingException e) {
			logger.error("DB update failed {}", kv("statement", statement), e);
			throw new DaoException(e);
		} finally {
			cleanup();
		}
	}

    /**
     * Method to handle some of the JDBC logic
     * @param databaseMapping logic to handle setting params and retrieving results
     * @param sql select statement
     * @return T a model from the database which is mapped in databaseMapping
     * @throws DaoException a wrapper of SQLException and NamingException
     */
	public T get(DatabaseQueryMapping<T> databaseMapping, String sql) throws DaoException {
		long startTime = System.currentTimeMillis();
		T value = null;
		try {
			ResultSet rs = executeQuery(databaseMapping, sql);
			while (rs.next()) {
				value = databaseMapping.handleResult(rs);
			}
			rs.close();
		} catch (SQLException  e) {
			logger.error("DB query failed {]", kv("sql", sql), e);
			throw new DaoException(e);
		} finally {
			cleanup();
		}
		logger.debug("DB query total execution time {}ms", kv("queryTime", System.currentTimeMillis()-startTime));
		return value;
	}

	public List<T> getList(DatabaseQueryMapping<T> databaseMapping, String sql) throws DaoException {
		List<T>  list = new ArrayList<>();
		try {
			ResultSet rs = executeQuery(databaseMapping, sql);
			while (rs.next()) {
				list.add(databaseMapping.handleResult(rs));
			}
			rs.close();
		} catch (SQLException  e) {
			logger.error("DB query as list failed {}", kv("sql", sql), e);
			throw new DaoException(e);
		} finally {
			cleanup();
		}
		return list;
	}

	public void update(String sql) throws DaoException {
		try {
			Connection conn = databaseConnection.getConnection(context);
			stmt = conn.prepareStatement(sql);
			stmt.executeUpdate();
		} catch (SQLException | NamingException e) {
			logger.error("DB update query failed {}", kv("sql", sql), e);
			throw new DaoException(e);
		} finally {
			cleanup();
        }
	}

    private void cleanup() {
        databaseConnection.closeConnection(conn, stmt);
    }

    private void cleanup(boolean autocommit) {
        try {
            if(conn != null && !conn.isClosed()) {
                conn.setAutoCommit(autocommit);
            }
        } catch (SQLException e) {
            logger.error("DB connection cleanup failed {}", kv("autocommit", autocommit), e);
        }
        cleanup();
    }


    private void startTransaction() throws SQLException, NamingException {
        conn = databaseConnection.getConnection(context, true);
        autoCommit = conn.getAutoCommit();
        conn.setAutoCommit(false);
    }

    private ResultSet executeQuery(DatabaseQueryMapping<T> databaseMapping,
                                   String sql) throws DaoException {
        try {
            conn = databaseConnection.getConnection(context, true);
            stmt = conn.prepareStatement(sql);
            databaseMapping.handleParams(stmt);
            return stmt.executeQuery();
        } catch (SQLException | NamingException e) {
            throw new DaoException(e);
        }
    }

    /**
     * clean up any outstanding connections developer note there really shouldn't be any open connections
     */
    @Override
    protected void finalize() throws Throwable {
        boolean doCleanUp = false;
        try {
            if(conn != null && !conn.isClosed()) {
                logger.error("DB connection was not closed. Manually closing now");
                doCleanUp = true;
            }
            if(stmt != null && !stmt.isClosed()) {
                logger.error("DB Statement was not closed. Manually closing now");
                doCleanUp = true;
            }
        } catch (SQLException e) {}
        if(doCleanUp) {
            cleanup(autoCommit);
        }
        super.finalize();
    }

    public T getAll(DatabaseQueryMapping<T> databaseMapping, String sql) throws DaoException {
        long startTime = System.currentTimeMillis();
        T value = null;
        try {
            ResultSet rs = executeQuery(databaseMapping, sql);
            value = databaseMapping.handleResult(rs);
            rs.close();
        } catch (SQLException  e) {
            logger.error("DB get all query failed {}", kv("sql", sql), e);
            throw new DaoException(e);
        } finally {
            cleanup();
        }
        logger.debug("DB query total execution time {}ms", kv("queryTime", System.currentTimeMillis() - startTime));
        return value;
    }

    /**
     * This function will execute update/create/delete statement and also
     * create audit record in respective audit table in logging schema.
     * @param databaseMapping
     * @param sql
     * @param userName
     * @param ipAddress
     * @param action
     * @param tableName
     * @param primaryColumnName
     * @param primaryColumnValue : must be present while updating and deleting record , can be 0 for create
     * @return
     * @throws DaoException
     */
    public int executeUpdateAudit(DatabaseUpdateMapping databaseMapping,
                                  String sql,
                                  String userName,
                                  String ipAddress,
                                  String action,
                                  String tableName,
                                  String primaryColumnName,
                                  int primaryColumnValue) throws DaoException {
        AuditTableDao auditTableDao = new AuditTableDao();
        try {
            int id=primaryColumnValue;
            ResultSet selectResultSet ;
            conn = databaseConnection.getConnection(context);
            autoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            //if action is delete log audit history before record gets deleted
            if(action.equalsIgnoreCase(AuditTableDao.DELETE)){
                auditTableDao.auditAction(tableName,primaryColumnName,id,userName,ipAddress,action,conn);
            }
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            databaseMapping.handleParams(stmt);
            stmt.executeUpdate();
            if(action.equalsIgnoreCase(AuditTableDao.CREATE)){
                selectResultSet = stmt.getGeneratedKeys();
                if(selectResultSet.next()) {
                    id = selectResultSet.getInt(1);
                }
            }
            if(!action.equalsIgnoreCase(AuditTableDao.DELETE)) {
                auditTableDao.auditAction(tableName, primaryColumnName, id, userName, ipAddress, action, conn);
            }
            commitTransaction();
            return id;
        } catch (Exception e) {
            rollback();
            logger.error("DB update and audit failed {}", kv("action", action), e);
            throw new DaoException(e);
        }finally {
            try {
                finalize();
            }catch (Throwable throwable) {
                throw new DaoException(throwable);
            }
        }
    }

    public int[] executeBatch(List<DatabaseUpdateMapping> databaseMappings, String statement) throws DaoException {
        try {
            stmt = conn.prepareStatement(statement);
            for (DatabaseUpdateMapping databaseMapping : databaseMappings) {
                conn = databaseConnection.getConnection(context, true);
                databaseMapping.handleParams(stmt);
                stmt.addBatch();
            }
            return stmt.executeBatch();
        } catch (SQLException | NamingException e) {
                logger.error("DB batch update failed {}", kv("statement", statement), e);
                throw new DaoException(e);
        } finally {
            cleanup();
        }
    }
}
