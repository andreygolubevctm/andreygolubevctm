<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Form help icons" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="helpId"	required="false" rtexprvalue="true"	 description="Help tooltip ID" %>
<%@ attribute name="position" required="false" rtexprvalue="true"	 description="Help tooltip poisition" %>
<%@ attribute name="tooltipClassName" required="false" rtexprvalue="true"	 description="Help tooltip classes" %>
<%@ attribute name="showText" required="false" rtexprvalue="true"	 description="Toggle to display text instead of icon" %>
<%@ attribute name="additionalAttributes"  	required="false" rtexprvalue="true"  description="Additional attributes" %>

<c:set var="showText">
	<c:choose>
		<c:when test="${not empty showText and showText eq true}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>

<c:if test="${empty position}">
	<c:set var="position" value="right" />
</c:if>
<c:set var="dataPositionString" value="" />
<c:choose>
	<c:when test="${position eq 'left'}">
		<c:set var="dataPositionString" value=' data-my="right center" data-at="left center"' />
	</c:when>
	<c:when test="${position eq 'bottom'}">
		<c:set var="dataPositionString" value=' data-my="top center" data-at="bottom center"' />
	</c:when>
	<c:when test="${position eq 'top'}">
		<c:set var="dataPositionString" value=' data-my="bottom center" data-at="top center"' />
	</c:when>
</c:choose>

<c:if test="${not empty tooltipClassName}">
	<c:set var="tooltipClassName" value=' data-class="${tooltipClassName}"' />
</c:if>

<c:if test="${helpId != null && helpId != '' && helpId != '0'}">
	<a href="javascript:void(0);" class="help-icon <c:choose><c:when test="${showText eq true}">icon-text</c:when><c:otherwise>icon-info</c:otherwise></c:choose>" data-content="helpid:${helpId}" data-toggle="popover"<c:out value="${dataPositionString}" escapeXml="false" /><c:out value="${tooltipClassName}" escapeXml="false" /> ${additionalAttributes}><span class="<c:if test="${showText eq false}">text-hide</c:if>">Need Help?</span></a>
</c:if>
