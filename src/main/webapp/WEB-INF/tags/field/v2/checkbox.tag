<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a checkbox input."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"	 	rtexprvalue="true"	description="variable's xpath" %>
<%@ attribute name="required" 			required="true"	 	rtexprvalue="true"	description="is this field required?" %>
<%@ attribute name="className" 			required="false" 	rtexprvalue="true"	description="additional css class attribute" %>
<%@ attribute name="title" 				required="true"	 	rtexprvalue="true"	description="The checkbox's title"%>
<%@ attribute name="value" 				required="true"	 	rtexprvalue="true"	description="The checkbox's value"%>
<%@ attribute name="label" 				required="false" 	rtexprvalue="true"	description="A label for the checkbox, set to 'true'. Value can be defined in the title attribute"%>
<%@ attribute name="errorMsg"			required="false" 	rtexprvalue="true"	description="Optional custom validation error message"%>
<%@ attribute name="theme"	 			required="false" 	rtexprvalue="true"	description="if the checkbox should be custom styled (see style.css to check what themes are available)" %>
<%@ attribute name="id" 				required="false"	rtexprvalue="true"	description="override the id" %>
<%@ attribute name="helpId" 			required="false"	rtexprvalue="true"	%>
<%@ attribute name="helpClassName" 		required="false"	rtexprvalue="true"	%>
<%@ attribute name="helpPosition" 		required="false"	rtexprvalue="true"	%>
<%@ attribute name="helpTextShowLink" 	required="false"	rtexprvalue="true"	%>
<%@ attribute name="helpTextLinkText" 	required="false"	rtexprvalue="true"	%>
<%@ attribute name="customAttribute"	required="false"	rtexprvalue="true" description="Add a custom attribute to the element." %>
<%@ attribute name="checkBoxClassName" %>
<%@ attribute name="additionalLabelAttributes"	required="false"	rtexprvalue="true" description="Add attributes to the label element." %>
<%@ attribute name="additionalHelpAttributes"	required="false"	rtexprvalue="true" description="Add attributes to the help icon element." %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.benefits')}" />

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
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
		<c:set var="checkBoxClassName" value="${checkBoxClassName} checkbox-${theme}" />
	</c:when>
	<c:otherwise>
		<c:set var="className" value="${className} checkbox" />
		<c:set var="checkBoxClassName" value="${checkBoxClassName} checkbox" />
	</c:otherwise>
</c:choose>

<c:if test="${empty id}">
	<c:set var="id" value="${name}" />
</c:if>

<%-- VALIDATION --%>
<c:if test="${required}">
	<c:set var="errorMsg">
		<c:choose>
			<c:when test="${empty errorMsg}">Please tick the ${fn:escapeXml(title)}</c:when>
			<c:otherwise>${errorMsg}</c:otherwise>
		</c:choose>
	</c:set>

	<c:set var="checkboxRule">
		data-msg-required='${errorMsg}'
	</c:set>

	<c:set var="requiredAttr" value=" required " />
</c:if>

<%-- HTML --%>
<div class="${className}">
	<input type="checkbox" name="${name}" id="${id}" class="checkbox-custom ${checkBoxClassName}" value="${value}"${checked} ${customAttribute} ${requiredAttr} ${checkboxRule}>

	<label for="${id}" ${additionalLabelAttributes}>
		<c:if test="${label!=null && not empty label}">${title}</c:if>
		<c:if test="${not empty helpId}">
		<field_v2:help_icon helpId="${helpId}" position="${helpPosition}" tooltipClassName="${helpClassName}" additionalAttributes="${additionalHelpAttributes}" showText="${helpTextShowLink}" showTextLabel="${helpTextLinkText}" />
		</c:if>
	</label>
</div>
