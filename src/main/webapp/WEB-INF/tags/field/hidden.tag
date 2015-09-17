<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="A hidden field"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 			required="false" rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="validationRule" 	required="false" rtexprvalue="true"  description="Custom validation method if available" %>
<%@ attribute name="validationParam" 	required="false" rtexprvalue="true"  description="Custom validation param if available" %>
<%@ attribute name="validationMessage" 	required="false" rtexprvalue="true"  description="Custom validation message if available" %>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="defaultValue" 		required="false" rtexprvalue="true"	 description="default value" %>
<%@ attribute name="constantValue" 		required="false" rtexprvalue="true"	 description="constant value" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="fieldValue" value="${defaultValue}" />

<c:if test="${not empty required and required eq true}">
	<c:if test="${empty validationRule}">
		<c:set var="validationRule" value="required" />
	</c:if>
	<c:if test="${empty validationMessage}">
		<c:set var="validationMessage" value="A hidden field is required." />
	</c:if>
</c:if>

<c:choose>
	<c:when test="${not empty constantValue}">
		<c:set var="fieldValue" value="${constantValue}" />
	</c:when>
	<c:when test="${data[xpath] != '' && not empty data[xpath]}">
		<c:set var="fieldValue"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
	</c:when>
</c:choose>

<%-- Add special class 'required' is field is required --%>
<c:set var="fieldClasses">
	<c:choose>
		<c:when test="${not required}">${className}</c:when>
		<c:otherwise>validate ${className}</c:otherwise>
	</c:choose>
</c:set>


<c:set var="validationAttributes" value="" />
<c:if test="${required}">
	<c:if test="${empty validationParam}">
		<c:set var="validationParam" value="true" />
	</c:if>
	<c:set var="validationAttributes" value=' data-rule-${validationRule}="${validationParam}" data-msg-${validationRule}="${validationMessage}"' />
</c:if>

<%-- HTML --%>
<input type="hidden" name="${name}" id="${name}" class="${fieldClasses}" value="${fieldValue}" ${validationAttributes} />