<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_new:load_page_settings vertical="health" />
<core:load_settings conflictMode="false" vertical="${pageSettings.vertical}" />
<core:quote_check quoteType="health" />

<layout:journey_engine_page title="Health Confirmation" sessionPop="false">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="header_collapse_contact">
		<ul class="nav navbar-nav navbar-right">
			<li>
				<div class="navbar-text visible-xs">
					<h4>Need some help?</h4>
					<h1><a class="needsclick" href="tel:+1800777712">Call 1800 77 77 12</a></h1>
					<p class="small">Our Australian based call centre hours are</p>
					<p>Mon - Fri: 8:30am to 8pm &nbsp;<br />
					Sat: 10am to 4pm (AEST)</p>
				</div>
				<div class="navbar-text hidden-xs" data-livechat="target">
					<h4>Call us on</h4>
					<h1>1800 77 77 12</h1>
				</div>
			</li>
		</ul>
	</jsp:attribute>

	<jsp:attribute name="navbar">

	</jsp:attribute>

	<jsp:attribute name="navbar_collapse_menu">
		<li><a href="javascript:window.print();" class="btn-tertiary"><span class="icon icon-blog"></span> <span>Print Page</span></a></li>
		<c:if test="${empty callCentre}">
			<li>
				<a href="${data['settings/root-url']}${data['settings/styleCode']}/health_quote.jsp" class="btn-primary needsclick"><span class="icon icon-undo"></span> <span>Start a new quote</span> <span class="icon icon-arrow-right hidden-xs"></span></a>
			</li>
		</c:if>
	</jsp:attribute>

	<jsp:attribute name="journey_progress_bar">
		<%-- @TODO = needs to be replaced by future progressBar js module --%>
		<div class="collapse navbar-collapse">
			<ul class="journeyProgressBar"></ul>
		</div>
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<health:footer />
	</jsp:attribute>

	<jsp:attribute name="body_end">
		<health_new:settings />

		<%-- Force this to be confirmation because it is set by a param value and might change. This is a safety decision because if it is something else, bad things happen. --%>
		<script>
			HealthSettings.pageAction = 'confirmation';
		</script>
	</jsp:attribute>

	<jsp:body>
		<health_layout:slide_confirmation />
	</jsp:body>

</layout:journey_engine_page>