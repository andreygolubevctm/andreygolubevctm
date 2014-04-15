<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="ROADSIDE" />

<c:set var="xpath" value="roadside" scope="session" />

<c:if test="${empty param.action}">
	<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
</c:if>

<%-- PRELOAD DATA --%>
<c:if test="${empty param.action && param.preload == '2'}">
<go:setData dataVar="data" value="*DELETE" xpath="${xpath}" />
			<c:import url="test_data/preload_roadside.xml" var="roadsideXml" />
			<go:setData dataVar="data" xml="${roadsideXml}" />
</c:if>


<core:doctype />
<go:html>
	<core:head quoteType="${xpath}" title="Roadside Assistance Quote Capture" mainCss="common/roadside.css" mainJs="common/js/roadside.js" />

	<body class="roadside stage-0">

		<agg:supertag_top type="Roadside"/>

		<form:form action="javascript:void(0);" method="GET" id="mainform" name="frmMain">

			<form:header quoteType="${xpath}" hasReferenceNo="true" showReferenceNo="false"/>
			<core:referral_tracking vertical="${xpath}/vehicle" />
			<roadside:progress_bar />
			<div id="wrapper" class="clearfix">

				<div id="page" class="clearfix">

					<div id="content">

						<!-- Main Quote Engine content -->
						<slider:slideContainer className="sliderContainer">
							<slider:slide id="slide0" title="Car Capture">
								<roadside:car />
							</slider:slide>
						</slider:slideContainer>

						<form:error id="slideErrorContainer" className="slideErrorContainer" errorOffset="42" />

						<!-- Bottom "step" buttons -->
						<div class="button-wrapper">
							<a href="javascript:void(0);" class="button next" id="next-step"><span>Next step</span></a>
						</div>

						<!-- End main QE content -->

					</div>

					<form:help />

					<div class="right-panel">
						<div class="right-panel-top"></div>
						<div class="right-panel-middle">
							<agg:side_panel />
						</div>
						<div class="right-panel-bottom"></div>
					</div>
					<div class="clearfix"></div>
				</div>

				<%-- Quote results (default to be hidden) --%>
				<roadside:results />
			</div>

		</form:form>

		<roadside:footer />

		<core:closing_body>
			<agg:includes supertag="true" />
			<roadside:includes />
		</core:closing_body>

	</body>

</go:html>