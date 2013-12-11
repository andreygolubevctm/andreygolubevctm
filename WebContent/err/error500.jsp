<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="date" class="java.util.Date" />


<c:set var="pageTitle" value="500" />

<%@ include file="/WEB-INF/err/errorHeader.jsp" %>

		<div class="clearfix normal-header" id="header">
			<div class="inner-header">
				<h1><a title="Compare the Market" href="http://www.comparethemarket.com.au/">Compare the Market</a></h1>
			</div>
		</div>
		<div id="wrapper" class="clearfix">
			<div id="page" class="clearfix">
				<div id="content">
					<h1 class="error_title">Whoops, sorry… 500 Internal server error.</h1>
					<div class="error_message">
						<h2>looks like something went wrong.</h2>
						<p>You have experienced a technical error. We apologise.</p>
						<p>We are working to correct this issue. Please wait a few moments and try again.</p>
					</div>
				</div>
				<div class="clearfix"></div>
			</div>
		</div>

		<agg:generic_footer />

		<core:closing_body />

<%@ include file="/WEB-INF/err/errorFooter.jsp" %>