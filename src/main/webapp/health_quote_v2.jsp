<%--
	Health quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="sessionUtils" class="com.ctm.web.core.utils.SessionUtils"/>
<session:new verticalCode="HEALTH" authenticated="true" />

<session:new verticalCode="HEALTH" authenticated="true" />

<health_v1:redirect_rules />

<%-- START JOURNEY OVERRIDE - Part 1 of 2) --%>
<c:set var="journeyOverride" value="${pageSettings.getSetting('journeyOverride') eq 'Y'}" />

<c:choose>
    <c:when test="${callCentre && journeyOverride eq true}">
<c:set var="redirectURL" value="${pageSettings.getBaseUrl()}health_quote.jsp?" />
        <c:forEach items="${param}" var="currentParam">
            <c:set var="redirectURL">${redirectURL}${currentParam.key}=${currentParam.value}&</c:set>
        </c:forEach>
        <c:redirect url="${fn:substring(redirectURL,0,fn:length(redirectURL) - 1)}" />
    </c:when>
    <c:otherwise>
<%-- END JOURNEY OVERRIDE - Part 1 of 2) --%>

        <%-- Set global variable to flags for active split tests --%>
        <health_v2:splittest_helper />

        <core_v2:quote_check quoteType="health" />
        <core_v2:load_preload />

        <%-- Get data to build sections/categories/features on benefits and result pages. Used in results and benefits tags --%>
        <jsp:useBean id="resultsDisplayService" class="com.ctm.web.core.results.services.ResultsDisplayService" scope="request" />
        <jsp:useBean id="callCenterHours" class="com.ctm.web.core.web.openinghours.go.CallCenterHours" scope="page" />
        <jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" scope="request" />
        <jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />
        <c:set var="healthAlternatePricingActive" value="${healthPriceDetailService.isAlternatePriceActive(pageContext.getRequest())}" />

        <c:set var="resultTemplateItems" value="${resultsDisplayService.getResultsPageStructure('health')}" scope="request"  />

        <%--TODO: turn this on and off either in a settings file or in the database --%>
        <c:set var="showReducedHoursMessage" value="false" />

        <%-- Call centre numbers --%>
        <c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>
        <c:set var="callCentreHelpNumber" scope="request"><content:get key="callCentreHelpNumber"/></c:set>

<c:set var="openingHoursHeader" scope="request" ><content:getOpeningHours displayTodayOnly="true"/></c:set>
        <c:set var="callCentreHoursModal" scope="request"><content:getOpeningHoursModal /></c:set>

        <c:set var="isHealthV2" value="${true}" scope="request" />

        <%-- HTML --%>
        <layout_v1:journey_engine_page title="Health Quote">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header_button_left">
		<button type="button" class="navbar-toggle contact collapsed pull-left" data-toggle="collapse" data-target=".header-collapse-contact">
            <span class="sr-only">Toggle Contact Us</span>
            <span class="icon icon-phone"></span>
            <span class="icon icon-cross"></span>
        </button>
	</jsp:attribute>



	<jsp:attribute name="header">
		<div class="navbar-collapse header-collapse-contact collapse">
            <ul class="nav navbar-nav navbar-right callCentreNumberSection">
                <c:if test="${not empty callCentreNumber}">
                    <li>
                        <div class="navbar-text visible-xs">
                            <h4>Do you need a hand?</h4>
                  <h1>
                      <a class="needsclick callCentreNumberClick" href="tel:${callCentreNumber}">
                          Call <span class="noWrap callCentreNumber">${callCentreNumber}</span>
                      </a>
                  </h1><br/>
                                ${openingHoursHeader }
                        </div>
                        <div class="navbar-text hidden-xs" data-livechat="target">
                    <span class="icon-phone"></span>
                    <h1><span class="noWrap callCentreNumber">${callCentreNumber}</span></h1>
                                ${openingHoursHeader }
                        </div>
                        <div id="view_all_hours" class="hidden">${callCentreHoursModal}</div>
                        <div class="navbar-text hidden-xs" data-poweredby="header">&nbsp;</div>
                    </li>
                </c:if>
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

		<ul class="nav navbar-nav">
            <li class="slide-feature-back">
                <a href="javascript:;" data-slide-control="previous" class="btn-back"><span class="icon icon-arrow-left"></span> <span>Back</span></a>
            </li>

            <li class="dropdown dropdown-interactive slide-feature-emailquote" id="email-quote-dropdown">
                <a class="activator needsclick btn-email dropdown-toggle" data-toggle="dropdown" href="javascript:;"><span class="icon icon-envelope"></span> <span><c:choose><c:when test="${not empty authenticatedData.login.user.uid}">Save Quote</c:when><c:otherwise>Email Quote</c:otherwise></c:choose></span> <b class="caret"></b></a>
                <div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
                    <div class="dropdown-container">
                        <agg_v2:save_quote includeCallMeback="true" />
                    </div>
                </div>
            </li>

            <li class="dropdown dropdown-interactive slide-feature-filters" id="filters-dropdown">
                <a class="activator btn-dropdown dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"><span class="icon icon-filter"></span> <span>Filter</span><span class="hidden-sm"> Results</span> <b class="caret"></b></a>
                <div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
                    <health_v1:filters />
                </div>
            </li>
            <li class="dropdown dropdown-interactive slide-feature-benefits" id="benefits-dropdown">
                <a class="activator btn-dropdown dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"><span class="icon icon-cog"></span> <span>Customise</span><span class="hidden-sm"> Cover</span> <b class="caret"></b></a>
                <div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
                    <health_v1:benefits />
                </div>
            </li>

                <%-- @todo = showReferenceNo needs to be an attribute, this tag should potentially be rewritten or moved in a different place + that script is loaded via a marker in the tag. Probably should be moved to journey_engine_page --%>
            <li class="navbar-text-block slide-feature-reference">
                <form_v2:reference_number />
            </li>
        </ul>

		<div class="collapse navbar-collapse">
            <ul class="nav navbar-nav navbar-right slide-feature-pagination" data-results-pagination-pages-cell="true"></ul>
        </div>

        <div class="slide-feature-close-more-info">
            <a href="javascript:;" class="btn btn-close-more-info btn-hollow">Back to results</a>
        </div>

	</jsp:attribute>
							
	<jsp:attribute name="form_bottom">
	</jsp:attribute>
							
	<jsp:attribute name="footer">
		<health_v1:footer />
	</jsp:attribute>
							
	<jsp:attribute name="vertical_settings">
		<health_v1:settings />
	</jsp:attribute>

	<jsp:attribute name="body_end">
		<jsp:useBean id="webUtils" class="com.ctm.web.core.web.Utils" scope="request" />
		<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}" />
	</jsp:attribute>

	<jsp:attribute name="additional_meerkat_scripts">
		<c:if test="${callCentre}">
            <script src="${assetUrl}assets/js/bundles/simples_health${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
        </c:if>
	</jsp:attribute>

            <jsp:body>
                <health_v1:product_title_search />
                <core_v1:application_date />

                <%-- Product summary header for mobile --%>
                <div class="row productSummary-parent visible-xs">
                    <div class="productSummary-affix affix-top visible-xs">
                        <health_v1:policySummary />
                    </div>
                </div>

                <health_v1:choices xpathBenefits="${pageSettings.getVerticalCode()}/benefits" xpathSituation="${pageSettings.getVerticalCode()}/situation" />

                <%-- generate the benefit fields (hidden) for form selection. --%>
                <div class="hiddenFields">
                    <c:forEach items="${resultTemplateItems}" var="selectedValue">
                        <health_v2:benefitsHiddenItem item="${selectedValue}" />
                    </c:forEach>
                    <c:if test="${data['health/situation/accidentOnlyCover'] != '' && not empty data['health/situation/accidentOnlyCover']}">
                        <c:set var="fieldValue"><c:out value="${data['health/situation/accidentOnlyCover']}" escapeXml="true"/></c:set>
                    </c:if>
                    <input type="hidden" name="health_situation_accidentOnlyCover" class="benefit-item" value="${fieldValue}" />

                    <field_v1:hidden xpath="health/renderingMode" />
                    <field_v1:hidden xpath="health/rebate" />
                    <field_v1:hidden xpath="health/rebateChangeover" />
                    <field_v1:hidden xpath="health/loading" />
                    <field_v1:hidden xpath="health/primaryCAE" />
                    <field_v1:hidden xpath="health/partnerCAE" />

                    <form_v1:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid" />
                    <core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
                    <core_v2:authToken authToken="${param['authToken']}"/>
                </div>

                <%-- Slides --%>
                <health_v2_layout:slide_all_about_you />
                <health_v2_layout:slide_benefits />
                <health_v2_layout:slide_your_contact />
                <health_v2_layout:slide_results />
                <health_v2_layout:slide_application_details />
                <health_v2_layout:slide_payment_details />
                <health_v1:dual_pricing_templates />

                <field_v1:hidden xpath="environmentOverride" />
                <field_v1:hidden xpath="environmentValidatorOverride" />
                <input type="hidden" name="transcheck" id="transcheck" value="1" />
            </jsp:body>
        </layout_v1:journey_engine_page>

        <%-- START JOURNEY OVERRIDE - Part 2 of 2) --%>
    </c:otherwise>
</c:choose>
<%-- END JOURNEY OVERRIDE - Part 2 of 2) --%>
