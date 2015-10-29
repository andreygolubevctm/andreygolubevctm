package com.ctm.web.core.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.model.LogAudit;
import com.ctm.services.confirmation.JoinService;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class LogAuditDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(JoinService.class);

	private SimpleDatabaseConnection dbSource;

	public LogAuditDao() {
		this.dbSource = new SimpleDatabaseConnection();
	}


	public void writeLog(LogAudit logAudit, int priority, String identity, String description, String finalData, String app_id, String session_id) {
		try {
			Connection conn = dbSource.getConnection();
			PreparedStatement stmt = conn.prepareStatement(
				"INSERT INTO `ctm`.`log_audit` (`timestamp`, `priority`, `identity`, `action`, `result`, `description`, `data`, `request_uri`, `app_id`, `session_id`, `ip`)"
				+ "VALUES ( "
				+ "NOW(), " +	/*timestamp */
				"?, " +	/*priority */
				"?, " +	/*identity */
				"?,	" +	/*action */
				"?, " +	/*result */
				"?, " +	/*description */
				"?, " +	/*data */
				"?, " +	/*request_uri */
				"?, " +	/*app_id */
				"?, " +	/*session_id */
				"? 	" +	/*ip */
				")");
			stmt.setInt(1, priority);
			stmt.setString(2, identity);
			String action = null;
			if(logAudit.getAction() != null){
				action  = logAudit.getAction().toString();
			}
			stmt.setString(3, action);
			String resultType = null;
			if(logAudit.getResult() != null){
				resultType = logAudit.getResult().toString();
			}
			stmt.setString(4, resultType);
			stmt.setString(5, description);
			stmt.setString(6, finalData);
			stmt.setString(7, logAudit.getRequestUri());
			stmt.setString(8, app_id);
			stmt.setString(9, session_id);
			stmt.setString(10, logAudit.getIp());
			stmt.executeUpdate();
		} catch (NamingException | SQLException e) {
			LOGGER.error("failed to write log audit entry {}, {}, {}, {}, {}, {}, {}", kv("logAudit", logAudit), kv("priority", priority),
				kv("identity", identity), kv("description", description), kv("finalData", finalData), kv("appId", app_id), kv("sessionId", session_id));
		} finally {
			dbSource.closeConnection();
		}
	}

}
