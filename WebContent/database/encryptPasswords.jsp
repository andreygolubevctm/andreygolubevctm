<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<sql:setDataSource dataSource="jdbc/aggregator" />
<c:set var="totalCount" value="0" />
<c:set var="totalSeconds" value="0" />

<%-- Identify the upper limit, so we don't miss any --%>
<sql:query var="result">
	SELECT count(*) AS `count`
	FROM aggregator.email_master
	WHERE
		`emailPword` IS NOT NULL
		AND `emailPword` != ''
		AND LENGTH(`emailPword`) != 44
</sql:query>
<c:set var="endRows" value="1000" />
<c:if test="${result.rows[0].count > 1}">
	<c:set var="endRows" value="${result.rows[0].count+1000}" />
</c:if>
<go:log source="encryptPassword_jsp" level="INFO">Found ${result.rows[0].count} rows</go:log>
<%-- Loop through email_master rows, 1000 at a time to avoid write locking. --%>
<c:forEach begin="0" end="${endRows}" step="1000" var="i">
	<c:set var="loopCount" value="0" />
	<c:set var="start" value="<%=new java.util.Date().getTime()%>" />

	<%-- Only trying to update CTM brand that has a password, that hasn't already been done. --%>
	<sql:query var="result">
		SELECT * FROM `aggregator`.`email_master`
		WHERE
		`emailPword` IS NOT NULL
		AND `emailPword` != ''
		AND LENGTH(`emailPword`) != 44
		ORDER BY `changeDate` DESC
		LIMIT 1000
	</sql:query>

	<go:log source="encryptPassword_jsp" level="INFO">Found ${result.rowCount} rows in limit 1000</go:log>
	<%-- Run it in a transaction so any problems are rolled back. --%>
	<sql:transaction>
		<c:forEach var="row" items="${result.rows}">
			<c:set var="brand" value = "${row.brand}" />
			<c:if test="${brand != 'CTM'}">
				<c:set var="brand" value = "CTM" />
				<sql:update>
					UPDATE aggregator.email_master
					SET brand = 'CTM'
					WHERE emailId = ?
						<sql:param value="${row.emailId}" />
				</sql:update>
			</c:if>
			<c:set var="new_password">
				<go:HmacSHA256 username="${row.emailAddress}"
					password="${row.emailPword}" brand="${brand}" />
			</c:set>
			<sql:update var="updateCount">
				UPDATE aggregator.email_master
				SET emailPword = ?
				WHERE emailId = ?
					<sql:param value="${new_password}" />
					<sql:param value="${row.emailId}" />
			</sql:update>
			<c:choose>
				<c:when test="${updateCount != 1}">
					<go:log source="encryptPassword_jsp" level="WARN">Tried to Update ${updateCount} rows for ${row.emailAddress}.</go:log>
				</c:when>
				<c:otherwise>
					<c:set var="loopCount" value="${loopCount+1}" />
				</c:otherwise>
			</c:choose>
		</c:forEach>

		<c:set var="end" value="<%=new java.util.Date().getTime()%>" />
		<c:set var="loopSeconds" value="${(end-start)/1000}" />
		<c:set var="totalSeconds" value="${totalSeconds + loopSeconds}" />
		<c:set var="totalCount" value="${totalCount + loopCount}" />
		<c:if test="${loopCount > 0}">
			<go:log source="encryptPassword_jsp" level="INFO">Updated ${loopCount} rows in ${loopSeconds} seconds.</go:log>
		</c:if>
	</sql:transaction>
	<%-- to reduce load on the server. --%>
	<% Thread.sleep(5000); %>
</c:forEach>
<p>Completed: Updated ${totalCount} rows in ${totalSeconds} seconds. See Log for Details.</p>
<go:log source="encryptPassword_jsp" level="INFO">Completed: Updated ${totalCount} rows in ${totalSeconds} seconds.</go:log>