<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<sql:query var="result">
	SELECT ProductId, LongTitle
	FROM aggregator.product_master
	WHERE ProductCat = '${param.category}' and ProviderId = ${param.provider}
	ORDER BY LongTitle
</sql:query>

<%-- XML --%>
<data>

	<%-- Build the xml data for each row --%>
	<c:forEach var="row" items="${result.rows}">	
		
		<product productId="${row.ProductId}">${row.LongTitle}</product>
    	
	</c:forEach>
	
</data>