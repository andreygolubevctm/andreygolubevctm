<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a checkbox input."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The checkbox's title"%>
<%@ attribute name="value" 		required="true"	 rtexprvalue="true"	 description="The checkbox's value"%>
<%@ attribute name="label" 		required="false" rtexprvalue="true"	 description="A label for the checkbox, set to 'true'. Value can be defined in the title attribute"%>
<%@ attribute name="errorMsg"	required="false" rtexprvalue="true"	 description="Optional custom validation error message"%>
<%@ attribute name="theme"	 	required="false" rtexprvalue="true"	 description="if the checkbox should be custom styled (see style.css to check what themes are available)" %>
<%@ attribute name="helpId" 	required="false" rtexprvalue="true"  description="The checkbox help id (if non provided, help is not shown)"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="xpathval"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:set var="checked" value="" />

<c:if test='${xpathval==value}'>
	<c:set var="checked" value=" checked='checked'" />
</c:if>

<%-- HTML --%>
<c:if test="${not empty theme}"><c:set var="className" value="${className} ${theme}Checkbox customCheckbox" /></c:if>
<input type="checkbox" name="${name}" id="${name}" class="${className}" value="${value}"${checked}>

<c:if test='${label!=null && not empty label}'>
	<label for="${name}">${title}</label>
</c:if>

<c:if test="${helpId != null && helpId != ''}">
	<div class="help_icon" id="help_${helpId}"></div>
</c:if>

<%-- VALIDATION --%>
<c:if test="${required}">

	<c:set var="errorMsg">
		<c:choose>
			<c:when test="${empty errorMsg}">Please enter the ${fn:escapeXml(title)}</c:when>
			<c:otherwise>${errorMsg}</c:otherwise>
		</c:choose>
	</c:set>

	<go:validate selector="${name}" rule="required" parm="true" message="${errorMsg}"/>
</c:if>