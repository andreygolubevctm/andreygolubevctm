<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="GENERIC" />
<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<sql:query var="result">
	SELECT header, des
	FROM aggregator.help
	WHERE id = ?
		AND (styleCodeId = ? OR stylecodeid = 0)
	ORDER BY id, styleCodeId desc
	LIMIT 1
	<sql:param>${param.id}</sql:param>
	<sql:param>${styleCodeId}</sql:param>
</sql:query>

<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>

	<%-- Build the xml data for each row --%>
	<c:forEach var="row" items="${result.rows}">

		<help header="${row.header}">${fn:escapeXml(row.des)}</help>
    	
	</c:forEach>
	
</data>	

