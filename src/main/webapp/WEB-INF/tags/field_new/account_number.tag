<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's name on credit card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 		required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 		required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 			required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="minLength" 		required="false"	 rtexprvalue="true"	 description="Maximum number of digits"%>
<%@ attribute name="maxLength" 		required="false"	 rtexprvalue="true"	 description="Minimum number of digits"%>

<%-- VARIABLES --%>
<c:set var="accountnum" value="${go:nameFromXpath(xpath)}" />

<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- HTML --%>
<field_new:input type="text" xpath="${xpath}" required="${required}" className="account_name numeric ${className}" size="10" maxlength="${maxLength}" title="${title}" pattern="[0-9]*" additionalAttributes=" data-rule-digits='true' data-msg-digits='Please enter ${title}'" />