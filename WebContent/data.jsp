<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<c:import var="manifestContent" url="/META-INF/MANIFEST.MF"/>
<c:set var="buildIdentifier" value="" />
<c:forTokens items="${manifestContent}" var="manifestEntry" delims="
">
	<c:if test="${ empty buildIdentifier and not empty manifestEntry and fn:startsWith(manifestEntry, 'Identifier: ') }">
		<c:set var="buildIdentifier" value="${fn:trim(fn:substringAfter(manifestEntry, 'Identifier: '))}" />
	</c:if>
</c:forTokens>
<c:if test="${ empty buildIdentifier }">
	<c:choose>
		<c:when test="${ pageContext.request.localName == 'localhost' }">
			<c:set var="buildIdentifier" value="Local Dev Environment" />
		</c:when>
		<c:otherwise>
			<c:set var="buildIdentifier" value="Undefined (dev or legacy environment)" />
		</c:otherwise>
	</c:choose>
</c:if>
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
		</style>
	</head>
	<body>
			<p id="buildIdentifierRow"><strong>Build Identifier: </strong><span id="buildIdentifier"><c:out value="${buildIdentifier}" /></span></p>

		<%-- SECURITY  FEATURE --%>
		<c:if test="${ remoteAddr == '127.0.0.1' or remoteAddr == '0.0.0.0' or remoteAddr == '0:0:0:0:0:0:0:1' or fn:startsWith(remoteAddr, '192.168.') or (not empty(param.bucket) and param.bucket == '1') or (not empty(param.preload) and param.preload == '2') }">
		<c:import var="prettyXml" url="/WEB-INF/xslt/pretty_xml.xsl"/>
		<c:forEach items="${data['*']}" var="node">
				<c:set var="tempXml" value="${go:getEscapedXml(node)}" />
				<%-- <c:set var="tempXml" value="${fn:replace(tempXml,'&','&amp;')}" /> --%>
			<x:transform xml="${tempXml}" xslt="${prettyXml}"/>
		</c:forEach>
		</c:if>
	</body>
</html>