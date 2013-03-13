<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Creates a set of radio buttons for the passed xpath using a comma separated list of name=value pairs."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false" rtexprvalue="true"	 description="id of the surround div" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the radio buttons" %>
<%@ attribute name="items" 		required="true"  rtexprvalue="true"  description="comma seperated list of values in value=description format" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />
<div class="${className} radio_buttons" id="${id}">
	<c:forTokens items="${items}" delims="," var="radio" varStatus="status">
		<c:set var="val" value="${fn:substringBefore(radio,'=')}" />
		<c:set var="des" value="${fn:substringAfter(radio,'=')}" />
		<c:set var="id" value="${name}_${val}" />

		<%-- Setup first and last-child class --%>
		<c:choose>
			<c:when test="${status.first}">
				<c:set var="classVar" value="first-child ${className}" />
			</c:when>
			<c:when test="${status.last}">
				<c:set var="classVar" value="last-child  ${className}" />
			</c:when>
			<c:otherwise>
				<c:set var="classVar" value="${className}" />
			</c:otherwise>
		</c:choose>

		<c:choose>
			<c:when test="${val == value}">
				<input type="radio" name="${name}" id="${id}" value="${val}" checked="checked" class="${classVar}">
			</c:when>
			<c:otherwise>
				<input type="radio" name="${name}" id="${id}" value="${val}" class="${classVar}">
			</c:otherwise>
		</c:choose>
		<label for="${id}">${des}</label>
	</c:forTokens>
</div>
<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please choose ${title}"/>
