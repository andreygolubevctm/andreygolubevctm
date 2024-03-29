<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's email address."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"	 description="subject of the input box" %>
<%@ attribute name="size" 		required="false" rtexprvalue="true"	 description="size of the input box" %>
<%@ attribute name="helptext" 	required="false" rtexprvalue="true"	 description="additional help text" %>
<%@ attribute name="placeHolder" required="false" rtexprvalue="true"  description="html5 placeholder" %>
<%@ attribute name="tabIndex"	required="false" rtexprvalue="true"  description="TabIndex of the field" %>
<%@ attribute name="additionalAttributes"	required="false" rtexprvalue="true"  description="Additional Attributes" %>

<%-- IMPORTS --%>
<go:script href="framework/lib/js/mailcheck.min.js" marker="js-href"/>

<%-- VARIABLES --%>
<c:choose>
	<c:when test="${not empty size}">
		<c:set var="size" value="${size}" />
	</c:when>
	<c:otherwise>
		<c:set var="size" value="50" />
	</c:otherwise>
</c:choose>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- Variables for mailCheck --%>
<c:set var="mailCheckDataFieldXPath" value="mailCheckData" />
<c:set var="outputFieldXPath" value="mailCheckOutput" />
<c:set var="attemptsFieldXPath" value="${xpath}Attempts" />
<c:set var="selectionsFieldXPath" value="${xpath}Selections" />
<c:set var="popularEmailDomains"><content:get key="popularEmailDomains" /></c:set>
<c:set var="mailCheckData">{"emailField":"#${name}","attemptsField":"#${name}Attempts","selectionsField":"#${name}Selections","outputField":"#${outputFieldXPath}","emailDomains":${popularEmailDomains}}</c:set>
<c:set var="mailCheckData"><c:out value="${mailCheckData}" /></c:set>

<%-- Only include the classname 'email' when field is required.
	a silent error occurs when field is empty and not required --%>
<c:set var="className">
	<c:choose>
		<c:when test="${not required}">${className}</c:when>
		<c:otherwise>email ${className}</c:otherwise>
	</c:choose>
</c:set>

<c:if test="${not empty placeHolder}">
	<c:set var="placeHolderAttribute" value=' placeholder="${placeHolder}"' />
	<c:set var="className" value="${className} placeholder" />
</c:if>

<c:if test="${not empty tabIndex}">
	<c:set var="tabIndexValue" value=' tabindex=${tabIndex}' />
</c:if>

<%-- VALIDATION --%>
<c:if test="${required}">
	<c:set var="titleText">
		<c:choose>
			<c:when test="${not empty title}">${title}</c:when>
			<c:otherwise>email address</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="requiredAttribute" value=' required="required"' />
</c:if>

<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- HTML --%>
<span>
	<input name="${name}" id="${name}" class="form-control ${className}" value="${value}" size="${size}" ${placeHolderAttribute}${tabIndexValue}${requiredAttribute} type="email" data-msg-required="Please enter ${titleText}" ${additionalAttributes} />
</span>
<div id="${outputFieldXPath}"></div>
<c:if test="${not empty helptext}">
	<i class="helptext">${helptext}</i>
</c:if>

<%-- HIDDEN FIELDS --%>
<field_v1:hidden xpath="${mailCheckDataFieldXPath}" defaultValue="${mailCheckData}" />
<field_v1:hidden xpath="${attemptsFieldXPath}" defaultValue="" />
<field_v1:hidden xpath="${selectionsFieldXPath}" defaultValue="" />