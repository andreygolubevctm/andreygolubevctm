<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Write client details to the client database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%@ attribute name="productType" 	required="true"	 rtexprvalue="true"	 description="The product type (e.g. TRAVEL)" %>
<%@ attribute name="rootPath" 	required="true"	 rtexprvalue="true"	 description="root Path like (e.g. travel)" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="ipAddress" 		value="${pageContext.request.remoteAddr}"  />
<c:set var="sessionId" 		value="${pageContext.session.id}" />
<c:set var="styleCode" 		value="CTM" />
<c:set var="status" 		value="" />

<c:import var="getTransactionID" url="../json/get_transactionid.jsp?quoteType=${rootPath}&id_handler=preserve_tranId" />

<%-- Save the client values --%>
<c:set var="counter" value="0" />
<c:forEach var="item" items="${param}" varStatus="status">
	<c:set var="counter" value="${status.count}" />
	<c:set var="xpath" value="${go:xpathFromName(item.key)}" />
	<%--FIXME: Need to be reviewed and replaced with something nicer --%>
	<c:choose>
	<c:when test="${fn:contains(xpath,'credit/number')}"></c:when>
	<c:when test="${fn:contains(xpath,'bank/number')}"></c:when>
	<c:when test="${fn:contains(xpath,'claim/number')}"></c:when>
	<c:when test="${fn:contains(xpath,'payment/details/type')}"></c:when>
	<c:when test="${xpath=='/operatorid'}"></c:when>
	<c:otherwise>
		<sql:update>
	 		INSERT INTO aggregator.transaction_details 
	 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
	 		values (
	 			${data.current.transactionId},
	 			'${status.count}',
	 			'${xpath}',
	 			?,
	 			default,
	 			default
	 		) ON DUPLICATE KEY UPDATE 
	 			xpath = '${xpath}',
	 			textValue = ?; 
	 		<sql:param value="${item.value}" />
	 		<sql:param value="${item.value}" />
		</sql:update>
	</c:otherwise>
	</c:choose>
</c:forEach>

<%--Add the operator to the list details - if exists --%>
<c:if test="${not empty data['login/user/uid']}">
	<sql:update>
 		INSERT INTO aggregator.transaction_details 
 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
 		values (
 			${data.current.transactionId},
 			'${counter + 1}',
 			'health/operatorId',
 			'${data['login/user/uid']}',
 			default,
 			default
 		) ON DUPLICATE KEY UPDATE 
 			xpath = 'health/operatorId',
 			textValue = '${data['login/user/uid']}';
	</sql:update>
</c:if>