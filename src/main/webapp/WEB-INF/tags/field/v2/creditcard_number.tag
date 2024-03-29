<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's name on credit card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="placeHolder"			required="false" rtexprvalue="true"	 description="Placeholder text" %>

<%-- VARIABLES --%>
<c:set var="creditcardnumber" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- HTML --%>
<field_v2:input pattern="[0-9]*" xpath="${xpath}" className="creditcard_number ${className}" maxlength="21" required="${required}" title="${title}" additionalAttributes=" data-rule-creditCardNumber='${required}' " placeHolder="${placeHolder}" />