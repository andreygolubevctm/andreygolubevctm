<%--
	UTILITIES quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="UTILITIES" authenticated="true"/>

<core_v2:quote_check quoteType="utilities"/>
<core_v2:load_preload/>

<%-- Call centre numbers --%>
<c:set var="callCentreNumber" scope="request"><content:get key="genericCallCentreNumber"/></c:set>
<c:set var="callCentreHelpNumber" scope="request"><content:get key="genericCallCentreHelpNumber"/></c:set>

<%-- Set global variable to flags for active split tests --%>
<utilities_v3:splittest_helper />

<c:set var="brandedName"><content:get key="boldedBrandDisplayName"/></c:set>
<c:set var="privacyOptinText" scope="session">I understand ${brandedName} compares energy plans based on peak tariffs from a range of participating retailers. By providing my contact details I agree that ${brandedName} and its partner Thought World may contact me about the services they provide.
    I confirm that I have read the <form_v1:link_privacy_statement/>.</c:set>

<c:set var="body_class_name">
    <c:if test="${not empty splitTestEnabled and splitTestEnabled eq 'Y'}">utilities_design_55</c:if>
</c:set>

<%-- HTML --%>
<layout_v3:journey_engine_page title="Utilities Quote" body_class_name="${body_class_name}">

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

	<jsp:attribute name="navbar_additional_options">
            <li class="slide-feature-phone hidden-sm hidden-md hidden-lg">
                <a class="needsclick" href="tel:${callCentreNumber}"><span class="icon icon-phone"></span> <span
                        class="noWrap">${callCentreNumber}</span></a>
            </li>
            <li class="navbar-text slide-reference-number hidden-sm hidden-md hidden-lg">
                <div class="thoughtWorldRefNoContainer"></div>
            </li>
            <li class="navbar-text slide-reference-number hidden-xs">
                <div class="thoughtWorldRefNoContainer"></div>
            </li>
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
                                    <span class="icon"></span> <span>Estimated Bill Cost</span>
                                </a>
                            </li>
                            <li class="hidden col-sm-3 col-lg-2 colEstimatedCost">
                                <a href="javascript:;" data-sort-type="estimatedCostValue" data-sort-dir="asc">
                                    <span class="icon"></span> <span>Estimated Cost</span>
                                </a>
                            </li>
                            <li class="hidden col-sm-3 col-lg-2 colEstimatedUsage">
                                <a href="javascript:;">
                                    <span class="icon"></span> <span>Estimated Usage</span>
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
		<core_v1:whitelabeled_footer/>
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<utilities_v2:settings/>
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

    <jsp:body>

        <utilities_v3:parameters xpathHouseholdDetails="utilities/householdDetails"/>
        <c:choose>
            <c:when test="${splitTestEnabled eq 'Y'}">
                <%-- Slides --%>
                <utilities_v3_layout:slide_your_details/>
                <utilities_v3_layout:slide_contact_details/>
                <utilities_v3_layout:slide_results/>
                <utilities_v3_layout:slide_enquiry/>
                <utilities_v3_content:yourDetailsSnapshot />
            </c:when>
            <c:otherwise>
                <%-- Slides --%>
                <utilities_v2_layout:slide_your_details/>
                <utilities_v2_layout:slide_contact_details/>
                <utilities_v2_layout:slide_results/>
                <utilities_v2_layout:slide_enquiry/>
            </c:otherwise>
        </c:choose>

        <div class="hiddenFields">
            <form_v1:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid"/>
            <core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}"/>
					</div>
        <input type="hidden" name="transcheck" id="transcheck" value="1"/>
        <input type="hidden" name="${pageSettings.getVerticalCode()}_partner_uniqueCustomerId" id="${pageSettings.getVerticalCode()}_partner_uniqueCustomerId" value="" />
        <field_v1:hidden xpath="environmentOverride" />
    </jsp:body>

</layout_v3:journey_engine_page>
