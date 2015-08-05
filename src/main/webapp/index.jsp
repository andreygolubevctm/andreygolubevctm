<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="GENERIC" />

<layout:generic_page title="Health Quote">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>


	<jsp:attribute name="header">

	</jsp:attribute>

	<jsp:attribute name="navbar">


	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<core:whitelabeled_footer />
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

    <jsp:body>
		<h1 class="error_title">Whoops, sorry… </h1>
		<div class="error_message">
			<h2>looks like you're looking for something that isn't there!</h2>
			<p>Sorry about that, but the page you're looking for can't be found. Either you've typed the web address incorrectly, or the page you were looking for has been moved or deleted.</p>
			<p>Try checking the URL you used for errors.</p>
		</div>

        <confirmation:other_products />
    </jsp:body>

</layout:generic_page>
