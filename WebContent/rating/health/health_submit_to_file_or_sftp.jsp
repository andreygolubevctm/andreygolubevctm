<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<% pageContext.setAttribute("newLineChar", "\r\n"); %>
<% pageContext.setAttribute("quote", "\""); %>
<%--

	VERSION 2.1
	This page can:
	* Convert application data to CSV and store in an encrypted ZIP file on disk
	* Convert application data to CSV, store in an encrypted ZIP file and upload to an SFTP

	To comply with PCI:
	* No plain text is saved to disk
	* Application data is streamed from memory straight into an encrypted ZIP file, and optionally then streamed straight into an SFTP connection.

	This page is processed through the SOAP Aggregator in ajax/json/health_application.jsp, so this page receives XML as the POST body.

	Versions prior to 2.1 were for Westfund only.
	v2.1 uses the /provider field to load the appropriate config (ensure that you map this field in your outbound.xsl)

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
		<x:out select="$applicationXml/xml/FundProductCode" />
	</c:set>
	<c:set var="provider">
		<x:out select="$applicationXml/xml/provider" />
	</c:set>
	<c:set var="provider" value="${fn:toLowerCase(provider)}" />
</c:if>

<c:if test="${not empty provider}">
	<c:import var="config" url="/WEB-INF/aggregator/health_application/${provider}/config.xml" />
	<x:parse doc="${config}" var="configXml" />

	<%-- damn namespaces http://pro-programmers.blogspot.com.au/2008/04/jstl-xparse-not-working-for-elements.html --%>
	<c:set var="saveLocation">
		<x:out select="$configXml//*[name()='export']/*[name()='save-location']" />
	</c:set>
	<c:if test="${not empty saveLocation and !fn:endsWith(saveLocation, '/')}">
		<c:set var="saveLocation">${saveLocation}/</c:set>
	</c:if>
	<%-- Old style paths (pre one-click deploys) --%>
	<c:if test="${fn:startsWith(saveLocation, '/WEB-INF/')}">
		<c:set var="saveLocation">${realPath}${saveLocation}</c:set>
	</c:if>
	<%-- New style paths (one-click deploys) --%>
	<c:if test="${fn:startsWith(saveLocation, 'aggregator/')}">
		<c:set var="saveLocation">${realPath}WEB-INF/${saveLocation}</c:set>
	</c:if>

	<c:set var="zipPassword"><x:out select="$configXml//*[name()='soap-password']" /></c:set>
	<c:set var="exportHost"><x:out select="$configXml//*[name()='export']/*[name()='host']" /></c:set>
	<c:set var="exportUsername"><x:out select="$configXml//*[name()='export']/*[name()='username']" /></c:set>
	<c:set var="exportPassword"><x:out select="$configXml//*[name()='export']/*[name()='password']" /></c:set>

	<c:set var="zipFilenameWithPath" value="${saveLocation}${provider}_${transId}_${millisecs}.zip" />
	<c:set var="zipFilename" value="${provider}_${transId}_${millisecs}.zip" />
	<c:set var="internalName" value="application_${transId}.csv" />
</c:if>



<go:log>transId: ${transId}</go:log>
<go:log>fundProductCode: ${fundProductCode}</go:log>
<go:log>realPath: ${realPath}</go:log>
<go:log>saveLocation: ${saveLocation}</go:log>


<?xml version="1.0" encoding="UTF-8"?>
<result>
	<c:choose>
		<c:when test="${empty transId or empty fundProductCode or empty provider}">
			<success>false</success>
			<errors>
				<error><code>1</code><text>Invalid application data (missing transactionId, FundProductCode or provider).</text></error>
			</errors>
		</c:when>
		<c:otherwise>
			<%-- CSV FORMAT OUTPUT --%>
			<c:set var="output">
				<x:forEach select="$applicationXml/xml/data/node()" var="node" varStatus="loop">
					<%-- HEADER --%>
					<x:choose>
						<x:when select="$node/@name"><x:out select="$node/@name" /></x:when>
						<x:otherwise><x:out select="name($node)" /></x:otherwise>
					</x:choose>
					<c:out value="," escapeXml="false" />
					<%-- VALUE --%>
					<x:choose>
						<x:when select="name($node) = 'SaleCompletedTime'">
							<c:set var="val">${datetime}</c:set>
						</x:when>
						<x:otherwise>
							<c:set var="val"><x:out select="$node" escapeXml="false" /></c:set>
						</x:otherwise>
					</x:choose>
					<%-- This looks shit but is a way to stop Excel from auto-formatting the values --%>
					<%-- http://stackoverflow.com/questions/165042/stop-excel-from-automatically-converting-certain-text-values-to-dates --%>
					<c:out value="${quote}=${quote}${quote}" escapeXml="false" />
					<c:out value="${fn:replace(val, quote, '')}" escapeXml="false" />
					<c:out value="${quote}${quote}${quote}" escapeXml="false" />
					${newLineChar}
				</x:forEach>
			</c:set>

			<c:set var="saveSuccess" value="false" />
			<c:catch var="error">
				<c:if test="${not empty saveLocation}">
					<go:log>Writing to: ${zipFilenameWithPath}</go:log>
					<c:set var="saveSuccess" value="${go:writeToEncZipFile(zipFilenameWithPath, output, internalName, zipPassword)}" />
				</c:if>
				<%--
				WAITING ON PRJAGGH-599
				<c:if test="${not empty exportHost}">
					<go:log>Uploading ${zipFilename} to ${exportHost}</go:log>
					<c:set var="saveSuccess" value="${go:writeToEncZipToSftp(zipFilename, output, internalName, zipPassword, exportHost, exportUsername, exportPassword)}" />
				</c:if>
				--%>
			</c:catch>

			<c:choose>
				<c:when test="${saveSuccess != true}">
					<success>false</success>
					<errors>
						<error><code>2</code><text>Write to secure file failed.</text></error>
					</errors>
				</c:when>

				<c:when test="${not empty error}">
					<success>false</success>
					<errors>
						<error><code>4</code><text>${error.rootCause}</text></error>
					</errors>
				</c:when>

				<c:when test="${not empty saveLocation and file:exists(zipFilenameWithPath) == false}">
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
