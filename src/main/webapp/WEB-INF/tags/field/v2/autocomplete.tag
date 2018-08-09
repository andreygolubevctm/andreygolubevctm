<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Makes an automcomplete field"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 		required="false" rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="className" 		required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="extraDataAttributes" required="false" rtexprvalue="true" description="additional data attributes" %>
<%@ attribute name="title" 			required="false" rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="source" 		required="true"	 rtexprvalue="true"	 description="The URL for the Ajax call or a function that will handle the call (and potentially a callback)" %>
<%@ attribute name="placeholder" 	required="false" rtexprvalue="true"	 description="Placeholder of the input box" %>
<%@ attribute name="additionalAttributes" 		required="false"	 rtexprvalue="true"	 description="Additional Attributes" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${not empty placeholder}">
	<c:set var="placeHolderAttribute">placeholder="${placeholder}"</c:set>
</c:if>

<c:if test="${required}">
	<c:set var="requiredAttribute" value=" required" />
</c:if>


<%-- HTML --%>
<input type="text" class="typeahead ${className}" id="${name}" name="${name}" value="${value}" ${additionalAttributes} ${placeHolderAttribute}${requiredAttribute} data-msg-required="Please enter the ${title}" data-source-url="${source}" ${extraDataAttributes} />
