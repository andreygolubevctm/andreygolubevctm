<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" isErrorPage="true" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<c:set var="pageTitle" value="System Error" />

<%@ include file="/WEB-INF/security/pageHeader.jsp" %>
<div class="fieldrow"><div class="fieldrow_label"></div><div class="fieldrow_value">Sorry, a system error has occurred.</div></div>
<div class="fieldrow button-wrapper"><a id="next-step" href="<c:url value="/security/simples_logout.jsp" />"><span>Continue</span></a></div>
<%@ include file="/WEB-INF/security/pageFooter.jsp" %>
