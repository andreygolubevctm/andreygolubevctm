<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:import var="manifestContent" url="/META-INF/MANIFEST.MF"/>
<c:set var="buildIdentifier"><core:buildIdentifier></core:buildIdentifier></c:set>
<c:set var="remoteAddr" value="${pageContext.request.remoteAddr}" />

<jsp:useBean id="sessionDataService" class="com.ctm.services.SessionDataService" scope="application" />


<core:doctype />
<html>
	<head>
		<link rel='stylesheet' type='text/css' href='common/js/treeview/jquery.treeview.css' />
		<link rel='stylesheet' type='text/css' href='common/js/treeview/screen.css' />
		<link rel='stylesheet' type='text/css' href='common/data.css' />
		<script type="text/javascript" src="common/js/jquery-1.4.2.min.js"></script>
		<script type="text/javascript" src="common/js/jquery.treeview.js"></script>
		<style type="text/css">
			#buildIdentifierRow { margin:0; padding:0.5em 1em; }
			#buildIdentifier { color:#930; }
			h1{
				padding: 10px 0px;
			}

			table{
				border-collapse: collapse;
			}
			table th{
				background-color: #666;
				border:1px solid #333;
				color:#fff;
			}
			table td{
				border:1px solid #ccc;
			}
		</style>
	</head>
	<body>
			<p id="buildIdentifierRow"><strong>Build Identifier: </strong><span id="buildIdentifier"><c:out value="${buildIdentifier}" /></span></p>

		<%-- SECURITY  FEATURE --%>
		<c:if test="${ remoteAddr == '127.0.0.1' or remoteAddr == '0.0.0.0' or remoteAddr == '0:0:0:0:0:0:0:1' or fn:startsWith(remoteAddr, '192.168.') or (not empty(param.bucket) and param.bucket == '1') or (not empty(param.preload) and param.preload == '2') }">
		<c:import var="prettyXml" url="/WEB-INF/xslt/pretty_xml.xsl"/>
		
		<c:if test="${not empty data}">
			<div style="background-color:#FFD7D7">
				<h1 style="color:red">OLD BUCKET IN SESSION FYI THIS SHOULD NOT EXIST </h1>
				<x:transform xml="${data.getXML()}" xslt="${prettyXml}"/>	
			</div>		
		</c:if>

		<c:if test="${not empty sessionData}">

				${sessionDataService.cleanUpSessions(sessionData)}

			<c:if test="${not empty sessionData.authenticatedSessionData}">
				<div style="background-color:#FEFAD8;padding:10px;border-bottom:1px solid #ccc;">
					<h1 >Authenticated Session Data </h1>
					<x:transform xml="${sessionData.authenticatedSessionData.getXML()}" xslt="${prettyXml}"/>					
				</div>		
			</c:if>

			<ol>
			<c:forEach items="${sessionData.getTransactionSessionData()}" var="data">
				<li><a href="#${data['current/transactionId']}">${data['current/verticalCode']} / ${data['current/transactionId']}</a></li>
			</c:forEach>
			</ol>
			<c:forEach items="${sessionData.getTransactionSessionData()}" var="data">
				<div style="background-color:#fff;padding:10px;border-bottom:1px solid #ccc;">
					
					<div style="background-color:#eee;padding:10px;margin-bottom:10px;">
						<a name="${data['current/transactionId']}" ></a>
						<h1>${data['current/verticalCode']} / ${data['current/transactionId']}</h1>
						<em>Last accessed by session data service on ${data.getLastSessionTouch()}</em>
					</div>
					
					<c:catch var ="catchException">
		<c:forEach items="${data['*']}" var="node">
				<c:set var="tempXml" value="${go:getEscapedXml(node)}" />
			<x:transform xml="${tempXml}" xslt="${prettyXml}"/>
		</c:forEach>
					</c:catch>

					<c:if test = "${catchException != null}">
						<x:transform xml="${data.getXML()}" xslt="${prettyXml}"/>	
		</c:if>
					
				</div>
			</c:forEach>
		</c:if>
				


		<c:set var="serverIp">
			<% String ip = request.getLocalAddr();
			try {
				java.net.InetAddress address = java.net.InetAddress.getLocalHost();
				ip = address.getHostAddress();
			}
			catch (Exception e) {}
			%>
			<%= ip %>
		</c:set>

		<h4>Session debug information</h4>
		<table>
			<tr>
				<th>Field</th>
				<th>Value</th>
			</tr>
			<tr>
				<td>Session ID</td>
				<td><%=session.getId()%></td>
			</tr>
			<tr>
					<td>Server IP</td>
					<td>${serverIp}</td>
				</tr>
				<tr>
					<td>Is New</td>
					<td><%=session.isNew()%></td>
				</tr>
				<tr>
					<td>Session Created</td>
					<td><%=new Date(session.getCreationTime())%></td>
				</tr>
				<tr>
					<td>Session Last Accessed</td>
					<td><%=new Date(session.getLastAccessedTime())%></td>
				</tr>
				<tr>
				<td>Client remoteAddr</td>
				<td>${pageContext.request.remoteAddr}</td>
			</tr>
			<tr>
				<td>Client remoteHost</td>
				<td>${pageContext.request.remoteHost}</td>
			</tr>
			<tr>
				<td>Header: HTTP_CLIENT_IP</td>
				<td><%=request.getHeader("HTTP_CLIENT_IP")%></td>
			</tr>
			<tr>
				<td>Header: Proxy-Client-IP</td>
				<td><%=request.getHeader("Proxy-Client-IP")%></td>
			</tr>			
			<tr>
				<td>Header: X-FORWARDED-FOR</td>
				<td><%=request.getHeader("X-FORWARDED-FOR")%></td>
			</tr>
			<tr>
				<td>SessionData session scoped variable?</td>
				<td><c:if test="${not empty sessionData}">YES, with ${sessionData.transactionSessionData.size()} buckets.</c:if><c:if test="${empty sessionData}">NO</c:if></td>
			</tr>
		</table>
				
		</c:if>
				
	</body>
</html>