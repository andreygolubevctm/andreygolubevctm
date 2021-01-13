<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:core />
<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>

<div class="opening-hours-bubble callCentreNumberSection">
	<h6>Call us on <span class="noWrap callCentreNumber">${callCentreNumber}</span></h6>
	<c:if test="${not empty openingHoursService.getAllOpeningHoursForDisplay(pageContext.getRequest())}">
		<a href="javascript:;" data-toggle="dialog"
			data-content="#view_all_hours"
			data-dialog-hash-id="view_all_hours"
			data-title="Call Centre Hours" data-cache="true">View our Australian based call centre hours
		</a>
	</c:if>
</div>
