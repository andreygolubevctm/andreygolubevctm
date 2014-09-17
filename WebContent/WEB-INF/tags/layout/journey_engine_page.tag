<%@ tag description="Journey Engine Page"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="webUtils" class="com.ctm.web.Utils" scope="request" />

<%@ attribute name="title"			required="false"  rtexprvalue="true"	 description="Page title" %>
<%@ attribute name="sessionPop"		required="false"  rtexprvalue="true"	 description="Set to 'false' to disable session pop" %>

<%@ attribute fragment="true" required="true" name="head" %>
<%@ attribute fragment="true" required="true" name="head_meta" %>
<%@ attribute fragment="true" required="true" name="form_bottom" %>
<%@ attribute fragment="true" required="true" name="footer" %>
<%@ attribute fragment="true" required="true" name="body_end" %>

<%@ attribute fragment="true" required="false" name="header" %>
<%@ attribute fragment="true" required="false" name="header_button_left" %>

<%@ attribute fragment="true" required="false" name="navbar" %>
<%@ attribute fragment="true" required="false" name="navbar_filter" %>
<%@ attribute fragment="true" required="false" name="navbar_outer" %>
<%@ attribute fragment="true" required="false" name="xs_results_pagination" %>
<%@ attribute fragment="true" required="true" name="vertical_settings" %>

<%@ attribute fragment="true" required="false" name="results_loading_message" %>

<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}" />
<c:set var="verticalCode" value="${pageSettings.getVerticalCode()}" />
<c:if test="${verticalCode eq 'car'}">
	<c:set var="verticalCode" value="quote" />
</c:if>

<c:if test="${empty sessionPop}"><c:set var="sessionPop" value="true" /></c:if>

<layout:page supertag="true" sessionPop="${sessionPop}" kampyle="true" title="${title}">

	<jsp:attribute name="head">
		<link rel="stylesheet" href="framework/jquery/plugins/jquery.nouislider/jquery.nouislider-6.2.0.css">
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

	<jsp:attribute name="navbar_filter">
		<jsp:invoke fragment="navbar_filter" />
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
		<script src="framework/jquery/plugins/bootstrap-datepicker/bootstrap-datepicker-2.0.js"></script>
		<script src="framework/jquery/plugins/jquery.nouislider/jquery.nouislider-6.2.0.min.js"></script>
		<script src="framework/jquery/plugins/bootstrap-switch-2.0.0.min.js"></script>

		<script src="common/js/scrollable.js"></script>

		<script src="common/js/results/Results.js?${revision}"></script>
		<script src="common/js/results/ResultsView.js?${revision}"></script>
		<script src="common/js/results/ResultsModel.js?${revision}"></script>
		<script src="common/js/results/ResultsUtilities.js?${revision}"></script>
		<script src="common/js/results/ResultsPagination.js?${revision}"></script>
		<script src="common/js/features/Features.js?${revision}"></script>

		<script src="common/js/compare/Compare.js?${revision}"></script>
		<script src="common/js/compare/CompareView.js?${revision}"></script>
		<script src="common/js/compare/CompareModel.js?${revision}"></script>

		<jsp:invoke fragment="body_end" />

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

					</div>
				</div>

			</article>

		</div>

		<agg:footer_outer>
			<jsp:invoke fragment="footer" />
		</agg:footer_outer>

	</jsp:body>

</layout:page>