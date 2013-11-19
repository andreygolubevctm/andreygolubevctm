<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:setData dataVar="data" value="*DELETE" xpath="*" />

<core:doctype />
<html>
	<head>
		<link rel='stylesheet' type='text/css' href='common/js/treeview/jquery.treeview.css' />
		<link rel='stylesheet' type='text/css' href='common/js/treeview/screen.css' />
		<link rel='stylesheet' type='text/css' href='common/data.css' />
		<script type="text/javascript" src="common/js/jquery-1.4.2.min.js"></script>
		<script type="text/javascript" src="common/js/jquery.treeview.js"></script>
	</head>
	<body>
		<c:import var="prettyXml" url="/WEB-INF/xslt/pretty_xml.xsl"/>
		<c:forEach items="${data['*']}" var="node">
			<c:set var="tempXml" value="${go:getXml(node)}" />
			<c:set var="tempXml" value="${fn:replace(tempXml,'&','&amp;')}" />

			<x:transform xml="${tempXml}" xslt="${prettyXml}"/>
		</c:forEach>
		<go:style marker="css-href" href="" />
		<go:style marker="css-href" href="" />
		<go:style marker="css-href" href="" />
		<go:script marker="js-href" href="" />
	</body>
</html>