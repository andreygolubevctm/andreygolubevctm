<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Email Address"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<c:set var="required" value="${true}" />
<c:if test="${callCentre}">
	<c:set var="required" value="${false}" />
</c:if>

<c:set var="fieldXpath" value="${xpath}/email" />
<form_v4:row label="Your email address" fieldXpath="${fieldXpath}" className="clear required_input">
	<field_v2:email xpath="${fieldXpath}" title="your email address" required="${required}" className="data-hj-suppress"  />
	<field_v1:hidden xpath="${xpath}/emailsecondary" />
	<field_v1:hidden xpath="${xpath}/emailhistory" />
</form_v4:row>