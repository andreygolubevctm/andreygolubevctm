<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Setup New Health Session --%>
<jsp:useBean id="sessionUtils" class="com.ctm.web.core.utils.SessionUtils" />
<session:new verticalCode="HEALTH" authenticated="true" />

<%-- Redirect if Confirmation Page --%>
<health_v1:redirect_rules />

<c:choose>
    <c:when test="${not callCentre}">

        <%-- ####### PRE JOURNEY SETUP ####### --%>

        <%-- Set global variable to flags for active split tests --%>

        <jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" scope="request" />
        <health_v4:splittest_helper />

        <core_v2:quote_check quoteType="health" />
        <core_v2:load_preload />

        <%-- Get data to build sections/categories/features on benefits and result pages. Used in results and benefits tags --%>
        <jsp:useBean id="resultsDisplayService" class="com.ctm.web.core.results.services.ResultsDisplayService" scope="request" />
        <c:set var="resultTemplateItems" value="${resultsDisplayService.getResultsPageStructure('health_v4')}" scope="request"  />

        <%-- Call centre numbers --%>
        <jsp:useBean id="callCenterHours" class="com.ctm.web.core.web.openinghours.go.CallCenterHours" scope="page" />
        <c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber" /></c:set>
        <c:set var="callCentreAppNumber" scope="request"><content:get key="callCentreAppNumber" /></c:set>
        <c:set var="callCentreHelpNumber" scope="request"><content:get key="callCentreHelpNumber" /></c:set>

        <c:set var="callCentreHoursModal" scope="request"><content:getOpeningHoursModal /></c:set>
        <c:set var="callCentreCBModal" scope="request"><health_v3:callback_modal /></c:set>

        <%-- ####### PRE JOURNEY SETUP --%>

        <layout_v1:journey_engine_page title="Health Quote" bundleFileName="health_v4" displayNavigationBar="${false}">

            <jsp:attribute name="head">
            </jsp:attribute>

            <jsp:attribute name="head_meta">
			</jsp:attribute>

            <jsp:attribute name="header">
                <c:if test="${not empty callCentreNumber}">
                    <div class="navbar-collapse header-collapse-contact collapse">
                        <ul class="nav navbar-nav navbar-right callCentreNumberSection">
                            <li class="navbar-text">Confused? Talk to our experts... Simples!</li>
                            <li>
                                <div class="navbar-text hidden-xs" data-livechat="target">
                                    Call us <a href="javascript:;" data-toggle="dialog"
                                               data-content="#view_all_hours"
                                               data-dialog-hash-id="view_all_hours"
                                               data-title="Call Centre Hours" data-cache="true">
                                        <span class="noWrap callCentreNumber">${callCentreNumber}</span>
                                        <span class="noWrap callCentreAppNumber">${callCentreAppNumber}</span>
                                    </a> or <health_v4:callback_link /> ${callCentreCBModal}
                                </div>

                                <div id="view_all_hours" class="hidden">${callCentreHoursModal}</div>
                            </li>


                        </ul>
                    </div>
                </c:if>
            </jsp:attribute>

            <jsp:attribute name="progress_bar">
                <div class="progress-bar-row navbar-affix">
                    <div class="container">
                        <div class="row">
                            <div class="col-xs-12 col-sm-9">
                                <ul class="journeyProgressBar"></ul>
                            </div>
                            <div class="hidden-xs col-sm-3">
                                <a class="btn btn-next btn-block nav-next-btn show-loading journeyNavButton slide-control-about-you" data-slide-control="next" href="javascript:;"
                                        <field_v1:analytics_attr analVal="nav link" quoteChar="\"" />>Insurance preferences <span class="icon icon-arrow-right"></span></a>
                                <a class="btn btn-next btn-block nav-next-btn show-loading journeyNavButton slide-control-insurance-preferences" data-slide-control="next"
                                   href="javascript:;"  <field_v1:analytics_attr analVal="nav link" quoteChar="\"" />>Contact details <span class="icon icon-arrow-right"></span></a>
                                <a class="btn btn-next btn-block nav-next-btn show-loading journeyNavButton slide-control-get-prices" data-slide-control="next"
                                   href="javascript:;"  <field_v1:analytics_attr analVal="nav link" quoteChar="\"" />>Get prices <span class="icon icon-arrow-right"></span></a>
                            </div>
                        </div>
                    </div>
                </div>
            </jsp:attribute>

            <jsp:attribute name="body_end">
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


                <%-- generate the benefit fields (hidden) for form selection. --%>
                <div class="hiddenFields">
                    <health_v4:hidden_fields />
                </div>

                <%-- Slides --%>
                <health_v4_layout:slide_about_you />
                <health_v4_layout:slide_insurance_preferences />
                <health_v4_layout:slide_contact />
                <health_v4_layout:slide_results />
                <health_v4_layout:slide_application />
                <health_v4_layout:slide_payment />

                <field_v1:hidden xpath="environmentOverride" />
                <field_v1:hidden xpath="staticOverride" />
                <field_v1:hidden xpath="environmentValidatorOverride" />
                <input type="hidden" name="transcheck" id="transcheck" value="1" />
                <agg_v3:save_quote />
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