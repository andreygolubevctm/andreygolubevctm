<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- Build the data using the supplied email address and optionally password  --%>
<c:choose>
	<c:when test="${param.save_password != ''}">
		<c:set var="saveData" value="<data><email>${param.save_email}</email><password>${param.save_password}</password></data>" />
		<c:set var="emailPassword" value="${param.save_password}" />
	</c:when>
	<c:otherwise>
		<c:set var="saveData" value="<data><email>${param.save_email}</email><password>${data['save/password']}</password></data>" />
		<c:set var="emailPassword" value="${data['save/password']}" />
	</c:otherwise>
</c:choose>
<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:if test="${emailPassword != ''}">
	<sql:update>
		UPDATE aggregator.email_master SET emailPword = '${emailPassword}', changeDate = CURRENT_DATE WHERE emailAddress = '${param.save_email}'
	</sql:update>
</c:if>

<sql:query var="result">
	SELECT 
	emailPword
	FROM aggregator.email_master
	WHERE emailPword = '${emailPassword}'
</sql:query>
<%-- if result returned set saveResult to OK--%>
<c:if test="${result.rowCount > 0}">

	<go:call pageId="AGGTSQ" 
				xmlVar="${saveData}"
				transactionId="${data['current/transactionId']}" 
				mode="P"
				resultVar="saveResult"/>
</c:if>


${go:XMLtoJSON(saveResult)}