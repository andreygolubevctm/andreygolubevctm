<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Stamp an action in the database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="transactionId" 			required="true"	 rtexprvalue="true"	 description="Transaction" %>
<%@ attribute name="recordXPaths" 			required="true"	 rtexprvalue="true"	 description="A comma delimetered list of xpaths which are to be written to the database" %>
<%@ attribute name="sessionXPaths" 			required="false"	 rtexprvalue="true"	 description="A comma delimetered list of xpaths which are to be written to the session object - eg premiums" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<jsp:useBean id="insertParams" class="java.util.ArrayList" scope="request" />
<c:set var="sandbox">${insertParams.clear()}</c:set>
<c:set var="insertSQLSB" value="${go:getStringBuilder()}" />
<c:set var="prefix" value=" " />

<c:catch var="error">
	<sql:update sql="DELETE FROM aggregator.results_properties WHERE transactionId = ? ;">
		<sql:param value="${transactionId}" />
	</sql:update>
</c:catch>

${go:appendString(insertSQLSB ,'INSERT INTO aggregator.results_properties (transactionId,productId,property,value) VALUES ')}

<c:forEach var="result" items="${soapdata['soap-response/results/result']}" varStatus='vs'>

	<c:if test="${result['available'] == 'Y' || result['productAvailable'] == 'Y'}">

		<c:set var="productId" value="${result['@productId']}"/>

		<c:forTokens items="${recordXPaths}" var="xpath" delims=",">

			<c:set var="fieldValue" value="${result[xpath]}" />

			<c:if test="${empty fieldValue}">
				<c:set var="fieldValue" value="" />
			</c:if>

			${go:appendString(insertSQLSB, prefix)}
			<c:set var="prefix" value=", " />
			${go:appendString(insertSQLSB, '(?,?,?,?)')}

			<c:set var="ignore">
				${insertParams.add(transactionId)};
				${insertParams.add(productId)};
				${insertParams.add(xpath)};
				${insertParams.add(fieldValue)};
			</c:set>

		</c:forTokens>

	</c:if>

</c:forEach>

<%-- We are not allow to store things like premium in the database, therefore place this sort of data in the session object for retrival later --%>
<c:if test="${not empty sessionXPaths}">
	<c:forEach var="result" items="${soapdata['soap-response/results/result']}" varStatus='vs'>
		<c:set var="productId" value="${result['@productId']}"/>
		<c:forTokens items="${sessionXPaths}" var="xpath" delims=",">
			<c:set var="value" value="${result[xpath]}" />
			<go:setData dataVar="data" xpath="tempResultDetails/results/${productId}/${xpath}" value="${value}" />
		</c:forTokens>
	</c:forEach>
</c:if>

<c:if test="${insertParams.size() > 0}">
	<c:catch var="error">
		<sql:update sql="${insertSQLSB.toString()}">
			<c:forEach var="item" items="${insertParams}">
				<sql:param value="${item}" />
			</c:forEach>
		</sql:update>
	</c:catch>
	<c:if test="${not empty error}">
		<error:non_fatal_error origin="write_result_details.tag" errorMessage="ERROR: Unable to insert quote results into database ${error}" errorCode="" />
	</c:if>
</c:if>

