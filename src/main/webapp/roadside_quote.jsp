<%--
	ROADSIDE quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="ROADSIDE" authenticated="true"/>

<core_v2:quote_check quoteType="roadside"/>
<core_v2:load_preload/>


<%-- HTML --%>
<layout_v1:journey_engine_page title="Roadside Assistance Quote">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>


	<jsp:attribute name="navbar_outer">
        <div class="container">
            <div class="row sortbar-container navbar-inverse">
                <ul class="sortbar-parent nav navbar-nav navbar-inverse col-sm-12 row">
                    <li class="visible-xs">
                        <a href="javascript:;" class="">
                            <span class="icon icon-filter"></span> <span>Sort Results By</span>
                        </a>
                    </li>
                    <li class="container row sortbar-children">

                        <ul class="nav navbar-nav navbar-inverse col-sm-12">
                            <core_v2:offcanvas_header />
                            <li class="hidden-xs col-sm-2 col-lg-2">
                                <a href="javascript:;" data-slide-control="previous" class="borderless">
                                     <span class="icon icon-arrow-left"></span> <span>Revise Details</span>
                                </a>
                            </li>
                            <li class="hidden-xs col-sm-1 col-lg-2">
                        <%--<span class="navbar-brand">Sort <span class="optional-lg">your</span> <span
                                class="optional-md">results</span> by</span>--%>
                            </li>
                            <li class="col-sm-2 col-lg-2 hidden-xs">
                                <a href="javascript:;" class="sortbar-title force-no-hover">
                                    <span class="icon"></span> <span>Towing <br class="hidden-sm hidden-md"/>Limits</span>
                                </a>
                            </li>
                            <li class="col-sm-2 col-lg-1">
                                <a href="javascript:;" data-sort-type="info.roadCall" data-sort-dir="desc" class="sortbar-title">
                                    <span class="icon"></span> <span>Annual <br class="hidden-sm hidden-md"/>Callouts</span>
                                </a>
                            </li>
                            <li class="col-sm-2 col-lg-1">
                                <a href="javascript:;" data-sort-type="info.keyService" data-sort-dir="desc" class="sortbar-title">
                                    <span class="icon"></span> <span>Emergency <br class="hidden-sm hidden-md"/>Key Service</span>
                                </a>
                            </li>
                            <li class="col-sm-3 col-lg-2 active">
                                <a href="javascript:;" data-sort-type="price.premium" data-sort-dir="asc" class="sortbar-title">
                                    <span class="icon"></span> <span>Annual <br class="hidden-sm hidden-md"/>Price</span>
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
	</jsp:attribute>

    <jsp:attribute name="results_loading_message"></jsp:attribute>


    <jsp:attribute name="form_bottom"></jsp:attribute>

	<jsp:attribute name="footer">
		<core_v1:whitelabeled_footer/>
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<roadside:settings/>
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

    <jsp:body>

        <%-- Slides --%>
        <roadside_layout:slide_your_car/>
        <roadside_layout:slide_results/>

        <div class="hiddenFields">
            <form_v1:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid"/>
            <core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}"/>
        </div>
        <input type="hidden" name="transcheck" id="transcheck" value="1"/>

    </jsp:body>

</layout_v1:journey_engine_page>
