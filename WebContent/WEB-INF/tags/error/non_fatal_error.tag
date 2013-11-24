<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Record non fatal error in database."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="origin" required="true" rtexprvalue="true" description="jsp file" %>
<%@ attribute name="errorCode" required="true" rtexprvalue="true" description="error code" %>
<%@ attribute name="errorMessage" required="true" rtexprvalue="true" description="error message" %>
<%@ attribute name="property" required="false" rtexprvalue="true" description="Optional window title suffix" %>

<c:if test="${empty property}">
	<c:set var="property" value="CTM" />
</c:if>

<sql:setDataSource dataSource="jdbc/test"/>

<go:log>
	property: ${property}
	origin: ${origin}
	errorMessage: ${errorMessage}
	errorCode: ${errorCode}
</go:log>

<sql:update var="result">
	INSERT INTO `test`.`error_log`(`property`,`origin`,`message`,`code`,`datetime`)
	VALUES(?,?,?,?,NOW())
	<sql:param>${property}</sql:param>
	<sql:param>${origin}</sql:param>
	<sql:param>${fn:substring(errorMessage, 0, 255)}</sql:param>
	<sql:param>${errorCode}</sql:param>
</sql:update>