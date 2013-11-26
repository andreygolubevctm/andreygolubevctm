<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Potcode field."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="the subject of the field" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- HTML --%>
<input type="text" name="${name}" maxlength="4" id="${name}" class="post_code ${className}" value="${value}" size="4">

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter your ${title}"/>
<go:validate selector="${name}" rule="minlength" parm="4" message="Postcode should be 4 characters long"/>
<field:highlight_row name="${name}" inlineValidate="${required}" />

<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	$("#${name}").numeric();
</go:script>