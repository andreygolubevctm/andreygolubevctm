<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<go:setData dataVar="data" value="*DELETE" xpath="quote" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>
	<core:head quoteType="false" title="Process SQL and send to dreammail" nonQuotePage="${true}" />
	<body>
	
	<%-- Parameters --%>
	<c:choose>
	<c:when test="${param.tmpl==''}">
		Please supply template (templ)
	</c:when>
	<c:otherwise>
		<c:set var="template" value="/dreammail/${param.tmpl}.xsl" />
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
		
		<%-- Build the xml for each row and process it --%>
		<sql:setDataSource dataSource="jdbc/aggregator"/>
		
		
			<c:set var="rowXML">
			
			
				<core:xmlTranIdFromSQL tranId="${param.tranId}"></core:xmlTranIdFromSQL>
			
				
			</c:set>
			
			<c:if test="${param.send != 'Y'}">
				<h3>Row XML:</h3>
				<pre><c:out value="${rowXML}" escapeXml="true"/></pre>
			</c:if>
			
			<c:set var="myResult">
				<x:transform doc="${rowXML}" xslt="${myXSL}">
				
					<c:set var="MailingName">${param.MailingName}</c:set>
					<c:set var="env">${param.env}</c:set>
					<c:set var="SessionId">${param.SessionId}</c:set>
					
					<x:param name="ClientName">${ClientName}</x:param>
					<x:param name="SiteName">${SiteName}</x:param>
					<x:param name="CampaignName">${CampaignName}</x:param>
					<x:param name="MailingName">${MailingName}</x:param>
					<x:param name="env">${env}</x:param>
					<x:param name="SessionId">${SessionId}</x:param>
					<x:param name="tranId">${param.tranId}</x:param>
					<x:param name="InsuranceType">${param.tmpl}</x:param>
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
					<c:set var="emailResponseXML" scope="session">${go:Dreammail(dmUsername,dmPassword,dmServer,dmUrl,myResult,dmDebug)}</c:set>
					${emailResponseXML}
					<go:log>emailResponseXML: ${emailResponseXML}</go:log>					
				</c:otherwise>
			</c:choose>
			
		<%-- </c:forEach> --%>
		
	</c:otherwise>
	</c:choose>
	</body>
</go:html>