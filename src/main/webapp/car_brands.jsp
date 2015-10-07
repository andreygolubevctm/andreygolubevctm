<%--
	CARLMI quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<session:new verticalCode="CARLMI" authenticated="true" />

<core_new:quote_check quoteType="carlmi" />
<core_new:load_preload />

<%-- HTML --%>
<layout:journey_engine_page title="Car Insurance Brand Comparison">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
		<div class="navbar-collapse header-collapse-contact collapse">
			<ul class="nav navbar-nav navbar-right">
				<li class="navbar-text push-top slide-feature-back compare-prices-cta">
					<div class="hidden-xs">
						<h5>Compare Prices From<br />Our Participating Providers</h5>
					</div>
				</li>
				<li class="navbar-text slide-feature-back">
					<a href="${pageSettings.getBaseUrl()}car_quote.jsp" class="btn btn-next">
						 <span>Get a Quote</span> <span class="icon icon-arrow-right"></span>
					</a>
				</li>
			</ul>
		</div>
	</jsp:attribute>

	<jsp:attribute name="navbar">

		<ul class="nav navbar-nav" role="menu">
			<li class="visible-xs">
				<span class="navbar-text-block navMenu-header">Menu</span>
			</li>

			<li class="slide-feature-back">
				<a href="javascript:;" data-slide-control="previous" class="btn-back"><span class="icon icon-arrow-left"></span> <span>Back</span></a>
			</li>
		</ul>

		<div class="collapse navbar-collapse">
			<ul class="nav navbar-nav navbar-right slide-feature-pagination" data-results-pagination-pages-cell="true"></ul>
		</div>

	</jsp:attribute>

	<jsp:attribute name="navbar_additional">
	</jsp:attribute>

	<jsp:attribute name="navbar_outer">
		<div class="row navbar-inverse hidden-sm hidden-md hidden-lg">
			<div class="container">
				<ul class="nav navbar-nav navbar-inverse col-sm-12 row">
					<li class="container row">
						<ul class="nav navbar-nav navbar-inverse col-sm-12">
							<li>
								<span><content:get key="lmiCompareCopy" /></span>
							</li>
							<li>
								<a href="${pageSettings.getBaseUrl()}car_quote.jsp" class="btn btn-next getQuote">
									<span>Get a Quote</span> <span class="icon icon-arrow-right"></span>
								</a>
							</li>

						</ul>
					</li>
				</ul>
			</div>
		</div>
	</jsp:attribute>

	<jsp:attribute name="results_loading_message">
	</jsp:attribute>


	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<core:whitelabeled_footer />
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<lmi:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

	<jsp:body>
		<%-- Slides --%>
		<lmi_layout:slide_form />
		<lmi_layout:slide_results />

		<div class="hiddenFields">
			<form:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid" />
			<core:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
		</div>

		<input type="hidden" name="transcheck" id="transcheck" value="1" />
	</jsp:body>

</layout:journey_engine_page>