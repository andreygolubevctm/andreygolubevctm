<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<settings:setVertical verticalCode="SIMPLES" />

<layout:simples_page>

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:body>
		<h2>Sorry, you aren't authorised to view this page.</h2>
		<p>Please see your Call Centre Lead or CTM IT for getting access.</p>
		<p><a id="next-step" href="/${pageSettings.getContextFolder()}security/simples_logout.jsp" class="btn btn-cta">Log Out</a></p>
	</jsp:body>

</layout:simples_page>
