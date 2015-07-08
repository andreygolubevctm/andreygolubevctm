<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="A hidden field which can be validated" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true"  rtexprvalue="true"  description="variable's xpath" %>
<%@ attribute name="validationErrorPlacementSelector" required="false"  rtexprvalue="true"  description="where to place the error message" %>
<%@ attribute name="title" 		 required="false" rtexprvalue="true"  description="The input field's title"%>
<%@ attribute name="className" 	 required="false" rtexprvalue="true"  description="additional css class attribute" %>
<%@ attribute name="required" 	required="false" rtexprvalue="true"	 description="is this field required?" %>
<%@ attribute name="attributeInjection"	 required="false" rtexprvalue="true"  description="additional attribute series to allow the inclusion of more js module bound options" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${not empty title}">
	<c:set var="title" value='title="${title}"' />
</c:if>
<c:if test="${empty required}">
	<c:set var="requiredAttr" value=" required " />
</c:if>
<c:if test="${required}">
	<c:set var="requiredAttr" value=" required " />
</c:if>

<input type="text" id="${name}" name="${name}" class="validate ${className}" value="${value}" data-validation-placement="${validationErrorPlacementSelector}" style="visibility:hidden;height:0;display:block;" tabindex="-1" readonly ${requiredAttr} ${title} ${attributeInjection} />