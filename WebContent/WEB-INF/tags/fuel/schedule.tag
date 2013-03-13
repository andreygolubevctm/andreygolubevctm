<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Makes a human readable time from a time format hh:mm:ss."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ tag  import="java.util.Calendar" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="type" 	required="true"	 	rtexprvalue="true" description="Regional, Metro or other schedule" %>
<fmt:setLocale value="en_GB" scope="session" />
<fmt:setTimeZone value="Australia/Brisbane" scope="session" />
<jsp:useBean id="now" class="java.util.Date" />

<%-- default weekly schedule mon|tue|wed|thu|fri|sat|sun  (0 = no check on the day) --%>
<c:set var="metro">0900|1300|1700</c:set>
<c:set var="regional">0915</c:set>


<%-- Get the time (24hr) and day of week (offset by one for the array) --%>
<c:set var="day"><fmt:formatDate value="${now}" type="date" pattern="E" /></c:set>
<c:choose>
	<c:when test="${fn:startsWith(day, 'Mo')}">
		<c:set var="day" value="${0}" />
	</c:when>
	<c:when test="${fn:startsWith(day, 'Tu')}">
		<c:set var="day" value="${1}" />
	</c:when>
	<c:when test="${fn:startsWith(day, 'We')}">
		<c:set var="day" value="${2}" />
	</c:when>
	<c:when test="${fn:startsWith(day, 'Th')}">
		<c:set var="day" value="${3}" />
	</c:when>
	<c:when test="${fn:startsWith(day, 'Fr')}">
		<c:set var="day" value="${4}" />
	</c:when>
	<c:when test="${fn:startsWith(day, 'Sa')}">
		<c:set var="day" value="${5}" />
	</c:when>					
	<c:otherwise>
		<c:set var="day" value="${6}" />
	</c:otherwise>
</c:choose>
<c:set var="timeNow"><fmt:formatDate value="${now}" type="time" pattern="HHmm" /></c:set>
	<c:set var="timeNow" value="${timeNow+0}" />
<c:set var="offset" value="${0}" />

<c:choose>
	<c:when test="${type == 'metro'}">
		<c:set var="list">${metro},${metro},${metro},${metro},${metro},${metro},0900|1700</c:set>
	</c:when>
	<c:when test="${type == 'regional'}">
		<c:set var="list">${regional},${regional},${regional},${regional},${regional},${regional},${regional}</c:set>
	</c:when>
	<c:when test="${type == 'postcode'}">
		<c:set var="list">0,0,0,0,0,0,2200</c:set>
	</c:when>
</c:choose>


<%-- Begin at the day of the week and try to match a time --%>
<%-- NEED A BREAK, so making timeDiff, will kill the results --%>


<%-- Need the code to run at least twice, so a full 7 days is seen, i.e. if day starts on 6 (sun) --%>
<c:forEach var="i" begin="1" end="2" step="1" varStatus ="status">

	<c:forEach begin="${day}" items="${list}" var="L">
		<c:if test="${empty timeDiff}">
		
			<c:forTokens items="${L}" delims="|" var="T">
			<c:set var="T" value="${T+0}" />
			<c:if test="${empty timeDiff}">
				<c:if test="${timeNow < (T + offset)}">
					<%-- Make sure there is at least a schedule for the selected day --%>
					<c:if test="${T > 0}">	
						<%-- The total difference in time to test against = the schedule time + days(24h) away --%>				
						<c:set var="timeDiff" value="${T + offset}" />												
					</c:if>
				</c:if>
			</c:if>
			</c:forTokens>
			
			<%-- INCREASE BY A DAY(24H) --%>
			<c:set var="offset" value="${offset + 2400}" />	
			
			<%-- Not infinite loop, break if the offset is greater than 7 days --%>
			<c:if test="${offset >=  16800}">
				<c:set var="timeDiff" value="${offset}" />
			</c:if>
		
		</c:if>	
		</c:forEach>

<c:set var="day" value="${0}" /><%-- Reset to the first day! after the first loop --%>
</c:forEach> 

<%-- Boil the hour values down to minutes to get an accurate picture, i.e hours divided by 100 (integer * 60_ + remainder --%>

<c:set var="nowText"><fmt:formatNumber currencySymbol="" type="currency" groupingUsed="false" value="${timeNow /100}" /></c:set>
	<c:set var="TnowMinutes" value="${(fn:substringBefore(nowText, '.') * 60) + fn:substringAfter(nowText, '.')}"> </c:set>

<c:set var="diffText"><fmt:formatNumber currencySymbol="" type="currency" groupingUsed="false" value="${timeDiff /100}" /></c:set>
	<c:set var="TdiffMinutes" value="${(fn:substringBefore(diffText, '.') * 60) + fn:substringAfter(diffText, '.')}"> </c:set>
	
<%-- Time difference in seconds  --%>
<c:set var="timeStamp" value="${(TdiffMinutes - TnowMinutes) *60}" />

<%-- Final output timestamp seconds --%>
<c:out value="${timeStamp}" />