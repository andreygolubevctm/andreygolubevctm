<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get />

<go:setData dataVar="data" value="*DELETE" xpath="quote" />

<core:doctype />
<go:html>
	<core:head quoteType="false" title="Process SQL and send to dreammail" nonQuotePage="${true}" />
	<body>
	
	<%-- Parameters --%>
	<c:choose>
	<c:when test="${param.tmpl==''}">Please supply template (templ)</c:when>
	<c:otherwise>
		<c:set var="template" value="/dreammail/${param.tmpl}.xsl" />
		<c:set var="extraSql" value="${param.xSQL}" />

		<c:import var="sqlStatement" url="/dreammail/${param.tmpl}.sql" />	

		<%-- Dreammail params --%>
		<c:set var="dmUsername">BD_Automated</c:set>
		<c:set var="dmPassword">Pass123</c:set>
		<c:set var="dmUrl">https://rtm.na.epidm.net/weblet/weblet.dll</c:set>
		<c:set var="dmServer">dm14</c:set>
		<c:set var="dmDebug">Y</c:set>
		
		<c:set var="ClientName">BudgetDirect</c:set>
		<c:set var="SiteName">Compare_Market</c:set>
		<c:set var="CampaignName">CompareTheMarket</c:set>
		<c:set var="InsuranceType">other</c:set>

		<%-- Import the XSL template --%>			
		<c:import var="myXSL" url="${template}" />
		
		<%-- Build the xml for each row and process it. --%>
		<sql:setDataSource dataSource="jdbc/aggregator"/>
		
			<c:set var="rowXML">
				<core:xmlTranIdFromSQL tranId="${param.transactionId}"></core:xmlTranIdFromSQL>
			</c:set>
			
			<c:if test="${extraSql == 'Y'}">
				<c:choose>
					<c:when test="${param.tmpl eq 'travel_edm'}">
						<c:set var="rowXML"><core:xmlForOtherQuery sqlSelect="${sqlStatement}" tranId="${param.transactionId}" calcSequence="${data.travel.calcSequence}" rankPosition="${data.travel.bestPricePosition}"></core:xmlForOtherQuery></c:set>
					</c:when>
					<c:otherwise>
						<c:set var="rowXML"><core:xmlForOtherQuery sqlSelect="${sqlStatement}" tranId="${param.transactionId}"></core:xmlForOtherQuery></c:set>
					</c:otherwise>
				</c:choose>
			</c:if>

			<go:setData dataVar="data" value="*DELETE" xpath="tempSQL" />

			<c:if test="${param.send != 'Y'}">
				<h3>Row XML:</h3>
				<pre><c:out value="${rowXML}" escapeXml="true"/></pre>
			</c:if>
			
			<c:set var="myResult">
				<x:transform doc="${rowXML}" xslt="${myXSL}">
				
					<c:set var="MailingName">${param.MailingName}</c:set>
					<c:set var="env">${param.env}</c:set>
					<c:set var="server">${param.server}</c:set>
					<c:set var="SessionId">${param.SessionId}</c:set>
					
					<x:param name="ClientName">${ClientName}</x:param>
					<x:param name="SiteName">${SiteName}</x:param>
					<x:param name="CampaignName">${CampaignName}</x:param>
					<x:param name="MailingName">${MailingName}</x:param>
					<x:param name="env">${env}</x:param>
					<x:param name="server">${server}</x:param>
					<x:param name="SessionId">${SessionId}</x:param>
					<x:param name="tranId">${param.transactionId}</x:param>
					<x:param name="InsuranceType">${param.tmpl}</x:param>
					<x:param name="hashedEmail">${param.hashedEmail}</x:param>
				</x:transform>
			</c:set>

			<%-- If we're outputting to the page only, just output the result. --%>	
			<c:choose>
				<c:when test="${param.send != 'Y'}">
					<h3>Result XML:</h3>
					<pre><c:out value="${myResult}" escapeXml="true"/></pre>
					<hr />
				</c:when>
				
				<c:otherwise>
					<%-- Send to dreammail and output the result to the page --%>
					<c:catch var="error">
					<c:set var="emailResponseXML" scope="session">${go:Dreammail(dmUsername,dmPassword,dmServer,dmUrl,myResult,dmDebug)}</c:set>

						<go:log source="dreammail_send_jsp" level="TRACE">
						${dmUsername},${dmPassword},${dmServer},${dmUrl},${myResult},${dmDebug}
						</go:log>
					</c:catch>
					<c:if test="${not empty error}">
						<c:import url="/ajax/write/register_fatal_error.jsp">
							<c:param name="page" value="/dreammail/send.jsp" />
							<c:param name="message" value="${error.cause.message}" />
							<c:param name="description" value="failed to send email" />
							<c:param name="data" value="${myResult}" />
						</c:import>
					</c:if>
					${emailResponseXML}
					<go:log source="dreammail_send_jsp">emailResponseXML: ${emailResponseXML}</go:log>
				</c:otherwise>
			</c:choose>
			
		<%-- </c:forEach> --%>
		
	</c:otherwise>
	</c:choose>
	</body>
</go:html>