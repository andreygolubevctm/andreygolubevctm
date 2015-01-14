<%@ tag description="Policy Holders" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Test if we have a commencement date already set - if not then set to today--%>
<c:if test="${empty data[name]}">
	<jsp:useBean id="now" class="java.util.Date" />
	<fmt:formatDate var="commencementDate" value="${now}" pattern="dd/MM/yyyy"/>
	<go:setData dataVar="data" xpath="${xpath}" value="${commencementDate}" />
</c:if>

<c:set var="fieldXpath" value="${xpath}" />
<form_new:row fieldXpath="${fieldXpath}" label="Commencement date" className="${xpath}_startDateFieldset" helpId="500">
	<field_new:commencement_date xpath="${fieldXpath}" mode="separated" includeMobile="false" />
</form_new:row>