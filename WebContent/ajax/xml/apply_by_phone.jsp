<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>

<sql:query var="result">
	SELECT type, description FROM general WHERE code = "${param.prod}" and
	                                            type in ("acn","afs")  
	                                            ORDER BY orderSeq
</sql:query>

<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>

	<%-- Build the xml data for each row --%>
	<c:forEach var="row" items="${result.rows}">
		<${row.type}>${row.description}</${row.type}>    	
	</c:forEach>
	
</data>	