<%--
	CARLMI quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:redirect url="https://www.comparethemarket.com.au/car-insurance"/>

<c:set var="redirectURL" value="${pageSettings.getBaseUrl()}car_quote.jsp" />
<c:redirect url="${redirectURL}" />

<session:new verticalCode="CARLMI" authenticated="true" />

<core_v2:quote_check quoteType="carlmi" />
<core_v2:load_preload />

<%-- HTML --%>
<layout_v1:journey_engine_page title="Car Insurance Brand Comparison">

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

	<jsp:attribute name="progress_bar">
      <div class="progress-bar-row collapse navbar-collapse">
		  <div class="container">
			  <ul class="journeyProgressBar_v2"></ul>
		  </div>
	  </div>
    </jsp:attribute>

	<jsp:attribute name="navbar">

		<ul class="nav navbar-nav" role="menu">
			<core_v2:offcanvas_header />

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
		<core_v1:whitelabeled_footer />
	</jsp:attribute>

    <jsp:attribute name="xs_results_pagination">
		<div class="navbar navbar-default xs-results-pagination navMenu-row-fixed visible-xs">
            <div class="container">
                <ul class="nav navbar-nav ">
                    <li class="navbar-text center hidden" data-results-pagination-pagetext="true"></li>

                    <li>
                        <a data-results-pagination-control="previous" href="javascript:;" class="btn-pagination" data-analytics="pagination previous"><span class="icon icon-arrow-left"></span>
                            Prev</a>
                    </li>

                    <li class="right">
                        <a data-results-pagination-control="next" href="javascript:;" class="btn-pagination " data-analytics="pagination next">Next <span class="icon icon-arrow-right"></span></a>
                    </li>
                </ul>
            </div>
        </div>
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
			<form_v1:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid" />
			<core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
		</div>

		<input type="hidden" name="transcheck" id="transcheck" value="1" />
	</jsp:body>

</layout_v1:journey_engine_page>