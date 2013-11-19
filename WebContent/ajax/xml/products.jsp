<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<sql:query var="result">
	SELECT ProductId, LongTitle
	FROM aggregator.product_master
	WHERE ProductCat = ? and ProviderId = ?
	ORDER BY LongTitle
	<sql:param value="${param.category}" />
	<sql:param value="${param.provider}" />
</sql:query>

<%-- XML --%>
<data>

	<%-- Build the xml data for each row --%>
	<c:forEach var="row" items="${result.rows}">	
		
		<product productId="${row.ProductId}">${row.LongTitle}</product>
    	
	</c:forEach>
	
</data>