<%@ tag language="java" pageEncoding="UTF-8" %>
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
<c:set var="centreHoursText">Mon &#45; Thu 8:30am to 8pm &amp; Fri 8:30am-6pm (AEST)</c:set>

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
			<div class="right-panel-top">
				<span>${centreHoursText}</span>
			</div>
			<health:holiday_call_centre_hours />
			<div class="right-panel-middle sidePanel">
				<agg:side_panel_callus />
			</div>
			<div class="right-panel-bottom"><!-- empty --></div>
		</div>
	</c:when>
	<c:otherwise>
		<div class="right-panel marketing-panel">
			<div class="right-panel-top">
				<span>${centreHoursText}</span>
			</div>
			<health:holiday_call_centre_hours />
			<div class="right-panel-middle">
				<agg:side_panel_callus />
			</div>
			<div class="right-panel-bottom"><!-- empty --></div>
		</div>

		<%-- HLT-608: This content is temporarily required for the October Health'N'Wealth promotion --%>
		<jsp:useBean id="now" class="java.util.Date"/>
		<fmt:parseDate var="compStart" pattern="yyyy-MM-dd HH:mm" value="2013-11-07 09:00" type="both" />
		<fmt:parseDate var="compFinish" pattern="yyyy-MM-dd HH:mm" value="2014-02-28 09:00" type="both" />
		<c:set var="healthynwealthyActive" value="${false}" />
		<c:if test="${now >= compStart and now < compFinish}">
			<c:set var="healthynwealthyActive" value="${true}" />
		</c:if>

		<c:if test="${healthynwealthyActive == true}">
			<div id="healthynwealthy" class="right-panel promotion">
				<div class="right-panel-top"><!-- empty --></div>
				<div class="right-panel-middle"><!-- empty --></div>
				<div class="right-panel-bottom"><!-- empty --></div>
			</div>
		</c:if>
		<%-- END HLT-608 --%>
	</c:otherwise>
</c:choose>

<go:script marker="onready">
	<c:if test="${healthynwealthyActive == true}">
<%--
	slide_callbacks.register({
		mode:			'before',
		slide_id:		-1,
		callback:		function(){
			if( $("#healthynwealthy").is(":visible") ) {
				$("#healthynwealthy").slideUp('fast', function() {
					$("#healthynwealthy").removeClass('confirmation').removeClass('promotion').hide();
				});
			}
		}
	});
	slide_callbacks.register({
		mode:			'after',
		slide_id:		4,
		callback:		function(){
			$("#healthynwealthy").addClass('promotion').slideDown('slow');
		}
	});
--%>
	</c:if>
</go:script>