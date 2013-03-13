<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a person's email address."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"	 description="subject of the input box" %>
<%@ attribute name="size" 		required="false" rtexprvalue="true"	 description="size of the input box" %>

<c:choose>
	<c:when test="${not empty size}">
		<c:set var="size" value="${size}" />
	</c:when>
	<c:otherwise>
		<c:set var="size" value="50" />
	</c:otherwise>
</c:choose>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- Only include the classname 'email' when field is required.
	 a silent error occurs when field is empty and not required --%>
<c:set var="fieldClasses">
	<c:choose>
		<c:when test="${not required}">${className}</c:when>
		<c:otherwise>email ${className}</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<input type="text" name="${name}" id="${name}" class="${fieldClasses}" value="${data[xpath]}" size="${size}">

<%-- VALIDATION --%>
<c:if test="${required}">

	<c:set var="titleText">
		<c:choose>
			<c:when test="${not empty title}">${title}</c:when>
			<c:otherwise>email address</c:otherwise>
		</c:choose>
	</c:set>

	<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter ${titleText}"/>
	<go:validate selector="${name}" rule="email"    parm="${required}" message="Please enter a valid email address"/>
</c:if>

<go:script marker="onready">
	$('#${name}').on('blur', function() { $(this).val($.trim($(this).val())); });
</go:script>