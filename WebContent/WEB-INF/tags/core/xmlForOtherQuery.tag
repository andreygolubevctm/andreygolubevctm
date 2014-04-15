<%@ tag language="java" pageEncoding="UTF-8" %>

	<%-- ATTRIBUTES --%>
	<%@ attribute name="tranId" required="true" rtexprvalue="true" description="The Transaction ID"%>
	<%@ attribute name="sqlSelect" required="true" rtexprvalue="true" description="The Select Statement"%>
	<%@ attribute name="calcSequence" required="false" rtexprvalue="true" description="The CalcSequence value to use in query"%>
	<%@ attribute name="rankPosition" required="false" rtexprvalue="true" description="The RankPosition value to use in query"%>

	<%--
		You will need these if you don't already have them
	--%>
	<%@ include file="/WEB-INF/tags/taglib.tagf" %>


	<%-- You should already have this bit --%>
	<sql:setDataSource dataSource="jdbc/aggregator"/>

	<%-- Get the tranId from the query string params --%>
	<c:set var="myTranId" value="${tranId}" />
	<c:set var="mysqlSelect" value="${sqlSelect}" />

	<%-- fetch the data --%>
	<sql:query var="details">${mysqlSelect}
		<sql:param>${myTranId}</sql:param>
		<c:if test="${not empty calcSequence and not empty rankPosition}">
			<sql:param>${calcSequence}</sql:param>
			<sql:param>${rankPosition}</sql:param>
		</c:if>
	</sql:query>

	<%-- read the rows and add them to the data bucket --%>
	<c:forEach var="row" items="${details.rows}" varStatus="status">
		<go:setData dataVar="data" xpath="tempSQL/${row.xpath}" value="${row.textValue}" />
	</c:forEach>

	<%-- output it to the page --%>
	${go:getEscapedXml(data['tempSQL'])}