<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/ctm"/>

<sql:query var="result">
	SELECT DISTINCT body
	    FROM aggregator.vehicles
		WHERE year=?
		AND   make=?
		AND   model=?
		<sql:param>${param.car_year}</sql:param>
		<sql:param>${param.car_manufacturer}</sql:param>
		<sql:param>${param.car_model}</sql:param>
</sql:query>


<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>
	<body value="">Please choose...</body>
	<c:forEach var="row" items="${result.rows}">
		<sql:query var="bodyDes">
			SELECT code, des
			    FROM aggregator.vehicle_body
			WHERE code = ?
		<sql:param>${row.body}</sql:param>
		</sql:query>
		<c:forEach var="body_row" items="${bodyDes.rows}">
			<body value="${body_row.code}">${body_row.des}</body>
		</c:forEach>
	</c:forEach>
</data>	
