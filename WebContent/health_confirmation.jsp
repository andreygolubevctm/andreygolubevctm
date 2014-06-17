<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="HEALTH" authenticated="true" />

<%-- Call centre numbers --%>
<c:set var="callCentreNumber"><content:get key="healthCallCentreNumber"/></c:set>
<%-- Call centre special hours --%>
<c:set var="callCentreSpecialHoursLink"><content:get key="healthCallCentreSpecialHoursLink"/></c:set>
<c:set var="callCentreSpecialHoursContent"><content:get key="healthCallCentreSpecialHoursContent"/></c:set>

<core:quote_check quoteType="health" />

<layout:journey_engine_page title="Health Confirmation" sessionPop="false">

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
							<h1><a class="needsclick" href="tel:+${callCentreNumber}">Call ${callCentreNumber}</a></h1>
							<p class="small">Our Australian based call centre hours are</p>
							<p><form:scrape id='135'/></p>
							${callCentreSpecialHoursContent}
						</div>
						<div class="navbar-text hidden-xs" data-livechat="target" data-livechat-fire='{"step":7,"confirmation":true,"navigationId":"confirmation"}'>
							<h4>Call us on</h4>
							<h1><span class="noWrap">${callCentreNumber}</span></h1>						
							<c:if test="${not empty callCentreSpecialHoursLink and not empty callCentreSpecialHoursContent}">
								${callCentreSpecialHoursLink}
								<div id="healthCallCentreSpecialHoursContent" class="hidden">
									<div class="row">
										<div class="col-sm-6">
											<h4>Normal Hours</h4>
											<p><form:scrape id='135'/></p>
						</div>
										<div class="col-sm-6">
											${callCentreSpecialHoursContent}
										</div>
									</div>
								</div>
							</c:if>			
						</div>
					</li>
				</c:if>
			</ul>

		</div>
	</jsp:attribute>

	<jsp:attribute name="navbar">
		<ul class="nav navbar-nav">
		<li><a href="javascript:window.print();" class="btn-tertiary"><span class="icon icon-blog"></span> <span>Print Page</span></a></li>
		<c:if test="${empty callCentre}">
			<li>
				<a href="${pageSettings.getBaseUrl()}health_quote.jsp" class="btn-primary needsclick"><span class="icon icon-undo"></span> <span>Start a new quote</span> <span class="icon icon-arrow-right hidden-xs"></span></a>
			</li>
		</c:if>
		</ul>
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<health:footer />
	</jsp:attribute>

	<jsp:attribute name="body_end">
		<health:settings />

		<%-- Force this to be confirmation because it is set by a param value and might change. This is a safety decision because if it is something else, bad things happen. --%>
		<script>
			VerticalSettings.pageAction = 'confirmation';
		</script>
	</jsp:attribute>

	<jsp:body>
		<health_layout:slide_confirmation />
	</jsp:body>

</layout:journey_engine_page>