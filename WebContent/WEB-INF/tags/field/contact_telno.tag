<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a telephone number"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"	 description="subject of the input box" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false" rtexprvalue="true"	 description="id of the surround div" %>
<%@ attribute name="maxlength"	required="false" rtexprvalue="true"	 description="maxlength of the input" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="id" value="${name}" />
<c:if test="${not empty maxlength}"><c:set var="maxlength">maxlength="${maxlength}"</c:set></c:if>

<%-- HTML --%>
<input type="text" name="${name}" id="${id}" class="contact_telno ${className}" value="${data[xpath]}" title="${title}" ${maxlength}>

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter ${title}" />

<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	jQuery("#${name}").mask("9999999999",{placeholder:""});
</go:script>
