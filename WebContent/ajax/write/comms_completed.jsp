<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:getAuthenticated />

<sql:setDataSource dataSource="jdbc/ctm"/>

<security:populateDataFromParams rootPath="request" />

<c:set var="errors" value="" />

<go:log>
THE PARAMS:
${param}

THE DATA:
${data.request}

COMMSID D? ${data.request['/*/commsId']}
</go:log>


<go:log>
SECURITY:
<sql-query var="result">
	SELECT `commsId` FROM `ctm`.`comms`
	WHERE `commsId` = ?
	AND `owner` = ?;
	<sql-param value="${data.request['/*/commsId']}" />
	<sql-param value="${authenticatedData.login.user.uid}" />
</sql-query>
</go:log>

<%-- SECURITY CHECK --%>
<sql:query var="result">
	SELECT `commsId` FROM `ctm`.`comms`
	WHERE `commsId` = ?
	AND `owner` = ?;
	<sql:param value="${data.request['/*/commsId']}" />
	<sql:param value="${authenticatedData.login.user.uid}" />
</sql:query>


<%-- UPDATE --%>
<c:choose>
	<c:when test="${result.rowCount > 0}">
		<go:log>
			<sql-update var="update">
				UPDATE `ctm`.`comms` SET status = 'c' WHERE `commsId` = ?;
				<sql -param value="${data.request['/*/commsId']}" />
			</sql-update>
		</go:log>

		<c:catch var="error">
			<sql:update var="update">
				UPDATE `ctm`.`comms` SET `status` = 'c' WHERE `commsId` = ?;
				<sql:param value="${data.request['/*/commsId']}" />
			</sql:update>
		</c:catch>

		<%-- CHECK: for errors --%>
		<c:if test="${not empty error}">
			<c:set var="errors">${errors}"error":"DB-Insert: ${update.rootCause}"</c:set>
		</c:if>
	</c:when>
	<c:otherwise>
		<c:set var="errors">${errors}"error":"DB-Check: The user cannot change this message."</c:set>
	</c:otherwise>
</c:choose>



<%-- RESPONSE --%>
<c:choose>
	<c:when test="${not empty errors}">
{ ${errors} }
	</c:when>
	<c:otherwise>
{ "status":"OK" }
	</c:otherwise>
</c:choose>