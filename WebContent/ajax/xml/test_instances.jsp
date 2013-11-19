<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" value="*PARAMS" xpath="testData" />

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%-- get test instances from db --%>
<sql:query var="result">
	SELECT
	a.testId,
	a.testCase,
	a.siteName,
	b.LongTitle,
	a.testDesc
	FROM aggregator.test_instances a 
	INNER JOIN aggregator.product_master b
	WHERE b.ProductId = '${data.testData['product']}' and b.productCat = a.siteName;	
</sql:query>

<%-- XML --%>
<data>
	<c:forEach var="row" items="${result.rows}" varStatus="status">
		<go:setData dataVar="data" value="${row.LongTitle}" xpath="productName" />
		<properties id="${row.testId}" prodTitle="${row.LongTitle}" description="${row.testDesc}">${row.testCase}</properties>
	</c:forEach>
</data>	