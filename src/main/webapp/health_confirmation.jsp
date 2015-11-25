<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<health:redirect_rules />

<session:new verticalCode="HEALTH" authenticated="true" />

<%-- Call centre numbers --%>
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>

<jsp:useBean id="callCenterHours" class="com.ctm.web.core.web.openinghours.go.CallCenterHours" scope="page" />
<c:set var="openingHoursHeader" scope="request" ><content:getOpeningHours/></c:set>
<c:set var="callCentreAllHoursContent" scope="request"><content:getOpeningHoursModal /></c:set>

<core:quote_check quoteType="health" />

<layout:journey_engine_page title="Health Confirmation">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
		<div class="navbar-collapse header-collapse-contact collapse">
			<ul class="nav navbar-nav navbar-right">
				<c:if test="${not empty callCentreNumber}">
					<li>
						<div class="navbar-text visible-xs">
							<h4>Do you need a hand?</h4>
							<h1><a class="needsclick callCentreNumberClick" href="tel:${callCentreNumber}">Call <span class="callCentreNumber">${callCentreNumberApplication}</span></a></h1>
							<p class="small">Our Australian based call centre hours are</p>
							${openingHoursHeader }
						</div>
						<div class="navbar-text hidden-xs" data-livechat="target" data-livechat-fire='{"step":7,"confirmation":true,"navigationId":"confirmation"}'>
							<h4>Call us on</h4>
							<h1><span class="noWrap callCentreNumber">${callCentreNumber}</span></h1>
							${openingHoursHeader }
						</div>
						<div id="view_all_hours" class="hidden">${callCentreAllHoursContent}</div>
						<div class="navbar-text hidden-xs" data-poweredby="header">&nbsp;</div>
					</li>
				</c:if>
			</ul>

		</div>
	</jsp:attribute>

	<jsp:attribute name="navbar">
		<ul class="nav navbar-nav">
		<li><a href="javascript:window.print();" class="btn-email"><span class="icon icon-blog"></span> <span>Print Page</span></a></li>
		<c:if test="${empty callCentre}">
			<li>
				<a href="${pageSettings.getBaseUrl()}health_quote.jsp" class="btn-dropdown needsclick"><span class="icon icon-undo"></span> <span>Start a new quote</span> <span class="icon icon-arrow-right hidden-xs"></span></a>
			</li>
		</c:if>
		</ul>
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<health:footer />
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<health:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

	<jsp:attribute name="before_close_body">
		<%-- get specific beforeCloseBody content for health confirmmation. e.g tracking code for white-label brand --%>
		<content:get key="beforeCloseBody" suppKey="confirmation" />
	</jsp:attribute>

	<jsp:body>
		<health_layout:slide_confirmation />
	</jsp:body>

</layout:journey_engine_page>