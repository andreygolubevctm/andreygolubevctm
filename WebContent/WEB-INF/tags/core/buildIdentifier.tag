<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<c:import var="manifestContent" url="/META-INF/MANIFEST.MF" />
<c:set var="buildIdentifier" value="" />
<%-- It appears a delimiter of a new line needs to be broken to a new line with no tab/spacing in between. --%>
<c:forTokens items="${manifestContent}" var="manifestEntry" delims="
">
	<c:if
		test="${ empty buildIdentifier and not empty manifestEntry and fn:startsWith(manifestEntry, 'Identifier: ') }">
		<c:set var="buildIdentifier"
			value="${fn:trim(fn:substringAfter(manifestEntry, 'Identifier: '))}" />
	</c:if>
</c:forTokens>
<c:if test="${ empty buildIdentifier }">
	<c:choose>
		<c:when test="${ pageContext.request.localName == 'localhost' }">
			<c:set var="buildIdentifier" value="localhost" />
		</c:when>
		<c:otherwise>
			<c:set var="buildIdentifier" value="dev" />
		</c:otherwise>
	</c:choose>
</c:if>
${buildIdentifier}