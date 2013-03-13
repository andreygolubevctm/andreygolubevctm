<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="The button tag, with default values inserted or configurable."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 	rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="title" 		required="true"	 	rtexprvalue="true"	 description="The input field's title"%>
<%@ attribute name="className" 	required="false" 	rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="disabled" 	required="false" 	rtexprvalue="true"	 description="If the button is active or disabled"%>
<%@ attribute name="type" 		required="false"	 rtexprvalue="true"	 description="The button's type: button, submit, reset"%>
<%@ attribute name="value" 		required="false"	 rtexprvalue="true"	 description="The starting value of the tag"%>
<%@ attribute name="form" 		required="false"	 rtexprvalue="true"	 description="The form ID the button belongs to (HTML5)"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />


<%-- Disabled on or off --%>
<c:choose>
	<c:when test='${ (disabled == "disabled") || (disabled == "true") }'>
		<c:set var="disabled" value=' disabled="disabled"' />
	</c:when>
	<c:otherwise>
		<c:set var="disabled" value='' />
	</c:otherwise>
</c:choose>

<%-- Form on or off --%>
<c:choose>
	<c:when test='${form}'>
		<c:set var="form" value=' form="${form}"' />
	</c:when>
</c:choose>



<%-- Test the button type --%>
<c:if test='${type == ""}'>
	<c:set var="type" value="button" />
</c:if>





<%-- HTML --%>
<button type="${type}" name="${name}" id="${name}" class="${className}" value="${value}"${disabled}${form}>${title}</button>
