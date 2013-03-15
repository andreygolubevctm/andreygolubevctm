<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<% pageContext.setAttribute("newLineChar", "\n"); %>
<% pageContext.setAttribute("quote", "\""); %>
<%--

	This page saves application submissions to local CSV.
	To comply with PCI, the csv is streamed straight into an encrypted ZIP file.
	It is processed through the SOAP Aggregator in ajax/json/health_application.jsp, so this page receives XML as the POST body.

	REVISE this mishmash of jsp & jstl.

--%>
<c:set var="realPath"><%= this.getServletContext().getRealPath("/") %></c:set>
<c:set var="millisecs"><%=String.valueOf(System.currentTimeMillis()) %></c:set>
<c:set var="datetime"><%
	java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String formattedDate = df.format(new java.util.Date());
%><%=formattedDate %></c:set>
<c:set var="body"><%
	// Get the raw body of the request
	ServletInputStream inputStream = pageContext.getRequest().getInputStream();
	java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
	byte[] buffer = new byte[1024];
	int length = 0;
	while ((length = inputStream.read(buffer)) != -1) {
		baos.write(buffer, 0, length);
	}
	String body = new String(baos.toByteArray());
%><%=body %></c:set>

<go:log>ContentLength: ${pageContext.request.contentLength}</go:log>
<%-- <go:log>Body: ${body}</go:log> --%>

<c:if test="${pageContext.request.contentLength > 0}">
	<x:parse doc="${body}" var="applicationXml" />
	
	<c:set var="transId">
		<x:out select="$applicationXml/xml/transactionId" />
	</c:set>
	<c:set var="fundProductCode">
		<x:out select="$applicationXml/xml/data/FundProductCode" />
	</c:set>
</c:if>

<c:import var="config" url="/WEB-INF/aggregator/health_application/wfd/config.xml" />
<x:parse doc="${config}" var="configXml" />

<%-- damn namespaces http://pro-programmers.blogspot.com.au/2008/04/jstl-xparse-not-working-for-elements.html --%>
<c:set var="zipPassword">
	<x:out select="$configXml//*[name()='soap-password']" />
</c:set>
<c:set var="saveLocation">
	<x:out select="$configXml//*[name()='save-location']" />
</c:set>
<c:if test="${!fn:endsWith(saveLocation, '/')}">
	<c:set var="saveLocation">${saveLocation}/</c:set>
</c:if>
<c:if test="${fn:startsWith(saveLocation, '/WEB-INF') or fn:startsWith(saveLocation, '/..')}">
	<c:set var="saveLocation">${realPath}${saveLocation}</c:set>
</c:if>

<c:set var="zipFilename" value="${saveLocation}wfd_${transId}_${millisecs}.zip" />
<c:set var="internalName" value="application_${transId}.csv" />



<go:log>transId: ${transId}</go:log>
<go:log>fundProductCode: ${fundProductCode}</go:log>

<?xml version="1.0" encoding="UTF-8"?>
<result>
<%-- TODO: Validate application and determine real success/failure --%>
<%-- <policyNo>000001</policyNo> --%>

	<c:choose>
		<c:when test="${empty transId or empty fundProductCode}">
			<success>false</success>
			<errors>
				<error><code>1</code><text>Invalid application data.</text></error>
			</errors>
		</c:when>
		<c:otherwise>
			<%-- CSV FORMAT OUTPUT --%>
			<c:set var="output">
				<%-- HEADERS --%>
				<x:forEach select="$applicationXml/xml/data/node()" var="node" varStatus="loop">
					<x:choose>
						<x:when select="$node/@name"><x:out select="$node/@name" /></x:when>
						<x:otherwise><x:out select="name($node)" /></x:otherwise>
					</x:choose>
					<c:if test="${not loop.last}">,</c:if>
				</x:forEach>
				${newLineChar}

				<%-- VALUES --%>
				<x:forEach select="$applicationXml/xml/data/node()" var="node" varStatus="loop">
					<x:choose>
						<x:when select="name($node) = 'SaleCompletedTime'">
							<c:set var="val">${datetime}</c:set>
						</x:when>
						<x:otherwise>
							<c:set var="val"><x:out select="$node" /></c:set>
						</x:otherwise>
					</x:choose>
					${quote}
					<c:out value="${fn:replace(val, '\"', '\"\"')}" />
					${quote}
					<c:if test="${not loop.last}">,</c:if>
				</x:forEach>
			</c:set>

			<go:log>Writing to: ${zipFilename}</go:log>

			<c:set var="writeSuccess" value="false" />
			<c:catch var="error">
				<%-- ${go:writeToFile(filename, output)} --%>
				<c:set var="writeSuccess" value="${go:writeToEncZipFile(zipFilename, output, internalName, zipPassword)}" />
			</c:catch>

			<c:choose>
				<c:when test="${writeSuccess != true}">
					<success>false</success>
					<errors>
						<error><code>2</code><text>Write to secure file failed.</text></error>
					</errors>
				</c:when>
				
				<c:when test="${not empty error}">
					<success>false</success>
					<errors>
						<error><code></code><text>${error.rootCause}</text></error>
					</errors>
				</c:when>

				<c:when test="${file:exists(zipFilename) == false}">
					<success>false</success>
					<errors>
						<error><code>3</code><text>Saved application file does not exist.</text></error>
					</errors>
				</c:when>

				<c:otherwise>
					<success>true</success>
				</c:otherwise>
			</c:choose>
		</c:otherwise>
	</c:choose>
</result>
