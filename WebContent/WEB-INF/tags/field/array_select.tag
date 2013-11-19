<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built comma separated values."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the select box" %>
<%@ attribute name="items" 		required="true"  rtexprvalue="true"  description="comma seperated list of values in value=description format" %>
<%@ attribute name="delims"		required="false"  rtexprvalue="true"  description="Appoints a new delimiter set, i.e. ||" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />

<c:if test="${empty delims}">
	<c:set var="delims" value="," />
</c:if>

<%-- HTML --%>
<select class="${className} array_select" id="${name}" name="${name}" >
	<c:forTokens items="${items}" delims="${delims}" var="option">
		<c:set var="val" value="${fn:substringBefore(option,'=')}" />
		<c:set var="des" value="${fn:substringAfter(option,'=')}" />
		<c:set var="id" value="${name}_${val}" />
		<c:choose>
			<c:when test="${val == value}">
				<option id="${id}" value="${val}" selected="selected">${des}</option>
			</c:when>
			<c:otherwise>
				<option id="${id}" value="${val}">${des}</option>
			</c:otherwise>
		</c:choose>
	</c:forTokens>
</select>

<%-- VALIDATION --%>
<c:if test="${required}">
	<go:validate selector="${name}" rule="required" parm="${required}" message="Please choose ${title}"/>
</c:if>

