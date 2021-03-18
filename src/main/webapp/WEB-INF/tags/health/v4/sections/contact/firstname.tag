<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Firstname of a person"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<c:set var="fieldXpath" value="${xpath}/name" />
<form_v4:row label="Your first name" fieldXpath="${fieldXpath}" className="clear required_input">
	<field_v1:person_name xpath="${fieldXpath}" title="name" required="true" maxlength="24" className="data-hj-suppress" />
</form_v4:row>