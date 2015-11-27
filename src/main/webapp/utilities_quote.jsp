<%--
	UTILITIES quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="UTILITIES" authenticated="true"/>

<core_new:quote_check quoteType="utilities"/>
<core_new:load_preload/>

<%-- Call centre numbers --%>
<c:set var="callCentreNumber" scope="request"><content:get key="genericCallCentreNumber"/></c:set>
<c:set var="callCentreHelpNumber" scope="request"><content:get key="genericCallCentreHelpNumber"/></c:set>


<%-- HTML --%>
<layout:journey_engine_page title="Utilities Quote">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>
	
	<jsp:attribute name="header">
		<div class="navbar-collapse header-collapse-contact collapse">
            <ul class="nav navbar-nav navbar-right">
                <c:if test="${not empty callCentreNumber}">
                    <li>
                        <div class="navbar-text hidden-xs" data-livechat="target">
                            <h4>Call us on</h4>

                            <h1><span class="noWrap">${callCentreNumber}</span></h1>
                            <%-- This was hard-coded here instead of using health's opening hours tag
                                 as Guilly suggested he didn't want to show other verticals opening hours in Simples and open it up to other users at this time.
                                 Maybe one day, but its either this or nothing.
                                 --%>
                            <div class="opening-hours">
                            <span>
                                <span class="today-hours"><content:get key="utilitiesOpeningHours" /></span>
                            </span>
                            </div>
                        </div>
                        <div class="navbar-text hidden-xs" data-poweredby="header">&nbsp;</div>
                    </li>
                </c:if>
            </ul>
        </div>
	</jsp:attribute>

	<jsp:attribute name="navbar">

		<ul class="nav navbar-nav" role="menu">
            <li class="visible-xs">
                <span class="navbar-text-block navMenu-header">Menu</span>
            </li>
					
            <li class="slide-feature-phone hidden-sm hidden-md hidden-lg">
                <a class="needsclick" href="tel:${callCentreNumber}"><span class="icon icon-phone"></span> <span
                        class="noWrap">${callCentreNumber}</span></a>
            </li>
            <li class="navbar-text slide-reference-number hidden-sm hidden-md hidden-lg">
                <div class="thoughtWorldRefNoContainer"></div>
            </li>
            <li class="slide-feature-back">
                <a href="javascript:;" data-slide-control="previous" class="btn-back"><span
                        class="icon icon-arrow-left"></span> <span>Back</span></a>
            </li>
            <li class="navbar-text slide-reference-number hidden-xs">
                <div class="thoughtWorldRefNoContainer"></div>
            </li>
        </ul>
					
    <div class="collapse navbar-collapse">
        <ul class="nav navbar-nav navbar-right results-summary-container">
            <li id="results-summary-container"></li>
        </ul>
    </div>
	</jsp:attribute>

		<jsp:attribute name="navbar_outer">
			
		<div class="row sortbar-container navbar-inverse">
            <div class="container">
                <ul class="sortbar-parent nav navbar-nav navbar-inverse col-sm-12 row">
                    <li class="visible-xs">
                        <a href="javascript:;" class="">
                            <span class="icon icon-filter"></span> <span>Sort Results By</span>
                        </a>
                    </li>
                    <li class="container row sortbar-children">
                        <ul class="nav navbar-nav navbar-inverse col-sm-12">
                            <li class="hidden-xs col-sm-2 col-lg-5">
                                <span class="navbar-brand">Sort <span class="optional-lg">your</span> <span
                                        class="optional-md">results</span> by</span>
                            </li>
                            <li class="col-sm-3 col-lg-1 colContractPeriod">
                                <a href="javascript:;" data-sort-type="contractPeriodValue" data-sort-dir="asc">
                                    <span class="icon"></span> <span>Contract <br class="hidden-sm hidden-md" />period</span>
                                </a>
                            </li>
                            <li class="col-sm-3 col-lg-2 colYearlySavings">
                                <a href="javascript:;" data-sort-type="yearlySavingsValue" data-sort-dir="desc">
                                    <span class="icon"></span> <span>Savings <br class="hidden-sm hidden-md" />up to</span>
                                </a>
                            </li>
                            <li class="hidden col-sm-3 col-lg-2 colEstimatedCost">
                                <a href="javascript:;" data-sort-type="estimatedCostValue" data-sort-dir="asc">
                                    <span class="icon"></span> <span>Estimated Cost</span>
                                </a>
                            </li>
                            <li class="col-sm-4 col-lg-2 active colTotalDiscounts">
                                <a href="javascript:;" data-sort-type="totalDiscountValue" data-sort-dir="desc">
                                    <span class="icon"></span> <span>Total Available <br class="hidden-sm hidden-md" />Discounts</span>
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
		<core:whitelabeled_footer/>
	</jsp:attribute>
						
	<jsp:attribute name="vertical_settings">
		<utilities_new:settings/>
	</jsp:attribute>
							
	<jsp:attribute name="body_end">
	</jsp:attribute>
								
    <jsp:body>
							
        <%-- Slides --%>
        <utilities_new_layout:slide_your_details/>
        <utilities_new_layout:slide_contact_details/>
        <utilities_new_layout:slide_results/>
        <utilities_new_layout:slide_enquiry/>
							
        <div class="hiddenFields">
            <form:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid"/>
            <core:referral_tracking vertical="${pageSettings.getVerticalCode()}"/>
					</div>
        <input type="hidden" name="transcheck" id="transcheck" value="1"/>
        <input type="hidden" name="${pageSettings.getVerticalCode()}_partner_uniqueCustomerId" id="${pageSettings.getVerticalCode()}_partner_uniqueCustomerId" value="" />
        <field:hidden xpath="environmentOverride" />
    </jsp:body>
					
</layout:journey_engine_page>