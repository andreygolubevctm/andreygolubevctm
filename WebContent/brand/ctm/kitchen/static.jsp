<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ include file="/WEB-INF/include/page_vars.jsp" %>

<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>CTM Template for Bootstrap</title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="../graphics/favicon.png">

		<link rel="stylesheet" href="../../../brand/ctm/css/ctm.min.css">
		<link rel="stylesheet" href="../../../brand/ctm/css/health.ctm.min.css">
	
		<%@include file="../../../framework/kitchen/headjs.html" %>
	</head>
	<body>
		<!--[if lt IE 7]>
			<p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
		<![endif]-->

		<%@include file="../../../framework/kitchen/components.html" %>
		<%@include file="../../../framework/kitchen/grid.html" %>
		<%@include file="../../../framework/kitchen/footerjs.html" %>

		<script src="../../../brand/ctm/js/bootstrap.ctm.min.js"></script>
		<script src="../../../brand/ctm/js/modules.ctm.min.js"></script>
		<script src="../../../brand/ctm/js/health.modules.ctm.min.js"></script>
	</body>
</html>