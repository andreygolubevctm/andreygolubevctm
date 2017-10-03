<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a radio button input."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"	 	rtexprvalue="true"	description="variable's xpath" %>
<%@ attribute name="required" 			required="true"	 	rtexprvalue="true"	description="is this field required?" %>
<%@ attribute name="className" 			required="false" 	rtexprvalue="true"	description="additional css class attribute" %>
<%@ attribute name="title" 				required="true"	 	rtexprvalue="true"	description="The radio button's title"%>
<%@ attribute name="value" 				required="true"	 	rtexprvalue="true"	description="The radio buttons's value"%>
<%@ attribute name="label" 				required="false" 	rtexprvalue="true"	description="A label for the radio button, set to 'true'. Value can be defined in the title attribute"%>
<%@ attribute name="errorMsg"			required="false" 	rtexprvalue="true"	description="Optional custom validation error message"%>
<%@ attribute name="theme"	 			required="false" 	rtexprvalue="true"	description="if the radio button should be custom styled (see style.css to check what themes are available)" %>
<%@ attribute name="id" 				required="false"	rtexprvalue="true"	description="override the id" %>
<%@ attribute name="helpId" 			required="false"	rtexprvalue="true"	%>
<%@ attribute name="helpClassName" 		required="false"	rtexprvalue="true"	%>
<%@ attribute name="helpPosition" 		required="false"	rtexprvalue="true"	%>
<%@ attribute name="customAttribute"	required="false"	rtexprvalue="true" description="Add a custom attribute to the element." %>
<%@ attribute name="radioButtonClassName" %>
<%@ attribute name="additionalLabelAttributes"	required="false"	rtexprvalue="true" description="Add attributes to the label element." %>
<%@ attribute name="additionalHelpAttributes"	required="false"	rtexprvalue="true" description="Add attributes to the help icon element." %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.benefits')}" />

<%-- VARIABLES --%>
<c:set var="name" value="radio-group" />
<c:set var="xpathval"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:set var="checked" value="" />

<c:if test='${xpathval==value}'>
    <c:set var="checked" value=" checked='checked'" />
</c:if>

<c:if test="${not empty customAttribute}">
    <c:set var="customAttribute" value="${customAttribute}" />
</c:if>


<c:choose>
    <c:when test="${not empty theme}">
        <c:set var="className" value="${className} checkbox-${theme}" />
        <c:set var="radioButtonClassName" value="${radioButtonClassName} checkbox-${theme}" />
    </c:when>
    <c:otherwise>
        <c:set var="className" value="${className} radio" />
        <c:set var="radioButtonClassName" value="${radioButtonClassName} radio" />
    </c:otherwise>
</c:choose>

<c:if test="${empty id}">
    <c:set var="id" value="${go:nameFromXpath(xpath)}" />
</c:if>

<%-- VALIDATION --%>
<c:if test="${required}">
    <c:set var="errorMsg">
        <c:choose>
            <c:when test="${empty errorMsg}">Please tick the ${fn:escapeXml(title)}</c:when>
            <c:otherwise>${errorMsg}</c:otherwise>
        </c:choose>
    </c:set>

    <c:set var="radioButtonRule">
        data-msg-required='${errorMsg}'
    </c:set>

    <c:set var="requiredAttr" value=" required " />
</c:if>

<%-- HTML --%>
<div class="${className}">
    <input type="radio" name="${name}" id="${id}" class="radioButton-custom ${radioButtonClassName}" value="${value}"${checked} ${customAttribute} ${requiredAttr} ${radioButtonRule}>

    <label for="${id}" ${additionalLabelAttributes}>
        <c:if test="${label!=null && not empty label}">${title}</c:if>
        <c:if test="${not empty helpId}">
            <field_v2:help_icon helpId="${helpId}" position="${helpPosition}" tooltipClassName="${helpClassName}" additionalAttributes="${additionalHelpAttributes}" />
        </c:if>
    </label>
</div>
