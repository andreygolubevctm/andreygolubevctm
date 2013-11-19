<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" required="false" rtexprvalue="true" description="" %>
<%@ attribute name="colour" required="false" rtexprvalue="true" description="blue or green" %>
<%@ attribute name="arrowPosition" required="false" rtexprvalue="true" description="left or right" %>
<%@ attribute name="width" required="false" rtexprvalue="true" description="in px" %>

<c:if test="${empty className}">
	<c:set var="className" value="" />
</c:if>

<c:if test="${empty colour}">
	<c:set var="colour" value="green" />
</c:if>

<c:if test="${empty arrowPosition}">
	<c:set var="arrowPosition" value="left" />
</c:if>

<c:if test="${empty arrowPosition}">
	<c:set var="width" value="" />
</c:if>

<c:if test="${not empty width}">
	<c:set var="widthString" value="style='width:${width}px;' " />
</c:if>


<div class="${className}  speechbubble ${arrowPosition}_arrow ${colour}" ${widthString}>
	<div class="insert">
		<jsp:doBody />
	</div>
</div>