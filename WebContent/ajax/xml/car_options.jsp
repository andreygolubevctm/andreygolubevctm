<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<sql:query var="result">
                                            	
	SELECT code, des
	    FROM aggregator.vehicle_accessories
		WHERE redbookCode = ?
		    AND type = 'O'
		ORDER BY des;
	<sql:param>${param.redbookCode}</sql:param>
</sql:query>

<%-- XML --%>
<?xml version="1.0" encoding="UTF-8"?>
<data>

	<%-- Build the xml data for each row --%>
	<c:forEach var="row" items="${result.rows}">

		<factoryOption optionCode="${row.code}">${fn:escapeXml(row.des)}</factoryOption>
    	
	</c:forEach>
	
</data>	
