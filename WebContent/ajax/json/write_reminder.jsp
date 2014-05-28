<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<c:choose>
	<c:when test="${not empty param.transactionId}">
		<session:get settings="true" authenticated="true" />
	</c:when>
	<c:otherwise>
		<settings:setVertical verticalCode="GENERIC" />
		<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />
	</c:otherwise>
</c:choose>



<%-- todo - remove the hack mentioned below as the new session structure should fix this. --%>

<c:set var="errorPool" value="" />

<c:set var="quoteType" value="${param.quoteType}" />
<c:set var="callback" value="${param.callback}" />

<%--
	Dodgy dodgy hack because of our monolithic data structure
	Save reminder in it's own transaction id so that it doesn't affect the journey
--%>

<c:set var="transactionExists" value="${not empty data['current/transactionId']}" />

<c:if test="${transactionExists}">
	<c:set var="originalTransactionId" value="${data.current.transactionId}" />
	<go:setData dataVar="data" value="*DELETE" xpath="current/transactionId" />
</c:if>

<security:populateDataFromParams rootPath="save" />

<c:set var="outcome"><core:get_transaction_id quoteType="${quoteType}" id_handler="preserve_tranId" emailAddress="${data['save/email']}" /></c:set>

<c:if test="${not empty data['current/verticalCode']}">
	<c:set var="originalVertical" value="${data['current/verticalCode']}" />
</c:if>



<security:populateDataFromParams rootPath="reminder" />
<c:set var="ct_outcome">
	<core:transaction touch="H" noResponse="false" writeQuoteOverride="Y" emailAddress="${data['reminder/email']}" />
</c:set>

<c:set var="reminderTransactionId" value="${data.current.transactionId}" />

<c:choose>
	<c:when test="${transactionExists}">
		<go:setData dataVar="data" value="${originalTransactionId}" xpath="current/transactionId" />		
	</c:when>
	<c:otherwise>
		<go:setData dataVar="data" value="*DELETE" xpath="*" />
	</c:otherwise>
</c:choose>

<c:if test="${not empty errorPool}">
	<c:set var="errorPool">${errorPool},</c:set>
</c:if>

<c:if test="${fn:contains(ct_outcome,'FAILED:')}">
	<c:set var="ct_outcome" value="${fn:substringAfter(ct_outcome, 'FAILED:')}" />
	<c:set var="ct_outcome">${fn:replace(ct_outcome, "\"", "\\\"")}</c:set>
	<c:set var="errorPool">${errorPool}"${ct_outcome}"</c:set>
</c:if>
<%-- JSON/JSONP RESPONSE --%>
<c:choose>
	<c:when test="${not empty errorPool}">
		<go:log level="ERROR" source="write_reminder_jsp">SAVE ERRORS: ${errorPool}</go:log>
		<c:choose>
			<c:when test="${fn:contains(callback,'jsonp')}">
				${callback}({error:${errorPool}});
			</c:when>
			<c:otherwise>
				{error:${errorPool}}
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${fn:contains(callback,'jsonp')}">
				${callback}({"result":"OK" , "transactionId": "${reminderTransactionId}"});
			</c:when>
			<c:otherwise>
				{"result":"OK" , "transactionId": "${reminderTransactionId}" }
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>