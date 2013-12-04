<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's name."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="size" 		required="false" rtexprvalue="true"	 description="the size attribute of this input"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${required}">
	<c:set var="requiredAttribute"> required="required" </c:set>
</c:if>

<c:set var="sizeAttribute">  size="18" </c:set>
<c:if test="${not empty size}">
	<c:set var="sizeAttribute"> size="${size}" </c:set>
</c:if>

<%-- HTML --%>
<input type="text" name="${name}" id="${name}" class="person_name ${className}"
					value="${value}" ${sizeAttribute} ${requiredAttribute}
					data-msg-required="Please enter ${title}" >

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="personName" parm="true" message="Please enter a valid name"/>

