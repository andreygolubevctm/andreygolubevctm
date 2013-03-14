<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<sql:setDataSource dataSource="jdbc/ctm"/>

<%--
SAVING A SUCCESSFUL HEALTH APPLICATION
======================================
Creates a historical snapshot of a confirmed health policy in XML with certain JSON and HTML objects.
- the about data
- the policy start date
- the product information
--%>

<c:set var="xmlData">
	<?xml version="1.0" encoding="UTF-8"?>
	<data>
		<transID>${data.current.transactionId}</transID>
		<status>OK</status>
		<vertical>CTMH</vertical>
		<startDate>${param.startDate}</startDate>
		<frequency>${param.frequency}</frequency>
		<about><![CDATA[ ${param.about} ]]></about>
		<whatsNext><![CDATA[ ${param.whatsNext} ]]></whatsNext>		
		<product><![CDATA[ ${param.product} ]]></product>
		<policyNo>${param.policyNo}</policyNo>
	</data>
</c:set>
<sql:setDataSource dataSource="jdbc/aggregator"/>
<c:catch var="detailsError">
	<sql:update>
 		INSERT INTO aggregator.transaction_details 
 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
 		values (?, ?, ?, ?,	default, now());
    	<sql:param value="${data.current.transactionId}" />
    	<sql:param value="${-2}" />
    	<sql:param value="health/policyNo" />
    	<sql:param value="${param.policyNo}" />						 		
	</sql:update>
</c:catch>
<sql:setDataSource dataSource="jdbc/ctm"/>

<%-- Save the form information to the database  --%>	
<c:catch var="error">
	 <sql:update var="result">
		INSERT INTO `confirmations`
    	(TransID, KeyId, Time, Vertical, XMLdata) VALUES (?, ?, NOW(), 'CTMH', ?);
    	<sql:param value="${data.current.transactionId}" />
    	<sql:param value="${pageContext.session.id}-${data.current.transactionId}" />
    	<sql:param value="${xmlData}" />;
	 </sql:update>
</c:catch>

<%-- Generate the Response --%>
<c:choose>
	<c:when test="${not empty error}">
		<c:set var="response">
			<status>ERROR</status>
			<error sql='save'>${error.rootCause}</error>
		</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="response">
			<status>OK</status>
		</c:set>
		<c:set var="emailResponse">
			<c:import url="/ajax/json/send.jsp">
				<c:param name="mode" value="app" />
			</c:import>
		</c:set>
		
		<%-- Store the emailResponse against the transaction --%>
		<c:catch var="storeEmailResponse">
			<c:if test="${not empty emailResponseXML}">
				<x:parse doc="${emailResponseXML}" var="confirmationXML" />
				<c:set var="confirmationCode">
					<x:choose>
						<x:when select="$confirmationXML/DMResponse/ResultData/TransactionID"><x:out select="$confirmationXML/DMResponse/ResultData/TransactionID" /></x:when>
						<x:otherwise>0</x:otherwise>
					</x:choose>
				</c:set>
				
				<sql:setDataSource dataSource="jdbc/aggregator"/>
				<sql:update>
			 		INSERT INTO aggregator.transaction_details 
			 		(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) 
			 		values (?, ?, ?, ?,	default, now());
			    	<sql:param value="${data.current.transactionId}" />
			    	<sql:param value="${-1}" />
			    	<sql:param value="health/confirmationEmailCode" />
			    	<sql:param value="${confirmationCode}" />						 		
				</sql:update>
			</c:if>
		</c:catch>
		<c:choose>
			<c:when test="${empty storeEmailResponse}">
				<go:log>Updated transaction details with record of confirmation code: ${confirmationCode}</go:log>
			</c:when>
			<c:otherwise>
				<go:log>Failed to Update transaction details with record of confirmation code: ${storeEmailResponse}</go:log>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

<?xml version="1.0" encoding="UTF-8"?>
<response>
	${response}
</response>
