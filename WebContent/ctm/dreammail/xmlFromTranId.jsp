<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
	<%-- 
		You will need these if you don't already have them 
	--%>
	<%@ include file="/WEB-INF/tags/taglib.tagf" %>
    <jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
    <go:setData dataVar="data" value="*DELETE" xpath="quote" />

	<%-- You should already have this bit --%>
	<sql:setDataSource dataSource="jdbc/aggregator"/>

	<%-- Get the tranId from the query string params --%>
	<c:set var="myTranId" value="${param.tranId}" />

	<%-- fetch the data --%>
	<sql:query var="details">
		SELECT transactionId, xpath, textValue 
		FROM aggregator.transaction_details 
		WHERE transactionId = ${myTranId} 
		ORDER BY sequenceNo ASC
	</sql:query>
	
	<%-- read the rows and add them to the data bucket --%>
	<c:forEach var="row" items="${details.rows}" varStatus="status">
		<go:setData dataVar="data" xpath="${row.xpath}" value="${row.textValue}" />
	</c:forEach>

	<%-- get the xml out of the data bucket --%>
	<c:set var="myXML" value="${data}" />

	<%-- output it to the page --%>
	<c:out value="${myXML}" escapeXml="true" />
