<%@ tag description="Journey Engine Page"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="webUtils" class="com.ctm.web.core.web.Utils" scope="request" />

<%@ attribute name="title"			required="false"  rtexprvalue="true"	 description="Page title" %>

<%@ attribute fragment="true" required="true" name="head" %>
<%@ attribute fragment="true" required="true" name="head_meta" %>
<%@ attribute fragment="true" required="true" name="form_bottom" %>
<%@ attribute fragment="true" required="true" name="footer" %>
<%@ attribute fragment="true" required="true" name="body_end" %>
<%@ attribute fragment="true" required="false" name="additional_meerkat_scripts" %>

<%@ attribute fragment="true" required="false" name="header" %>
<%@ attribute fragment="true" required="false" name="header_button_left" %>

<%@ attribute fragment="true" required="false" name="navbar" %>
<%@ attribute fragment="true" required="false" name="navbar_additional" %>
<%@ attribute fragment="true" required="false" name="navbar_outer" %>
<%@ attribute fragment="true" required="false" name="xs_results_pagination" %>
<%@ attribute fragment="true" required="true" name="vertical_settings" %>

<%@ attribute fragment="true" required="false" name="results_loading_message" %>
<%@ attribute fragment="true" required="false" name="before_close_body" %>

<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}" />
<c:set var="verticalCode" value="${pageSettings.getVerticalCode()}" />
<c:if test="${verticalCode eq 'car'}">
	<c:set var="verticalCode" value="quote" />
</c:if>

<c:if test="${empty sessionPop}"><c:set var="sessionPop" value="true" /></c:if>

<layout:page title="${title}">

	<jsp:attribute name="head">
		<jsp:invoke fragment="head" />
	</jsp:attribute>

	<jsp:attribute name="head_meta">
		<jsp:invoke fragment="head_meta" />
	</jsp:attribute>

	<jsp:attribute name="header">
		<jsp:invoke fragment="header" />
	</jsp:attribute>

	<jsp:attribute name="header_button_left"><jsp:invoke fragment="header_button_left" /></jsp:attribute>

	<jsp:attribute name="navbar">
		<jsp:invoke fragment="navbar" />
	</jsp:attribute>

	<jsp:attribute name="navbar_additional">
		<jsp:invoke fragment="navbar_additional" />
	</jsp:attribute>

	<jsp:attribute name="navbar_outer">
		<jsp:invoke fragment="navbar_outer" />
	</jsp:attribute>

	<jsp:attribute name="xs_results_pagination">
		<div class="container">
			<ul class="nav navbar-nav ">
				<li class="navbar-text center hidden" data-results-pagination-pagetext="true"></li>

				<li>
					<a data-results-pagination-control="previous" href="javascript:;" class="btn-pagination"><span class="icon icon-arrow-left"></span> Prev</a>
				</li>

				<li class="right">
					<a data-results-pagination-control="next" href="javascript:;" class="btn-pagination ">Next <span class="icon icon-arrow-right"></span></a>
				</li>
			</ul>
		</div>
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<jsp:invoke fragment="vertical_settings" />
	</jsp:attribute>

	<jsp:attribute name="body_end">
		<jsp:invoke fragment="body_end" />
	</jsp:attribute>

	<jsp:attribute name="additional_meerkat_scripts">
		<jsp:invoke fragment="additional_meerkat_scripts" />
	</jsp:attribute>

	<jsp:attribute name="before_close_body">
		<content:get key="beforeCloseBody" suppKey="journey" />
		<jsp:invoke fragment="before_close_body" />
	</jsp:attribute>

	<jsp:body>

		<div id="pageContent">

			<%-- <div id="pageContentTop"></div> --%>

			<article class="container">

				<div id="journeyEngineContainer">
					<div id="journeyEngineLoading" class="journeyEngineLoader opacityTransitionQuick">
						<div class="loading-logo"></div>
						<p class="message">Please wait...</p>
						<jsp:invoke fragment="results_loading_message" />
					</div>

					<div id="mainform" class="form-horizontal" >

						<core_new:journey_tracking />

						<core_new:tracking_key />

						<div id="journeyEngineSlidesContainer">
							<jsp:doBody />
						</div>

						<input
							type="hidden"
							id="${verticalCode}_journey_stage"
							name="${verticalCode}_journey_stage"
							value="${data[verticalCode]['journey/stage']}"
							class="journey_stage"
						/>

						<jsp:invoke fragment="form_bottom" />

						<c:if test="${pageSettings.hasSetting('sendBestPriceSplitTestingEnabled')}">
							<c:if test="${pageSettings.getSetting('sendBestPriceSplitTestingEnabled') eq 'Y' && not empty param.splitEmail }">
								<field:hidden xpath="${verticalCode}/bestPriceSplitTest" defaultValue="${param.splitEmail eq 2 ? 2 : 1 }" />
							</c:if>
						</c:if>
					</div>
				</div>

			</article>

		</div>

		<agg:footer_outer>
			<jsp:invoke fragment="footer" />
		</agg:footer_outer>

	</jsp:body>

</layout:page>