<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="A hidden field which can be validated" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" 								required="true"  rtexprvalue="true"  description="variable's xpath" %>
<%@ attribute name="validationErrorPlacementSelector" 	required="false" rtexprvalue="true"  description="where to place the error message" %>
<%@ attribute name="additionalAttributes"   			required="false" rtexprvalue="true"  description="When you want to send in additional attributes" %>
<%@ attribute name="title" 		 						required="false" rtexprvalue="true"  description="The input field's title"%>
<%@ attribute name="className" 	 						required="false" rtexprvalue="true"  description="additional css class attribute" %>
<%@ attribute name="disableErrorContainer" required="false" rtexprvalue="true"    	 description="Show or hide the error message container" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${not empty title}">
	<c:set var="title" value='title="${title}"' />
</c:if>

<c:if test="${disableErrorContainer eq true}">
	<c:set var="additionalAttributes" value="${additionalAttributes} data-disable-error-container='true'" />
</c:if>

<input type="text" id="${name}" name="${name}" class="validate ${className}" value="${value}" data-validation-placement="${validationErrorPlacementSelector}" style="visibility:hidden;height:0;display:block;" tabindex="-1" readonly ${requiredAttr} ${title} ${additionalAttributes} />