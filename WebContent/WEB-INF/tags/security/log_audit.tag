<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<sql:setDataSource dataSource="jdbc/ctm" />

<%-- Inspiration:
	https://www.owasp.org/index.php/Logging_Cheat_Sheet
	http://stackoverflow.com/questions/549/the-definitive-guide-to-form-based-website-authentication#477585
	@example:
	// failed password attempt from invalid token, could include the token used, and a priority should be notice.
	<security:log_audit identity="email@host.com" action="RESET PASSWORD" result="FAIL" description="Invalid Reset Token" metadata="<token>${token}</token>" priority="5" />
--%>

<%-- Priority Codes
	EMERG   = 0;  // Emergency: system is unusable
	ALERT   = 1;  // Alert: action must be taken immediately
	CRIT    = 2;  // Critical: critical conditions
	ERR     = 3;  // Error: error conditions
	WARN    = 4;  // Warning: warning conditions
	NOTICE  = 5;  // Notice: normal but significant condition
	INFO    = 6;  // Informational: informational messages
	DEBUG   = 7;  // Debug: debug messages
--%>
<%@ attribute name="priority" required="false" rtexprvalue="true" description="Priority as an integer {0 emergency ... 7 debug}"%>
	<c:if test="${empty priority}">
		<c:set var="priority" value="6" />
	</c:if>
<%@ attribute name="method" required="false" rtexprvalue="true" description="Whether we're creating a log or looking up entries. Accepted values: log,lookup,loginattempts "%>
	<c:if test="${empty method}">
		<c:set var="method" value="log" />
	</c:if>
<%@ attribute name="identity" required="true" rtexprvalue="true" description="String, user id or email address"%>
<%@ attribute name="action" required="true" rtexprvalue="true" description="What is happening? Currently Available Options: LOG OUT, LOG IN, RESET PASSWORD"%>
<%@ attribute name="result" required="true" rtexprvalue="true" description="What happened? Currently Available Options: SUCCESS, FAIL"%>
<%@ attribute name="description" required="false" rtexprvalue="true" description="A reason as text, e.g. Not Authenticated, Reached Maximum Attempts, Reset Token Expired etc"%>
<%@ attribute name="metadata" required="false" rtexprvalue="true" description="String of XML meta data to store about the particular transaction"%>

<%-- Create a log entry --%>
<c:if test="${method == 'log'}">
	<%-- Add more meta data to the data variable --%>
		<c:set var="qs" value="" />
<%-- 		Can't include query string because it contains passwords when you reset... --%>
<%-- 		<c:if test="${not empty pageContext.request.queryString}"> --%>
<%-- 			<c:set var="qs" value="<qs>${pageContext.request.queryString}</qs>" /> --%>
<%-- 		</c:if> --%>
		<c:set var="serverdata"
			value="<server><ua>${header['User-Agent']}</ua>${qs}</server>" />
		<c:set var="finalData" value="<data>${metadata}${serverdata}</data>" />

	<%-- Import Manifest to grab buildIdentifier --%>
		<c:set var="buildIdentifier"><core:buildIdentifier></core:buildIdentifier></c:set>

	<%-- OWASP recommends never storing session ids unencrypted --%>
		<c:set var="secret_key" value="7T7XVh0U6mJ7JNzcZX1e-2" />
		<c:set var="encryptedSessionId">
			<go:AESEncryptDecrypt action="encrypt" key="${secret_key}"
				content="${pageContext.session.id}" />
		</c:set>

	<%-- Run the log --%>
	<sql:update var="result">
		INSERT INTO `ctm`.`log_audit` (`timestamp`, `priority`, `identity`, `action`, `result`, `description`, `data`, `request_uri`, `app_id`, `session_id`, `ip`)
		VALUES (
			NOW(), 	<%-- timestamp --%>
			?, 		<%-- priority --%>
			?, 		<%-- identity --%>
			?, 		<%-- action --%>
			?, 		<%-- result --%>
			?, 		<%-- description --%>
			?, 		<%-- data --%>
			?, 		<%-- request_uri --%>
			?, 		<%-- app_id --%>
			?, 		<%-- session_id --%>
			? 		<%-- ip --%>
		)
		<sql:param value="${priority}" />
		<sql:param value="${identity}" />
		<sql:param value="${action}" />
		<sql:param value="${result}" />
		<sql:param value="${description}" />
		<sql:param value="${finalData}" />
		<sql:param value="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.requestURI}" />
		<sql:param value="${pageSettings.getBrandCode()}-${buildIdentifier}" />
		<sql:param value="${encryptedSessionId}" />
		<sql:param value="${pageContext.request.remoteAddr}" />
	</sql:update>
</c:if>

<%-- Retrieve a number of login attempts --%>
<c:if test="${method == 'loginattempts'}">
	<sql:query var="result">
		SELECT `id`, `result`, `action`
		FROM `ctm`.`log_audit`
		WHERE `ip` = ?
			<sql:param value="${pageContext.request.remoteAddr}" />
			<c:if test="${not empty identity}" >
						AND `identity` = ?
						<sql:param value="${identity}" />
			</c:if>
			AND `action` IN('LOG IN', 'RESET PASSWORD')
			AND `timestamp` > DATE_SUB(NOW(), INTERVAL 30 MINUTE)
			AND `ip` != '0:0:0:0:0:0:0:1'
			ORDER BY `id` ASC
	</sql:query>

	<c:set var="loginAttempts" value="1" />
	<c:forEach var="row" items="${result.rows}">
		<c:if test="${(row.action == 'LOG IN' && row.result == 'SUCCESS') || (row.action == 'RESET PASSWORD' && row.result == 'SUCCESS')}">
			<c:set var="loginAttempts" value="1" />
		</c:if>
		<c:if test="${row.action == 'LOG IN' && row.result == 'FAIL'}">
			<c:set var="loginAttempts" value="${loginAttempts+1}" />
		</c:if>
	</c:forEach>
	${loginAttempts}
</c:if>

<%-- Retrieve log entries helper function --%>
<c:if test="${method == 'lookup'}">

	<sql:query var="result">
	SELECT * FROM `ctm`.`log_audit`
		WHERE `ip` = ?
			<sql:param value="${pageContext.request.remoteAddr}" />
			<c:if test="${not empty identity}" >
						AND `identity` = ?
						<sql:param value="${identity}" />
			</c:if>
			<c:if test="${not empty action}" >
						AND `action` = ?
						<sql:param value="${action}" />
			</c:if>
			<c:if test="${not empty result}" >
						AND `result` = ?
						<sql:param value="${result}" />
			</c:if>
			AND `ip` != '0:0:0:0:0:0:0:1'
	</sql:query>
	${result}
</c:if>

