<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:core />

<c:choose>
	<c:when test="${empty applicationService.getBrandCodeFromPageContext(pageContext)}">
		ERROR
	</c:when>
	<c:otherwise>

		<settings:setVertical verticalCode="GENERIC" />


		<jsp:useBean id="date" class="java.util.Date" />


		<c:set var="pageTitle" value="404" />

		<%@ include file="/WEB-INF/err/errorHeader.jsp" %>

				<div class="clearfix normal-header" id="header">
					<div class="inner-header">
						<h1><a title="Compare the Market" href="http://www.comparethemarket.com.au/">Compare the Market</a></h1>
					</div>
				</div>
				<div id="wrapper" class="clearfix">
					<div id="page" class="clearfix">
						<div id="content">
							<h1 class="error_title">Whoops, sorry… </h1>
							<div class="error_message">
								<h2>looks like you're looking for something that isn't there!</h2>
								<p>Sorry about that, but the page you're looking for can't be found. Either you've typed the web address incorrectly, or the page you were looking for has been moved or deleted.</p>
								<p>Try checking the URL you used for errors.</p>
							</div>
						</div>
						<div class="clearfix"></div>
					</div>
				</div>

				<agg:generic_footer />

				<core:closing_body />

		<%@ include file="/WEB-INF/err/errorFooter.jsp" %>
	
	</c:otherwise>
</c:choose>
