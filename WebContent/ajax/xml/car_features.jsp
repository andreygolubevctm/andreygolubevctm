<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/ctm"/>

<sql:query var="alarm">
	SELECT code
		FROM aggregator.vehicle_accessories
		WHERE redbookCode = ? AND type = 'S'
			AND des LIKE ('%alarm%')
		LIMIT 1;
	<sql:param>${param.redbookCode}</sql:param>
</sql:query>

<sql:query var="immobiliser">
	SELECT code
		FROM aggregator.vehicle_accessories
		WHERE redbookCode = ? AND type = 'S'
			AND des LIKE ('%immobil%')
		LIMIT 1;
	<sql:param>${param.redbookCode}</sql:param>
</sql:query>

<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>

	<%-- Build the xml data for each row --%>
<features>
	<c:forEach var="row" items="${alarm.rows}">
		<alarm>${fn:escapeXml(row.code)}</alarm>
	</c:forEach>
	<c:forEach var="row" items="${immobiliser.rows}">
		<immobiliser>${fn:escapeXml(row.code)}</immobiliser>
	</c:forEach>
</features>
</data>
