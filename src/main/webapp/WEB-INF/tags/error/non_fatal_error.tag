<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Record non fatal error in database."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('tag.error.non_fatal_error')}" />

<%-- ATTRIBUTES --%>
<%@ attribute name="transactionId" required="false" rtexprvalue="true"  %>

<c:choose>
	<c:when test="${not empty param.transactionId}">
		<session:get settings="true" transactionId="${transactionId}"/>
	</c:when>
	<c:otherwise>
		<settings:setVertical verticalCode="GENERIC" />
		<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />
	</c:otherwise>
</c:choose>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<%@ attribute name="origin" required="true" rtexprvalue="true" description="jsp file" %>
<%@ attribute name="errorCode" required="true" rtexprvalue="true" description="error code" %>
<%@ attribute name="errorMessage" required="true" rtexprvalue="true" description="error message" %>
<%@ attribute name="property" required="false" rtexprvalue="true" description="Optional window title suffix" %>

<c:if test="${empty property}">
	<c:set var="property" value="CTM" />
</c:if>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

${logger.warn('About to log to error_log {},{},{},{}', log:kv('property', property), log:kv('origin',origin), log:kv('errorMessage',errorMessage), log:kv('errorCode',errorCode))}
<c:set var="currentTransactionId" value="${data.current.transactionId}" />
<c:if test="${empty currentTransactionId}">
	<c:set var="currentTransactionId" value="0" />
</c:if>
<sql:update var="result">
	INSERT INTO aggregator.error_log(styleCodeId,`property`,`origin`,`message`,`code`,`transactionId`,`datetime`)
	VALUES(?,?,?,?,?,?,NOW())
	<sql:param value="${styleCodeId}" />
	<sql:param>${property}</sql:param>
	<sql:param>${origin}</sql:param>
	<sql:param>${fn:substring(errorMessage, 0, 255)}</sql:param>
	<sql:param>${errorCode}</sql:param>
	<sql:param>${currentTransactionId}</sql:param>
</sql:update>