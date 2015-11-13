<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="GENERIC" />

<c:set var="baseUrl" value="${pageSettings.getBaseUrl()}" />

<%-- This page is ONLY to be loaded into a frame using the core loadsafe function --%>

<core:doctype />
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Loading your page...</title>
	<meta name="description" content="Generic page loader">
	<style>
		html, body {
			padding:0;
			margin:0;
			width:100%;
			height:100%;
		}
		#dump {
			display:none;
		}
		#loading-popup {
			position:absolute;
			top:50%;
			height:300px;
			margin-top:-150px;
			left:50%;
			width:500px;
			margin-left:-250px;
			background:#fefefe url(${baseUrl}brand/ctm/images/loading_ctm.png) top left no-repeat;
		}
		#loading-popup div {
			position:relative;
			width:452px;
			height:250px;
			margin: 27px 24px
		}
		#loading-popup span {
		}
		#loading-anim {
			display:inline-block;
			background: url(${baseUrl}common/images/loading.gif) no-repeat scroll left top transparent;
			height: 49px;
			width: 452px;
			top: 185px;
			position: absolute;
		}
		#loading-message {
			display:block;
			width:452px;
			text-align:center;
			color:#333333;
			font-family:"SunLT Light",Arial,Helvetica,sans-serif;
			font-size:19px;
			font-weight:bold;
			line-height:23px;
		}
	</style>
</head>
<body>
	<div id="loading-popup">
		<div>
			<span id="loading-anim"></span>
			<span id="loading-message">Your page is loading...</span>
		</div>
	</div>
</body>
</html>