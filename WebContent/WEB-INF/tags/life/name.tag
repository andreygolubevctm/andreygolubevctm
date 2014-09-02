<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="data xpath" %>
<%@ attribute name="error_phrase" required="false" rtexprvalue="true" description="Text for client side validation error" %>

<form:row label="First name" className="halfrow">
	<field:input xpath="${xpath}/firstName" title="${error_phrase}first name" required="true" size="13" />
</form:row>

<form:row label="Surname" className="halfrow right">
	<field:input xpath="${xpath}/lastname" title="${error_phrase}surname" required="true" size="13" />
</form:row>