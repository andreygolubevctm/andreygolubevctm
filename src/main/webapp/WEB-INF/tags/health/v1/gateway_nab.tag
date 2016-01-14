<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="External payment: Credit Card popup"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

	<%-- ATTRIBUTES --%>
	<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

	<%-- VARIABLES --%>
	<c:set var="name" value="${go:nameFromXpath(xpath)}" />

	<field_v1:hidden xpath="${xpath}/nab/cardNumber" />
	<field_v1:hidden xpath="${xpath}/nab/cardName" />
	<field_v1:hidden xpath="${xpath}/nab/crn" />
	<field_v1:hidden xpath="${xpath}/nab/rescode" />
	<field_v1:hidden xpath="${xpath}/nab/restext" />
	<field_v1:hidden xpath="${xpath}/nab/expiryMonth" />
	<field_v1:hidden xpath="${xpath}/nab/expiryYear" />
	<field_v1:hidden xpath="${xpath}/nab/cardType" />