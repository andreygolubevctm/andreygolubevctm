<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Makes a human readable time from a time format hh:mm:ss."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="time" 			required="true"	 	rtexprvalue="true" description="The time format hh:mm:ss" %>
<%@ attribute name="timestamp" 		required="false"	rtexprvalue="true" description="Whether the format is a timestamp in seconds" %>
<%@ attribute name="depth" 			required="false"	rtexprvalue="true" description="The level of time to report" %>
<%@ attribute name="rounding" 		required="false"	rtexprvalue="true" description="The minimum amount of minutes to return" %>


<c:set var="humanTime" value="" />
<c:set var="count" value="${0}" />
<c:set var="joiner" value="${0}" />
 
<c:if test="${empty depth}">
	<c:set var="depth" value="2" />
</c:if>
<c:if test="${empty rounding}">
	<c:set var="rounding" value="0" />
</c:if>
	<c:set var="rounding" value="${rounding+0}" />

<%-- Convert the timestamp into the HH:MM:SS format --%>
<c:if test="${not empty timestamp}">
	<c:set var="hours" value="${fn:substringBefore(time /3600, '.')}" />
	<c:set var="minutes" value="${fn:substringBefore( ( (time /60) - (hours * 60) ), '.')}" />
	<c:set var="seconds" value="${(time - (minutes * 60) - (hours * 3600) )}" />
	<c:set var="time" value="${hours}:${minutes}:${seconds}" />
</c:if>


<c:forTokens var="timeToken" delims=":" items="${time}">
	<c:set var="t"><fmt:formatNumber value="${timeToken}" type="number" groupingUsed="false" /></c:set>
	<c:set var="t" value="${t+0}" />
	<c:if test="${(not empty t)}">
		<c:if test="${(t != 0)}">
			<c:choose>
				<c:when test="${t > 1}">
					<c:set var="plural" value="s" />
				</c:when>
				<c:otherwise>
					<c:set var="plural" value="" />
				</c:otherwise>
			</c:choose>
			
			<c:choose>
				<c:when test="${count == 0}">
					<c:set var="humanTime">${t} hour${plural}</c:set>
					<c:if test="${t > 24}">
						<c:set var="t" value="${t / 24 }" />
						<c:set var="d" value="${fn:substringBefore(t, '.')}" />
						<c:set var="h" value=".${fn:substringAfter(t, '.')}" />
							
							<c:set var="h"><fmt:formatNumber value="${h *24}" type="number" maxIntegerDigits="2" /></c:set>
						 	 
						<c:set var="humanTime" value="${d} days and ${h} hours" />
							<c:set var="count" value="${count+999}" />
					</c:if>
				</c:when>
				<c:when test="${count == 1 && depth >= 2}">
					<c:set var="humanTime">
						${humanTime}
						<c:choose>
							<c:when test="${fn:contains(humanTime, 'hour')}"> and </c:when>
							<c:when test="${rounding > t}">
								<c:set var="t" value="${rounding}" />
								<c:set var="s" value="s" />						
							</c:when>
						</c:choose>			
					 	${t} minute${plural}
					</c:set>
				</c:when>
				<c:when test="${count == 2 && depth >= 3}">					
					<c:set var="humanTime">
					${humanTime}
					<c:if test="${fn:contains(humanTime, 'minute')}"> and ${t} second${plural}</c:if>
					</c:set>
				</c:when>						
			</c:choose>
		</c:if>
	</c:if>

	<c:set var="count" value="${count+1}" />

</c:forTokens>


<c:out value="${humanTime}" />