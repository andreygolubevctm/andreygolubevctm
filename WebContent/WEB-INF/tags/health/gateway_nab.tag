<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="External payment: Credit Card popup"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

	<%-- ATTRIBUTES --%>
	<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

	<%-- VARIABLES --%>
	<c:set var="name" value="${go:nameFromXpath(xpath)}" />

	<field:hidden xpath="${xpath}/nab/cardNumber" />
	<field:hidden xpath="${xpath}/nab/cardName" />
	<field:hidden xpath="${xpath}/nab/crn" />
	<field:hidden xpath="${xpath}/nab/rescode" />
	<field:hidden xpath="${xpath}/nab/restext" />
	<field:hidden xpath="${xpath}/nab/expiryMonth" />
	<field:hidden xpath="${xpath}/nab/expiryYear" />
	<field:hidden xpath="${xpath}/nab/cardType" />