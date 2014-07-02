<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<sql:query var="result">
	SELECT type, description
	FROM aggregator.general
	WHERE code = ? AND type in ("acn","afs")
	                                            ORDER BY orderSeq
	<sql:param>${param.prod}</sql:param>
</sql:query>

<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>

	<%-- Build the xml data for each row --%>
	<c:forEach var="row" items="${result.rows}">
		<${row.type}>${row.description}</${row.type}>    	
	</c:forEach>
	
</data>