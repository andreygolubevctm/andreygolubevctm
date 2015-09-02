<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents numeric field." %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="variable's xpath" %>
<%@ attribute name="required" required="true" rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="id" required="true" rtexprvalue="true" description="Id attribute for panel" %>
<%@ attribute name="maxLength" required="true" rtexprvalue="true" description="maximum number of digits" %>
<%@ attribute name="className" required="false" rtexprvalue="true" description="additional css class attribute" %>
<%@ attribute name="validationMessage" required="false" rtexprvalue="true" description="validation message" %>
<%@ attribute name="title" required="false" rtexprvalue="true" description="Set a title for the validation message" %>
<%@ attribute name="maxValue" required="false" rtexprvalue="true" description="Set a maximum number for input value" %>
<%@ attribute name="minValue" required="false" rtexprvalue="true" description="Set a minimum number for input value" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}"/>
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:set var="id" value="${name}"/>

<%-- VALIDATION --%>
<c:set var="validationAttributes" value=""/>
<c:if test="${required}">
    <c:set var="validationAttributes"> required<c:if test="${not empty validationMessage}"> data-msg-required="${validationMessage}"</c:if> </c:set>
</c:if>

<c:if test="${not empty maxValue}">
    <c:set var="validationAttributes">${validationAttributes} data-rule-max="${maxValue}" data-msg-max="The ${title} value cannot be higher than ${maxValue}" </c:set>
</c:if>

<c:if test="${not empty minValue}">
    <c:set var="validationAttributes">${validationAttributes} data-rule-min="${minValue}" data-msg-min="The ${title} value cannot be lower than ${minValue}" </c:set>
</c:if>

<%-- HTML --%>
<input type="text" name="${name}" id="${id}" class="${className} numeric" value="${value}" maxlength="${maxLength}" ${validationAttributes}>