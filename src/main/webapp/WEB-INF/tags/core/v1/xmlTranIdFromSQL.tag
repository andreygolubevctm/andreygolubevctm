<%@ tag language="java" pageEncoding="UTF-8" %>
    
	<%-- ATTRIBUTES --%>
	<%@ attribute name="tranId" required="true" rtexprvalue="true" description="The Transaction ID"%>    
    
	<%-- 
		You will need these if you don't already have them 
	--%>
	<%@ include file="/WEB-INF/tags/taglib.tagf" %>
    <go:setData dataVar="data" value="*DELETE" xpath="tempSQL" />

	<%-- You should already have this bit --%>
	<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

	<%-- Get the tranId from the query string params --%>
	<c:set var="myTranId" value="${tranId}" />

	<%-- fetch the data --%>
	<sql:query var="details">
		SELECT transactionId, xpath, textValue 
		FROM aggregator.transaction_details 
		WHERE transactionId = ?
		ORDER BY sequenceNo ASC
		<sql:param>${myTranId}</sql:param>
	</sql:query>
	
	<%-- read the rows and add them to the data bucket --%>
	<c:forEach var="row" items="${details.rows}" varStatus="status">
		<go:setData dataVar="data" xpath="tempSQL/${row.xpath}" value="${row.textValue}" />
	</c:forEach>

	<%-- output it to the page --%>
	${go:getEscapedXml(data['tempSQL'])}