<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="ISO-8859-1" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- description: Get the benefits and extras codes for the health cover situatuation --%>
<sql:query dataSource="jdbc/test" var="result">
	SELECT description FROM `general`
	WHERE type = 'healthSituCvr' AND code = ?
	LIMIT 1
	<sql:param value="${param.situation}" />
</sql:query>

${result.rows[0]['description']}