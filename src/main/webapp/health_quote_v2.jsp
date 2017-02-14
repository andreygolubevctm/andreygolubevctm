<%--
	Health quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="sessionUtils" class="com.ctm.web.core.utils.SessionUtils"/>
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
        <c:set var="callCentreAppNumber" scope="request"><content:get key="callCentreAppNumber"/></c:set>
        <c:set var="callCentreHelpNumber" scope="request"><content:get key="callCentreHelpNumber"/></c:set>

        <c:set var="openingHoursHeader" scope="request" ><content:getOpeningHours displayTodayOnly="true"/></c:set>
        <c:set var="callCentreHoursModal" scope="request"><content:getOpeningHoursModal /></c:set>
        <c:set var="callCentreCBModal" scope="request"><health_v3:callback_modal /></c:set>

        <%-- SET SITUATION WHEN LOADING A QUOTE AND NO SITUATION SET.
             ONLY OCCURS WHEN V4 QUOTE BEING LOADED INTO V2 --%>
        <c:if test="${isNewQuote eq false and empty data[health/situation/healthSitu]}">
            <go:setData dataVar="data" xpath="health/situation/healthSitu" value="LC" />
        </c:if>

        <%-- HTML --%>
        <layout_v1:journey_engine_page title="Health Quote" bundleFileName="health_v2">

        <jsp:attribute name="head">
        </jsp:attribute>

        <jsp:attribute name="head_meta">
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
                          Call <span class="noWrap callCentreNumber">${callCentreNumber}</span><span class="noWrap callCentreAppNumber" style="display:none">${callCentreAppNumber}</span>
                      </a>
                  </h1><br/>
                                ${openingHoursHeader }
                        </div>
                        <div class="navbar-text hidden-xs" data-livechat="target">
                    <span class="icon-phone"></span>
                    <h1><span class="noWrap callCentreNumber">${callCentreNumber}</span><span class="noWrap callCentreAppNumber" style="display:none">${callCentreAppNumber}</span></h1>
                                ${openingHoursHeader }
                        </div>
                        <div class="navbar-text hidden-xs" data-poweredby="header"></div>
                    </li>
                    <li>
                        <health_v3:callback_link />
                        ${callCentreCBModal}
                        <div id="view_all_hours" class="hidden">${callCentreHoursModal}</div>
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

		<ul class="nav navbar-nav" role="menu">

            <core_v2:offcanvas_header />

            <li class="slide-feature-back">
                <a href="javascript:;" data-slide-control="previous" class="btn-back" <field_v1:analytics_attr analVal="nav button" quoteChar="\"" />><span class="icon icon-angle-left"></span> <span>Go Back</span></a>
            </li>
            <li class="slide-feature-savequote">
                <a href="javascript:;"  data-opensavequote="true" class="" <field_v1:analytics_attr analVal="save button" quoteChar="\"" />><span class="icon icon-save-quote"><span class="path1"></span><span class="path2"></span><span class="path3"></span><span class="path4"></span></span><span>Save Results</span></a>
            </li>
            <li>
                <div class="mobile-hours">${callCentreHoursModal}</div>
            </li>
        </ul>

        <div class="slide-feature-close-more-info">
            <a href="javascript:;" class="btn btn-close-more-info btn-hollow">Back to results</a>
        </div>

        </jsp:attribute>

        <jsp:attribute name="form_bottom">
        </jsp:attribute>

        <jsp:attribute name="footer">
            <health_v1:footer />
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

                <health_v1:dual_pricing_settings />

                <%-- Product summary header for mobile --%>
                <div class="row productSummary-parent <c:choose><c:when test="${isDualPriceActive eq true}">hidden</c:when><c:otherwise>visible-xs</c:otherwise></c:choose>">
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
                    <input type="hidden" name="health_situation_accidentOnlyCover" class="benefit-item" value="${fieldValue}" data-skey="accidentOnlyCover" />
                    <c:set var="maxMilliToGetResults">
                        <content:get key="maxMilliSecToWait"/>
                    </c:set>
                    <c:choose>
                        <c:when test="${not empty maxMilliToGetResults}">
                            <input type="hidden" id="maxMilliSecToWait" value="${maxMilliToGetResults}"/>
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" id="maxMilliSecToWait" value="0"/>
                        </c:otherwise>
                    </c:choose>
                    <input type="hidden" id="waitMessage" value="<content:get key='waitMessage'/>"/>

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
                <health_v3_layout:slide_results />
                <health_v2_layout:slide_application_details />
                <health_v2_layout:slide_payment_details />
                <health_v1:dual_pricing_templates />
                <health_v3:payment_frequency_template />

                <field_v1:hidden xpath="environmentOverride" />
                <field_v1:hidden xpath="staticOverride" />
                <field_v1:hidden xpath="environmentValidatorOverride" />
                <input type="hidden" name="transcheck" id="transcheck" value="1" />
                <agg_v3:save_quote />
                <%--Reward Campaign Template--%>
                <reward:template_campaign_tile />
            </jsp:body>
        </layout_v1:journey_engine_page>

        <%-- START JOURNEY OVERRIDE - Part 2 of 2) --%>
    </c:otherwise>
</c:choose>
<%-- END JOURNEY OVERRIDE - Part 2 of 2) --%>
