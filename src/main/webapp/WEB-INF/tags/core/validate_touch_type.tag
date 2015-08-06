<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Record non fatal error in database."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="touch" 			required="true"		description="Touch type (single character) e.g. A " %>
<%@ attribute name="valid_touches" 	required="true"		description="comma delimited list of valid touch types e.g. N,R,C " %>

<c:set var="touch" value="${fn:toUpperCase(touch)}" />
<c:set var="validate_touch" value="${touch}," />
<c:set var="valid_touches" value="${fn:toUpperCase(valid_touches)}," />
<c:choose>
	<c:when test="${empty touch or !fn:contains(valid_touches, validate_touch)}">
		${false}
	</c:when>
	<c:otherwise>
		${true}
	</c:otherwise>
</c:choose>

