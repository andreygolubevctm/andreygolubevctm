<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Stamp an action in the database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="transactionId" 			required="true"	 rtexprvalue="true"	 description="Transaction" %>
<%@ attribute name="recordXPaths" 			required="true"	 rtexprvalue="true"	 description="A comma delimetered list of xpaths which are to be written to the database" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<jsp:useBean id="insertParams" class="java.util.ArrayList" scope="request" />
<c:set var="sandbox">${insertParams.clear()}</c:set>
<c:set var="insertSQLSB" value="${go:getStringBuilder()}" />
<c:set var="prefix" value=" " />

${go:appendString(insertSQLSB ,'INSERT INTO aggregator.results_properties (transactionId,productId,property,value) VALUES ')}

<c:forEach var="result" items="${soapdata['soap-response/results/result']}" varStatus='vs'>
	
	<c:if test="${result['available'] == 'Y'}">
	
		<c:set var="productId" value="${result['@productId']}"/>		
		
		<c:forTokens items="${recordXPaths}" var="xpath" delims=",">
				
			<c:set var="fieldValue" value="${result[xpath]}" />
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

<c:if test="${insertParams.size() > 0}">
	<c:catch var="error">
		<sql:update sql="${insertSQLSB.toString()}">
			<c:forEach var="item" items="${insertParams}">
				<sql:param value="${item}" />
			</c:forEach>
		</sql:update>
	</c:catch>
	<c:if test="${not empty error}">
		<error:non_fatal_error origin="car_quote_results.jsp" errorMessage="ERROR: Unable to insert quote results into database" errorCode="" />
	</c:if>
</c:if>