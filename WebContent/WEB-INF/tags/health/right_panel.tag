<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a checkbox input."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="rateReview" required="false" rtexprvalue="true"	 description="Boolean to indicate whether in rate review" %>

<%-- VARIABLES --%>
<c:set var="rateReview">
	<c:choose>
		<c:when test="${not rateReview}">${false}</c:when>
		<c:otherwise>${true}</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<c:choose>
	<c:when test="${rateReview eq true}">
		<div class="right-panel rate-review-above marketing-panel">
			<div class="right-panel-top"><!-- empty --></div>
			<div class="right-panel-middle"><!-- empty --></div>
			<div class="right-panel-bottom"><!-- empty --></div>
		</div>
		<div class="right-panel rate-review marketing-panel">
			<div class="right-panel-top"><!-- empty --></div>
			<div class="right-panel-middle">
				<agg:side_panel_ratereview />
			</div>
			<div class="right-panel-bottom"><!-- empty --></div>
		</div>
		<div class="right-panel rate-review-below marketing-panel">
			<div class="right-panel-top"><!-- empty --></div>
			<div class="right-panel-middle">
				<agg:side_panel_callus />
			</div>
			<div class="right-panel-bottom"><!-- empty --></div>
		</div>
	</c:when>
	<c:otherwise>
		<div class="right-panel marketing-panel">
			<div class="right-panel-top"><!-- empty --></div>
			<div class="right-panel-middle">
				<agg:side_panel_callus />
			</div>
			<div class="right-panel-bottom"><!-- empty --></div>
		</div>
	</c:otherwise>
</c:choose>