<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="External payment: Credit Card popup"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

	<%-- ATTRIBUTES --%>
	<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

	<%-- VARIABLES --%>
	<c:set var="name" value="${go:nameFromXpath(xpath)}" />

	Westpac number: ${data['health/payment/gateway/number']}

	<field_v1:hidden xpath="${xpath}/number" />
	<field_v1:hidden xpath="${xpath}/type" />
	<field_v1:hidden xpath="${xpath}/expiry" />
	<field_v1:hidden xpath="${xpath}/name" />