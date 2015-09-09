<%@ tag import="org.slf4j.LoggerFactory" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Displays the root postcode for a given state."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('/utilities/utilities_get_postcode.tag')}" />

<%@ attribute name="state" required="true" description="The state abbreviation to search."%>

<c:set var="postcode">
	<c:choose>
		<c:when test="${state eq 'QLD'}">4000</c:when>
		<c:when test="${state eq 'NSW'}">2000</c:when>
		<c:when test="${state eq 'ACT'}">2600</c:when>
		<c:when test="${state eq 'VIC'}">3000</c:when>
		<c:when test="${state eq 'TAS'}">7000</c:when>
		<c:when test="${state eq 'SA'}">5000</c:when>
		<c:when test="${state eq 'WA'}">6000</c:when>
		<c:otherwise>0800</c:otherwise>
	</c:choose>
</c:set>

${logger.debug('Returning postcode {}', log:kv('postcode', postcode) )}

${postcode}