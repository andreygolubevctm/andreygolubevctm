<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%-- You will need these if you don't already have them --%>
	<%@ include file="/WEB-INF/tags/taglib.tagf" %>
	<jsp:useBean id="data" class="com.ctm.web.core.web.go.Data" scope="request" />
	<go:setData dataVar="data" value="*DELETE" xpath="quote" />

	<%-- You should already have this bit --%>
	<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

	<%-- sql:param value="${param.sqlSelect}" /--%>

	<%-- fetch the data --%>
	<sql:query var="details">${param.sqlSelect}
		<%-- Get the tranId from the query string params --%>
		<sql:param value="${param.tranId}" />

	</sql:query>

	<%-- read the rows and add them to the data bucket --%>
	<c:forEach var="row" items="${details.rows}" varStatus="status">
		<go:setData dataVar="data" xpath="${row.xpath}" value="${row.textValue}" />
	</c:forEach>

	<%-- get the xml out of the data bucket --%>
	<c:set var="myXXML" value="${data}" />

	<%-- output it to the page --%>
	<c:out value="${myXXML}" escapeXml="true" />