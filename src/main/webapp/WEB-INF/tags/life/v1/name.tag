<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical" 	required="false" rtexprvalue="true"	 description="the root xpath for the vertical" %>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="data xpath" %>
<%@ attribute name="error_phrase" required="false" rtexprvalue="true" description="Text for client side validation error" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}"/>

<form_v1:row label="First name" className="halfrow">
	<field_v1:input xpath="${xpath}/firstName" title="${error_phrase}first name" required="true" size="13" />
</form_v1:row>

<go:validate selector="${name}_firstName" rule="personName" parm="true" />

<c:if test="${empty vertical or (vertical != 'life' and vertical != 'ip')}">
	<form_v1:row label="Surname" className="halfrow right">
		<field_v1:input xpath="${xpath}/lastname" title="${error_phrase}surname" required="true" size="13" />
	</form_v1:row>
	
	<go:validate selector="${name}_lastname" rule="personName" parm="true" />
</c:if>
