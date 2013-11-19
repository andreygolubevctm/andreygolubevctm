<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<sql:query var="result">
	SELECT a.ProviderId, a.Name FROM aggregator.provider_master a 
	WHERE
	EXISTS (Select * from aggregator.product_master b where b.providerid = a.providerid and b.productCat = ?)
	ORDER BY a.Name;
	<sql:param>${param.category}</sql:param>
</sql:query>

<%-- XML --%>

<data>
	<%-- Build the xml data for each row --%>
	<c:forEach var="row" items="${result.rows}">	
		<provider providerId="${row.ProviderId}">${row.Name}</provider>
    	
	</c:forEach>
</data>