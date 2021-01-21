<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Setup New Health Session --%>
<jsp:useBean id="sessionUtils" class="com.ctm.web.core.utils.SessionUtils" />
<session:new verticalCode="HEALTH" authenticated="true" />
<c:set var="comparisonMode" scope="request"><content:get key="comparisonMode" /></c:set>
<c:set var="onlineHealthReformMessaging" scope="request"><content:get key="onlineHealthReformMessaging" /></c:set>
<c:set var="reformsBannerText" scope="request"><content:get key="reformsBanner" /></c:set>
<c:set var="covidBanner" scope="request"><content:get key="covidBanner" /></c:set>

<jsp:useBean id="rememberMeService" class="com.ctm.web.core.rememberme.services.RememberMeService" />
<agg_v1:remember_me_settings vertical="health" />

<%-- Redirect if Confirmation Page --%>
<health_v1:redirect_rules />

<health_v4:opening_text />

<c:set var="onlineCategoryVersion" value="health_v5" />

<c:choose>

    <%-- Redirect call centre consultants out of V4 --%>
    <c:when test="${callCentre && journeyOverride eq true}">
        <c:set var="redirectURL" value="${pageSettings.getBaseUrl()}health_quote.jsp?" />
        <c:forEach items="${param}" var="currentParam">
            <c:set var="redirectURL">${redirectURL}${currentParam.key}=${currentParam.value}&</c:set>
        </c:forEach>
        <c:redirect url="${fn:substring(redirectURL,0,fn:length(redirectURL) - 1)}" />
    </c:when>

    <c:when test="${isRememberMe and !hasUserVisitedInLast30Minutes }">
        <%-- Preserve the query string params and pass them to remember_me.jsp --%>
        <c:set var="redirectURL" value="${pageSettings.getBaseUrl()}remember_me.jsp?" />
        <c:forEach items="${param}" var="currentParam">
            <c:set var="redirectURL">${redirectURL}${currentParam.key}=${currentParam.value}&</c:set>
        </c:forEach>
        <c:redirect url="${fn:substring(redirectURL,0,fn:length(redirectURL) - 1)}" />

    </c:when>

    <c:when test="${isRememberMe and hasUserVisitedInLast30Minutes and empty param.reviewedit}">
        <c:set var="redirectURL" value="${pageSettings.getBaseUrl()}health_quote_v4.jsp?" />
        <c:forEach items="${param}" var="currentParam">
            <c:set var="redirectURL">${redirectURL}${currentParam.key}=${currentParam.value}&</c:set>
        </c:forEach>
        <c:redirect url="${redirectURL}transactionId=${rememberMeTransactionId}&reviewedit=true" />
    </c:when>

    <c:when test="${not callCentre}">

        <%-- ####### PRE JOURNEY SETUP ####### --%>

        <%-- Set global variable to flags for active split tests --%>

        <jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" scope="request" />
        <health_v4:splittest_helper />

        <core_v2:quote_check quoteType="health" />
        <core_v2:load_preload />

        <%-- Get data to build sections/categories/features on benefits and result pages. Used in results and benefits tags --%>
        <jsp:useBean id="resultsDisplayService" class="com.ctm.web.core.results.services.ResultsDisplayService" scope="request" />

        <c:set var="onlineCategoryVersion" value="health_cc" />
        <c:set var="resultTemplateItems" value="${resultsDisplayService.getResultsPageStructure(onlineCategoryVersion)}" scope="request" />

        <%-- Call centre numbers --%>
        <jsp:useBean id="callCenterHours" class="com.ctm.web.core.web.openinghours.go.CallCenterHours" scope="page" />
        <c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber" /></c:set>
        <c:set var="callCentreAppNumber" scope="request"><content:get key="callCentreAppNumber" /></c:set>
        <c:set var="callCentreHelpNumber" scope="request"><content:get key="callCentreHelpNumber" /></c:set>

        <c:set var="callCentreHoursModal" scope="request"><content:getOpeningHoursModal /></c:set>
        <c:set var="callCentreCBModal" scope="request"><health_v4:callback_modal /></c:set>

        <%-- Record remember touch if remembered in last 30mins --%>
        <c:if test="${isRememberMe and hasUserVisitedInLast30Minutes and not empty param.reviewedit}">
            <%-- Record rememberme touch against transaction --%>
            <jsp:useBean id="touchService" class="com.ctm.web.core.services.AccessTouchService" scope="page" />
            <c:set var="touchResponse">${touchService.recordTouch(data['current/transactionId'], "RememberMe", "ONLINE")}</c:set>
        </c:if>

        <%-- ####### PRE JOURNEY SETUP --%>

        <layout_v1:journey_engine_page title="Health Quote" bundleFileName="health_v5" displayNavigationBar="${false}" currentJourney="${param.j}">

            <jsp:attribute name="head">
            </jsp:attribute>

            <jsp:attribute name="head_meta">
			</jsp:attribute>

            <jsp:attribute name="header">
                <c:if test="${not empty callCentreNumber}">
                    <div class="navbar-collapse header-collapse-contact collapse online-results-control-container" data-online-category-version="${onlineCategoryVersion}">
                        <ul class="nav navbar-nav navbar-right callCentreNumberSection">
                            <li>
                                <div class="hidden-xs" data-livechat="target">
                                    <div class="callCentreNumber-container">
                                        <span class="icon icon-phone"></span> <a href="javascript:;" data-toggle="dialog"
                                                   data-content="#view_all_hours_cb"
                                                   data-dialog-hash-id="view_all_hours"
                                                   data-title="Call Centre Hours" data-cache="true">
                                        <span class="noWrap callCentreNumber">${callCentreNumber}</span>
                                        <span class="noWrap callCentreAppNumber">${callCentreAppNumber}</span></a>
                                    </div>
                                    ${callCentreCBModal}
                                </div>
                                <div id="view_all_hours" class="hidden">${callCentreHoursModal}</div>
                            </li>
                        </ul>
                    </div>
                </c:if>
            </jsp:attribute>

            <jsp:attribute name="progress_bar">

                <div class="progress-bar-row navbar-affix v4ProgressBar">
                  <competition:mobileFooter vertical="health"/>
                    <div class="container-fluid">
                        <div class="row">
                            <div class="progress-bar-bg"></div>
                            <div class="container progress-bar-container">
                                <ul class="journeyProgressBar" data-phase="journey"></ul>
                                <ul class="journeyProgressBar" data-phase="application"></ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="mobileViewStepText visible-xs"></div>

                <c:if test="${not empty reformsBannerText}">
                <div id="reforms-banner" class="reforms-banner hidden">
                    <div class="reforms-banner-icon"><span class="icon icon-info"></span></div>
                    <div class="reforms-banner-text">${reformsBannerText}</div>
                    <div class="reforms-banner-dismiss"></div>
                </div>
                </c:if>

                <div class="navbar-affix results-control-container">
                    <div class="container">
                        <div class="row">
                            <div class="col-xs-12 col-sm-6 col-md-4 results-filters-frequency invisible"></div>
                            <div class="hidden-xs hidden-sm col-md-2 text-center small filter-results-hidden-products"></div>
                            <div class="col-sm-9 more-info-return-to-results text-left"><a data-slide-control="prev" href="javascript:;" class="btn-close-more-info" data-analytics="nav button"><span class="icon icon-angle-left"></span> Back to results</a> </div>
                            <div class="col-xs-12 col-sm-6 col-md-3 results-pagination invisible">
                                <div class="navbar-collapse">
                                    <ul class="nav navbar-nav slide-feature-pagination" data-results-pagination-pages-cell="true"></ul>
                                </div>
                            </div>
                            <div class="hidden-xs hidden-sm col-md-3 text-center results-ref-sidebar">
                                <div class="quote-reference-number"><h3>Quote Ref: <span class="transactionId"></span></h3></div>
                                <div class="sidebar-widget sidebar-widget-attached filters-update-container" style="display: none">
                                    <!-- update button placeholder-->
                                </div>
                            </div>
                            <div class="row more-info-affixed-header"></div>
                        </div>
                    </div>
                </div>
                <c:if test="${covidBanner eq 'Y'}">
                    <div id="covid-banner">
                        <div class="container">
                            <img id="covid-icon-desktop" src="./assets/graphics/covid_19/covid-19-icon.png"/>
                            <div class="text-container">
                                <div class="title-container">
                                    <img id="covid-icon-mobile" src="./assets/graphics/covid_19/covid-19-icon.png"/>
                                    <span class="">
                                        You're covered for COVID-19
                                    </span>
                                </div>
                                <p>
                                    All hospital products on our panel include coverage for COVID-19. Refer to policy brochure for standard waiting periods.
                                </p>
                            </div>
                        </div>

                        <button id="covid-banner-close-button">
                            <img src="./assets/graphics/covid_19/close-button.png"/>
                        </button>
                    </div>
                </c:if>
            </jsp:attribute>

            <jsp:attribute name="body_end">
			</jsp:attribute>

            <jsp:attribute name="additional_meerkat_scripts">
                <c:if test="${callCentre}">
                    <script src="${assetUrl}assets/js/bundles/simples_health${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
                </c:if>
            </jsp:attribute>

            <jsp:attribute name="vertical_settings">
                <health_v4:settings />
			</jsp:attribute>

            <jsp:attribute name="footer">
                <health_v1:footer />
			</jsp:attribute>

            <jsp:attribute name="form_bottom">
			</jsp:attribute>

            <jsp:body>
                <health_v1:product_title_search />
                <core_v1:application_date />

                <health_v1:choices xpathBenefits="${pageSettings.getVerticalCode()}/benefits" xpathSituation="${pageSettings.getVerticalCode()}/situation" />

                <!-- <a class="refine-results" href="javascript:;"><span class="icon icon-filter"></span> <span>Filter</span></a> -->

                <%-- generate the benefit fields (hidden) for form selection. --%>
                <div class="hiddenFields">
                    <health_v5:hidden_fields />
                </div>

                <%-- Slides --%>
                <health_v4_layout:slide_about_you />
                <health_v5_layout:slide_insurance_preferences />
                <health_v4_layout:slide_contact />
                <health_v5_layout:slide_results />
                <health_v4_layout:slide_application />
                <health_v4_layout:slide_payment />

                <div class="visible-xs">
                    <health_v5:price_promise step="start" dismissible="true" />
                    <div class="coupon-tile-xs">
                        <coupon:promo_tile />
                    </div>
                </div>

                <health_v4:dual_pricing_templates />
                <c:if test="${isPyrrActive eq true}">
                    <health_v4:pyrr_campaign_templates />
                </c:if>

                <health_v4_payment:payment_frequency_template />

                <field_v1:hidden xpath="environmentOverride" />
                <field_v1:hidden xpath="staticOverride" />
                <field_v1:hidden xpath="environmentValidatorOverride" />
                <input type="hidden" name="transcheck" id="transcheck" value="1" />
                <agg_v3:save_quote />

                <%--Reward Campaign Template--%>
                <reward:template_campaign_tile />

                <zeus:offer_details_modal />
            </jsp:body>
        </layout_v1:journey_engine_page>
    </c:when>
    <c:otherwise>
        <c:set var="redirectURL" value="${pageSettings.getBaseUrl()}health_quote.jsp?" />
        <c:forEach items="${param}" var="currentParam">
            <c:set var="redirectURL">${redirectURL}${currentParam.key}=${currentParam.value}&</c:set>
        </c:forEach>
        <c:redirect url="${fn:substring(redirectURL,0,fn:length(redirectURL) - 1)}" />
    </c:otherwise>
</c:choose>
