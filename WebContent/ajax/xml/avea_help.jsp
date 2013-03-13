<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>

<sql:query var="result">
	SELECT header, des FROM help WHERE id = "${param.id}"
</sql:query>

<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>

	<%-- Build the xml data for each row --%>
	<c:forEach var="row" items="${result.rows}">

		<help header="${row.header}">${fn:escapeXml(row.des)}</help>
    	
	</c:forEach>
	
</data>	

