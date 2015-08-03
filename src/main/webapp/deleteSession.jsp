<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<c:remove var="sessionData"/>
<c:remove var="data"/>
<c:remove var="authenticatedData"/>
<c:remove var="callCentre"/>

<% session.invalidate(); %>


<core:doctype />
<html>
	<head>
		<title>Deleting your session data</title>
		<style>
			@font-face {
				font-family: SourceSansProRegular;
				src:url('framework/fonts/SourceSansPro-Regular.eot');
				src:url('framework/fonts/SourceSansPro-Regular.eot?#iefix') format('embedded-opentype'),
				url('framework/fonts/SourceSansPro-Regular.woff') format('woff'),
				url('framework/fonts/SourceSansPro-Regular.ttf') format('truetype'),
				url('framework/fonts/SourceSansPro-Regular.svg#SourceSansProRegular') format('svg');
				font-weight: normal;
				font-style: normal;
			}
			body {
				color: #fff;
				background-color: #1c3e93;
				text-align: center;
				font-family: SourceSansProRegular, Arial, Helvetica, San-serif;
			}
			#center {
				background-color: #0db14b;
				width: 80%;
				margin: 0 auto;
				height: 400px;
				padding: 20px 0;
			}
			a:visited {
				color: #1c3e93;
			}
		</style>
	</head>
	<body>
	<div id="center">
		<h1>Sergei has cleaned up your session</h1>
		<img src="common/images/Sergei.jpg" alt="Sergei" />
		<h2><a href="data.jsp">Visit Data Bucket</a></h2>
		<p>(in case he didn't do it properly)</p>
	</div>
	</body>
</html>