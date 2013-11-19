<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
    
<sql:setDataSource dataSource="jdbc/test"/>

<sql:query var="result">
	SELECT distinct(suburb) as suburb, suburbSeq, state
	FROM streets  
	WHERE postCode = ? and street !='*postbox_only*'
	ORDER BY 1
	<sql:param value="${param.postCode}" />
</sql:query>

<c:set var="searchLen" value="${fn:length(param.search)}" />
{"suburbs":[
<c:forEach var="row" items="${result.rows}" varStatus="status">
	{"des":"${row.suburb}","id":"${row.suburbSeq}"}
	<c:if test="${!status.last}">,</c:if>
	<c:if test="${status.last}">
		<c:set var="stateName" value="${row.state}" />
	</c:if>
</c:forEach>
],
"state":"${stateName}"}