<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:import var="manifestContent" url="/META-INF/MANIFEST.MF"/>
<c:set var="buildIdentifier"><core:buildIdentifier></core:buildIdentifier></c:set>
<c:set var="remoteAddr" value="${pageContext.request.remoteAddr}" />

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
		</style>
	</head>
	<body>
			<p id="buildIdentifierRow"><strong>Build Identifier: </strong><span id="buildIdentifier"><c:out value="${buildIdentifier}" /></span></p>

		<%-- SECURITY  FEATURE --%>
		<c:if test="${ remoteAddr == '127.0.0.1' or remoteAddr == '0.0.0.0' or remoteAddr == '0:0:0:0:0:0:0:1' or fn:startsWith(remoteAddr, '192.168.') or (not empty(param.bucket) and param.bucket == '1') or (not empty(param.preload) and param.preload == '2') }">
		<c:import var="prettyXml" url="/WEB-INF/xslt/pretty_xml.xsl"/>
		</c:if>


		<c:if test="${not empty data}">
			<div style="background-color:#FFD7D7">
				<h1 style="color:red">OLD BUCKET IN SESSION FYI THIS SHOULD NOT EXIST </h1>
				<x:transform xml="${data.getXML()}" xslt="${prettyXml}"/>	
			</div>		
		</c:if>

		<c:if test="${not empty sessionData}">

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
				
	</body>
</html>