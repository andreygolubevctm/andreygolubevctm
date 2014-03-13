<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Potcode field." %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="the subject of the field" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${required}">
	<c:set var="requiredAttribute" value=' required="required" data-msg-required="Please enter ${title}"' />
</c:if>


<%-- HTML --%>
<input type="text"${requiredAttribute} name="${name}" pattern="[0-9]*" maxlength="4" id="${name}" class="form-control ${className}" value="${value}" size="4">


<%-- VALIDATION --%>
<go:validate selector="${name}" rule="minlength" parm="4" message="Postcode should be 4 characters long"/>
<go:validate selector="${name}" rule="regex" parm="'[0-9]{4}'" message="Postcode must contain numbers only." />
<%--
<field:highlight_row name="${name}" inlineValidate="${required}" />
--%>

<%-- JAVASCRIPT --%>
<%--
<go:script marker="jquery-ui">
	$("#${name}").numeric();
</go:script>
--%>