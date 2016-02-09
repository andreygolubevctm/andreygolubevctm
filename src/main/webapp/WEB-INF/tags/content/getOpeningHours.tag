<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="displayTodayOnly" required="false" rtexprvalue="true" description="Display today only opening hours" %>

<session:core />
<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />

<c:set var="todayOpeningHours" scope="request" value="${openingHoursService.getOpeningHoursForDisplay(pageContext.getRequest(),'today')}" />
<c:set var="tomorrowOpeningHours" scope="request" value="${openingHoursService.getOpeningHoursForDisplay(pageContext.getRequest(),'tomorrow')}" />
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>

<div class="opening-hours">
	<span>
		<c:choose>
			<c:when test="${empty displayTodayOnly or displayTodayOnly eq false}">
				<c:if test="${not empty todayOpeningHours}">
					<span class="today-hours">Today: ${todayOpeningHours} </span>
				</c:if>
				<c:if test="${not empty tomorrowOpeningHours}">
					<c:if test="${not empty todayOpeningHours}">, </c:if>
					<span class="tomorrow-hours">Tomorrow: ${tomorrowOpeningHours} (AEST)</span>
				</c:if>
				<c:if test="${not empty todayOpeningHours || not empty tomorrowOpeningHours}">
					<a href="javascript:;" data-toggle="dialog"
					   data-content="#view_all_hours"
					   data-dialog-hash-id="view_all_hours"
					   data-title="Call Centre Hours" data-cache="true">View All
					</a>
				</c:if>
			</c:when>
			<c:otherwise>
				<c:if test="${not empty todayOpeningHours}">
					<span class="today-hours"> ${todayOpeningHours} </span>
				</c:if>
				<c:if test="${not empty todayOpeningHours}">
					<a href="javascript:;" data-toggle="dialog"
					   data-content="#view_all_hours"
					   data-dialog-hash-id="view_all_hours"
					   data-title="Call Centre Hours" data-cache="true">View All
					</a>
				</c:if>
			</c:otherwise>
		</c:choose>
	</span>
</div>