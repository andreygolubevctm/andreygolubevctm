<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<c:choose>
	<c:when test="${not empty param.transactionId}">
		<session:get settings="true" />
	</c:when>
	<c:otherwise>
		<%-- Any email with out a transaction id would most likely be things like forgot password --%>
		<settings:setVertical verticalCode="GENERIC" />
		<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />
	</c:otherwise>
</c:choose>

<go:setData dataVar="data" value="*DELETE" xpath="quote" />

	<c:set var="gomezhashedEmail"><security:hashed_email action="encrypt" email="gomez.testing@aihco.com.au" brand="${pageSettings.getBrandCode()}" /></c:set>
	<c:set var="paramSend">${param.send}</c:set>
	
	<%-- If the vertical is running through Gomez, then kill the emails sent out --%>
	<c:choose>
		<c:when test="${gomezhashedEmail == param.hashedEmail}">
			<c:set var="paramSend">N</c:set>
		</c:when>
	</c:choose>

	<%-- Determine if Exact Target or OLD method --%>
	<c:set var="isExactTarget">
		<c:choose>
		<c:when test="${fn:contains('health_app,health_bestprice,health_quote,home_bestprice,generic_reset', param.tmpl)}">${true}</c:when>
			<c:otherwise>${false}</c:otherwise>
		</c:choose>
	</c:set>

	<%-- Parameters --%>
	<c:choose>
	<c:when test="${param.tmpl==''}">Please supply template (templ)</c:when>
	<c:otherwise>
		<c:set var="template" value="/dreammail/${param.tmpl}.xsl" />
		<c:set var="extraSql" value="${param.xSQL}" />


		<%-- Dreammail params --%>
		<c:choose>
			<c:when test="${isExactTarget eq true}">
				<c:set var="dmUsername">*****</c:set>
				<c:set var="dmPassword">*****</c:set>
				<c:set var="dmUrl">https://webservice.s6.exacttarget.com/Service.asmx</c:set>
				<c:set var="dmServer">*****</c:set>
				<c:set var="dmDebug">Y</c:set>
			</c:when>
			<c:otherwise>
		<c:set var="dmUsername">BD_Automated</c:set>
		<c:set var="dmPassword">Pass123</c:set>
		<c:set var="dmUrl">https://rtm.na.epidm.net/weblet/weblet.dll</c:set>
		<c:set var="dmServer">dm14</c:set>
		<c:set var="dmDebug">Y</c:set>
			</c:otherwise>
		</c:choose>
		
		<c:set var="ClientName">BudgetDirect</c:set>
		<c:set var="SiteName">Compare_Market</c:set>
		<c:set var="CampaignName">CompareTheMarket</c:set>
		<c:set var="InsuranceType">other</c:set>

		<%-- Import the XSL template --%>			
		<c:import var="myXSL" url="${template}" />
		
			<sql:setDataSource dataSource="jdbc/aggregator"/>
		<%-- Build the xml for each row and process it. --%>
		<%-- If we don't have xml, because we're not doing a transaction lookup with awesome data, we just pass some donkey xml, because we know the xsl doesn't check anything inside it PLEASE ENSURE YOU HAVE SOMETHING IN YOUR XML AS A BLANK VARIABLE WILL CAUSE THE EMAIL NOT TO SEND --%>
			<c:choose>
			<c:when test="${not empty param.transactionId}">
			<c:set var="rowXML">
				<core:xmlTranIdFromSQL tranId="${param.transactionId}"></core:xmlTranIdFromSQL>
			</c:set>
				</c:when>
				<c:otherwise>
					<c:set var="rowXML">
						<tempSQL><generic></generic></tempSQL>
					</c:set>
				</c:otherwise>
			</c:choose>
			
			<c:if test="${extraSql == 'Y'}">
				<c:import var="sqlStatement" url="/dreammail/${param.tmpl}.sql" />
				<c:choose>
					<c:when test="${param.tmpl eq 'travel_edm'}">
						<c:set var="rowXML"><core:xmlForOtherQuery sqlSelect="${sqlStatement}" tranId="${param.transactionId}" calcSequence="${data.travel.calcSequence}" rankPosition="${data.travel.bestPricePosition}"></core:xmlForOtherQuery></c:set>
					</c:when>
					<c:when test="${param.tmpl eq 'health_bestprice'}">
						<c:set var="rowXML"><health:xmlForOtherQuery sqlSelect="${sqlStatement}" tranId="${param.transactionId}" ></health:xmlForOtherQuery></c:set>
						<c:set var="rowXML"><health:xmlForCallCentreHoursQuery /></c:set>
					</c:when>
				<c:when test="${param.tmpl eq 'home_bestprice'}">
					<c:set var="rowXML"><home:xmlForOtherQuery tranId="${param.transactionId}" ></home:xmlForOtherQuery></c:set>
				</c:when>
					<c:otherwise>
						<c:set var="rowXML"><core:xmlForOtherQuery sqlSelect="${sqlStatement}" tranId="${param.transactionId}"></core:xmlForOtherQuery></c:set>
					</c:otherwise>
				</c:choose>
			</c:if>
			<go:setData dataVar="data" value="*DELETE" xpath="tempSQL" />

		<c:choose>

			<c:when test="${rowXML != '' }">

				<c:if test="${paramSend != 'Y'}">
		<%-- NB: There was a huge amount of stuff surrounding this jsp by way of core:head and go:html go:body - that is dying in the console regarding the applicationSettings. So i've ditched them in favor of just manually wrapping in a html skeleton, since it's a dev only page with no styling. --%>
		<core:doctype />
		<html class="no-js" lang="en">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
				<meta http-equiv="Cache-Control" content="no-cache, max-age=0" />
				<meta http-equiv="Expires" content="-1">
				<meta http-equiv="Pragma" content="no-cache">
				<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
				<title>Compare the Market - Process SQL and send to dreammail</title>
			</head>
			<body>
				<h3>Row XML:</h3>
				<pre><c:out value="${rowXML}" escapeXml="true"/></pre>
			</c:if>
			
					<c:set var="MailingName">${param.MailingName}</c:set>
		<c:set var="OptInMailingName">${param.OptInMailingName}</c:set>
					<c:set var="env">${param.env}</c:set>
					<c:set var="server">${param.server}</c:set>
					<c:set var="SessionId">${param.SessionId}</c:set>
		<c:set var="baseURL">${pageSettings.getBaseUrl()}</c:set>
					
		<c:set var="myResult">
			<x:transform doc="${rowXML}" xslt="${myXSL}">
					<x:param name="Brand">${pageSettings.getBrandCode()}</x:param>
					<x:param name="ClientName">${ClientName}</x:param>
				<x:param name="ClientId">${pageSettings.getSetting('sendClientId')}</x:param>
					<x:param name="SiteName">${SiteName}</x:param>
					<x:param name="CampaignName">${CampaignName}</x:param>
					<x:param name="MailingName">${MailingName}</x:param>
				<x:param name="OptInMailingName">${OptInMailingName}</x:param>
					<x:param name="env">${env}</x:param>
					<x:param name="server">${server}</x:param>
					<x:param name="SessionId">${SessionId}</x:param>
					<x:param name="tranId">${param.transactionId}</x:param>
					<x:param name="InsuranceType">${param.tmpl}</x:param>
				<x:param name="baseURL">${baseURL}</x:param>
				<x:param name="sendToEmail">${param.emailAddress}</x:param>
					<x:param name="hashedEmail">${param.hashedEmail}</x:param>
				<x:param name="emailSubscribed">${param.emailSubscribed}</x:param>
					<x:param name="contextFolder">${pageSettings.getSetting('contextFolder')}</x:param>
					<x:param name="token">${param.token}</x:param>
				<c:if test="${fn:contains(param.tmpl,'health_')}">
						<x:param name="callCentrePhone"><content:get key="healthCallCentreNumber"/></x:param>
					</c:if>
				</x:transform>
			</c:set>

			<%-- If we're outputting to the page only, just output the result. --%>	
			<c:choose>
				<c:when test="${param.send != 'Y'}">
					<h3>Result XML:</h3>
					<pre><c:out value="${myResult}" escapeXml="true"/></pre>
					<hr />
				</body>
				</html>
				</c:when>
				<c:otherwise>
					<%-- Send to dreammail and output the result to the page --%>
					<c:catch var="error">
						<c:set var="emailResponseXML" scope="session">${go:Dreammail(dmUsername,dmPassword,dmServer,dmUrl,myResult,dmDebug,isExactTarget)}</c:set>
					</c:catch>
					<c:if test="${not empty error}">
						<c:import url="/ajax/write/register_fatal_error.jsp">
							<c:param name="page" value="/dreammail/send.jsp" />
							<c:param name="message" value="${error.cause.message}" />
							<c:param name="description" value="failed to send email" />
							<c:param name="data" value="${myResult}" />
						</c:import>
					<%-- JSON result failure returned --%>
					<json:object>
						<json:property name="result" value="SEND_FAILURE"/>
						<json:property name="message" value="${error.cause.message}"/>
					</json:object>
					</c:if>
				<go:log source="dreammail_send_jsp">An email send was attempted via go:Dreammail. emailResponseXML: ${emailResponseXML}</go:log>
				</c:otherwise>
			</c:choose>
			</c:when>
			<c:otherwise>
				<go:log>No content for email - not sending.</go:log>
	</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>