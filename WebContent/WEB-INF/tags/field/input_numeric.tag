<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents numeric field."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"	 	rtexprvalue="true"	description="variable's xpath" %>
<%@ attribute name="required" 			required="true"  	rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="id" 				required="true"  	rtexprvalue="true"  description="Id attribute for panel" %>
<%@ attribute name="maxLength" 			required="true" 	rtexprvalue="true"  description="maximum number of digits" %>
<%@ attribute name="className" 			required="false" 	rtexprvalue="true"	description="additional css class attribute" %>
<%@ attribute name="validationMessage" 	required="false" 	rtexprvalue="true"  description="validation message" %>
<%@ attribute name="title" 				required="false" 	rtexprvalue="true"  description="Set a title for the validation message" %>
<%@ attribute name="maxValue" 			required="false" 	rtexprvalue="true"  description="Set a maximum number for input value" %>
<%@ attribute name="minValue" 			required="false" 	rtexprvalue="true"  description="Set a minimum number for input value" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="id" value="${name}" />

<%-- HTML --%>
<input type="text" name="${name}" id="${id}" class="${className} numeric" value="${data[xpath]}" maxlength="${maxLength}">

<%-- VALIDATION --%>
<c:if test="${required == true}">
	<go:validate selector="${name}" rule="required" parm="${required}" message="${validationMessage}"/>
</c:if>

<c:if test="${not empty maxValue}">
	<go:validate selector="${name}" rule="nrmaxValue" parm="${maxValue}" message="The ${title} value cannot be higher than ${maxValue}"/>
</c:if>

<c:if test="${not empty minValue}">
	<go:validate selector="${name}" rule="nrminValue" parm="${minValue}" message="The ${title} value cannot be lower than ${minValue}"/>
</c:if>