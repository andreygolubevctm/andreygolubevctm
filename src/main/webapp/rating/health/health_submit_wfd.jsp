<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}" />

<% pageContext.setAttribute("newLineChar", "\n"); %>
<% pageContext.setAttribute("quote", "\""); %>
<%--

	VERSION 2
	This page can:
	* Convert application data to CSV and store in an encrypted ZIP file on disk
	* Convert application data to CSV, store in an encrypted ZIP file and upload to an SFTP

	To comply with PCI:
	* No plain text is saved to disk
	* Application data is streamed from memory straight into an encrypted ZIP file, and optionally then streamed straight into an SFTP connection.

	This page is processed through the SOAP Aggregator in ajax/json/health_application.jsp, so this page receives XML as the POST body.

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
${logger.debug('Got body content: {},{}', log:kv('contentLength', pageContext.request.contentLength), log:kv('body',body))}
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
<c:set var="saveLocation">
	<x:out select="$configXml//*[name()='export']/*[name()='save-location']" />
</c:set>
<c:if test="${not empty saveLocation and !fn:endsWith(saveLocation, '/')}">
	<c:set var="saveLocation">${saveLocation}/</c:set>
</c:if>
<c:if test="${fn:startsWith(saveLocation, 'aggregator/')}">
	<c:set var="saveLocation">${realPath}WEB-INF/${saveLocation}</c:set>
</c:if>

<c:set var="zipPassword"><x:out select="$configXml//*[name()='soap-password']" /></c:set>
<c:set var="exportHost"><x:out select="$configXml//*[name()='export']/*[name()='host']" /></c:set>
<c:set var="exportUsername"><x:out select="$configXml//*[name()='export']/*[name()='username']" /></c:set>
<c:set var="exportPassword"><x:out select="$configXml//*[name()='export']/*[name()='password']" /></c:set>

<c:set var="zipFilenameWithPath" value="${saveLocation}wfd_${transId}_${millisecs}.zip" />
<c:set var="zipFilename" value="wfd_${transId}_${millisecs}.zip" />
<c:set var="internalName" value="application_${transId}.csv" />
${logger.debug('transId: {},{},{},{}', log:kv('transId', transId), log:kv('fundProductCode', fundProductCode), log:kv('realPath', realPath), log:kv('saveLocation', saveLocation))}
<?xml version="1.0" encoding="UTF-8"?>
<result>
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

			<c:set var="writeSuccess" value="false" />
			<c:catch var="error">
				<c:if test="${not empty saveLocation}">
					${logger.debug('Writing to saveLocation. {}', log:kv('zipFilenameWithPath',zipFilenameWithPath ))}
					<c:set var="writeSuccess" value="${go:writeToEncZipFile(zipFilenameWithPath, output, internalName, zipPassword)}" />
				</c:if>
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
