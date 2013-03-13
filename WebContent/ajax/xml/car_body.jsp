<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/test"/>

<sql:query var="result">
	SELECT DISTINCT body FROM vehicles 
		WHERE year='${param.car_year}' 
		AND   make='${param.car_manufacturer}' 
		AND   model='${param.car_model}'
</sql:query>


<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>
	<body value="">Please choose...</body>
	<c:forEach var="row" items="${result.rows}">
		<sql:query var="bodyDes">
			Select code, des from vehicle_body 
			where code= ?
		<sql:param>${row.body}</sql:param>
		</sql:query>
		<c:forEach var="body_row" items="${bodyDes.rows}">
			<body value="${body_row.code}">${body_row.des}</body>
		</c:forEach>
	</c:forEach>
</data>	
