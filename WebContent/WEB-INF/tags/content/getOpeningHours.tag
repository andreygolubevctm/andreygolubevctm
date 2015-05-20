<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:core />
<jsp:useBean id="openingHoursService"
			 class="com.ctm.services.simples.OpeningHoursService" scope="page" />

<c:set var="todayOpeningHours" scope="request" value="${openingHoursService.getOpeningHoursForDisplay(pageContext.getRequest(),\"today\")}" ></c:set>
<c:set var="tomorrowOpeningHours" scope="request" value="${openingHoursService.getOpeningHoursForDisplay(pageContext.getRequest(),\"tomorrow\")}"  ></c:set>
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>


<div class="opening-hours">
	Today: ${todayOpeningHours },
	<span class="tomorrow-hours">Tomorrow: ${tomorrowOpeningHours} (AEST)</span>
	<a	href="javascript:;" data-toggle="dialog"
		  data-content="#view_all_hours"
		  data-dialog-hash-id="view_all_hours"
		  data-title="My Info Dialog" data-cache="true">View All
	</a>
</div>
