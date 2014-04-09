<%@ tag description="Journey Engine Page"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="title"			required="false"  rtexprvalue="true"	 description="Page title" %>
<%@ attribute name="sessionPop"		required="false"  rtexprvalue="true"	 description="Set to 'false' to disable session pop" %>

<%@ attribute fragment="true" required="true" name="head" %>
<%@ attribute fragment="true" required="true" name="head_meta" %>
<%@ attribute fragment="true" required="true" name="form_bottom" %>
<%@ attribute fragment="true" required="true" name="footer" %>
<%@ attribute fragment="true" required="true" name="body_end" %>

<%@ attribute fragment="true" required="false" name="header" %>
<%@ attribute fragment="true" required="false" name="navbar" %>
<%@ attribute fragment="true" required="false" name="xs_results_pagination" %>

<c:if test="${empty sessionPop}"><c:set var="sessionPop" value="true" /></c:if>

<layout:page supertag="true" sessionPop="${sessionPop}" kampyle="true" title="${title}">

	<jsp:attribute name="head">
		<link rel="stylesheet" href="framework/jquery/plugins/jquery.nouislider/jquery.nouislider-5.0.0.css">
		<jsp:invoke fragment="head" />
	</jsp:attribute>

	<jsp:attribute name="head_meta">
		<jsp:invoke fragment="head_meta" />
	</jsp:attribute>

	<jsp:attribute name="header">
		<jsp:invoke fragment="header" />
	</jsp:attribute>

	<jsp:attribute name="navbar">
		<jsp:invoke fragment="navbar" />
	</jsp:attribute>

	<jsp:attribute name="xs_results_pagination">
		<div class="container">
			<ul class="nav navbar-nav ">
				<li>
					<a data-results-pagination-control="previous" href="javascript:;" class="btn-tertiary"><span class="icon icon-arrow-left"></span> Prev</a>
				</li>

				<li class="right">
					<a data-results-pagination-control="next" href="javascript:;" class="btn-tertiary ">Next <span class="icon icon-arrow-right"></span></a>
				</li>
			</ul>
		</div>
	</jsp:attribute>

	<jsp:attribute name="body_end">

		<script src="common/js/scrollable.js"></script>

		<script src="common/js/results/Results.js"></script>
		<script src="common/js/results/ResultsView.js"></script>
		<script src="common/js/results/ResultsModel.js"></script>
		<script src="common/js/results/ResultsUtilities.js"></script>
		<script src="common/js/results/ResultsPagination.js"></script>
		<script src="common/js/features/Features.js"></script>

		<script src="common/js/compare/Compare.js"></script>
		<script src="common/js/compare/CompareView.js"></script>
		<script src="common/js/compare/CompareModel.js"></script>

		<script src="framework/jquery/plugins/jquery.nouislider/jquery.nouislider-5.0.0.js"></script>
		<script src="framework/jquery/plugins/bootstrap-datepicker/bootstrap-datepicker-2.0.js"></script>
		<script src="framework/jquery/plugins/bootstrap-switch-2.0.0.min.js"></script>

		<jsp:invoke fragment="body_end" />

	</jsp:attribute>

	<jsp:body>

		<div id="pageContent">

			<%-- <div id="pageContentTop"></div> --%>

			<article class="container">

				<div id="journeyEngineContainer">
					<div id="journeyEngineLoading" class="journeyEngineLoader opacityTransitionQuick">
						<div class="spinner"></div>
						<p class="message">Please wait...</p>
					</div>

					<div id="mainform" class="form-horizontal" >
						<div id="journeyEngineSlidesContainer">
							<jsp:doBody />
						</div>

						<input type="hidden" id="${pageSettings.vertical}_journey_stage" name="${pageSettings.vertical}_journey_stage" value="${data[pageSettings.vertical]["journey/stage"]}" />

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