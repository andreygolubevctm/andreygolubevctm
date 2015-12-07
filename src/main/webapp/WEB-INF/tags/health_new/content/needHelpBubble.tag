<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />


<c:if test="${not empty callCentreNumber}">
	<span class="callCentreNumberSection">
		<h4>Do you need a hand?</h4>
		<p class="larger">
			Call <span class="noWrap callCentreNumber">${callCentreNumber}</span>
		</p>
		<c:if test="${not empty openingHoursService.getAllOpeningHoursForDisplay(pageContext.getRequest(),false)}">
			<div class="opening-hours">
				<a href="javascript:;" data-toggle="dialog"
					data-content="#view_all_hours"
					data-dialog-hash-id="view_all_hours"
					data-title="Call Centre Hours" data-cache="true">View our Australian based call centre hours
				</a>
			</div>
		</c:if>
	</span>
</c:if>