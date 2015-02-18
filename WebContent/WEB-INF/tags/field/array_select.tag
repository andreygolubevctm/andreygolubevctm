<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built comma separated values."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 		required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 		required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 			required="true"  rtexprvalue="true"	 description="title of the select box" %>
<%@ attribute name="items" 			required="true"  rtexprvalue="true"  description="comma seperated list of values in value=description format" %>
<%@ attribute name="delims"			required="false"  rtexprvalue="true"  description="Appoints a new delimiter set, i.e. ||" %>
<%@ attribute name="helpId" 		required="false" rtexprvalue="true"	 description="The select help id (if non provided, help is not shown)" %>
<%@ attribute name="includeInForm"	required="false" rtexprvalue="true"  description="Force attribute to include value in data bucket - use true/false" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${empty delims}">
	<c:set var="delims" value="," />
</c:if>

<c:if test="${includeInForm eq true}">
	<c:set var="includeAttribute" value=' data-attach="true" ' />
</c:if>

<c:if test="${required}">
	<c:set var="titleText">
		<c:choose>
			<c:when test="${not empty title}">${title}</c:when>
			<c:otherwise>a value</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="requiredAttribute" value=' required="required" ' />
</c:if>


<%-- HTML --%>
<select class="form-control array_select ${className}" id="${name}" name="${name}" ${requiredAttribute} data-msg-required="Please choose ${title}" ${includeAttribute}>
	<c:forTokens items="${items}" delims="${delims}" var="option">
		<c:set var="val" value="${fn:substringBefore(option,'=')}" />
		<c:set var="des" value="${fn:substringAfter(option,'=')}" />
		<c:set var="id" value="${name}_${val}" />
		<c:choose>
			<c:when test="${not empty value and value eq val}">
				<option id="${id}" value="${val}" selected="selected">${des}</option>
			</c:when>
			<c:otherwise>
				<option id="${id}" value="${val}">${des}</option>
			</c:otherwise>
		</c:choose>
	</c:forTokens>
</select>
<c:if test="${helpId != null && helpId != ''}">
	<div class="help_icon" id="help_${helpId}"></div>
</c:if>