<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Postcode"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<c:set var="fieldXpath" value="${xpath}/postcode" />
<form_v3:row label="Postcode" fieldXpath="${fieldXpath}" className="clear required_input">
	<field_v1:post_code xpath="${fieldXpath}" title="postcode" required="true"  />
</form_v3:row>