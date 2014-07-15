<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<settings:setVertical verticalCode="SIMPLES" />

<layout:simples_page>

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:body>
		<p>Sorry, a system error has occurred.</p>
		<p><a id="next-step" href="${pageSettings.getBaseUrl()}security/simples_logout.jsp" class="btn btn-cta">Continue</a></p>
	</jsp:body>

</layout:simples_page>
