<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents kilometers travelled."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"  rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="id" 		required="true"  rtexprvalue="true"  description="Id attribute for panel" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"  description="title of the element" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="id" value="${name}" />

<%-- HTML --%>
<input type="text" name="${name}" id="${id}" class="${className} numeric" value="${data[xpath]}" maxlength="7">

<%-- JAVASCRIPT --%>
<go:script marker="onready">
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the number of kilometres the vehicle is driven per year?"/>
