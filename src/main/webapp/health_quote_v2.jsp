<%--
	Health quote page
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<health:redirect_rules />

<session:new verticalCode="HEALTH" authenticated="true" />

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

<core_new:quote_check quoteType="health" />
<core_new:load_preload />

<%-- Get data to build sections/categories/features on benefits and result pages. Used in results and benefits tags --%>
<jsp:useBean id="resultsDisplayService" class="com.ctm.web.core.results.services.ResultsDisplayService" scope="request" />
<jsp:useBean id="callCenterHours" class="com.ctm.web.core.web.openinghours.go.CallCenterHours" scope="page" />
<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" scope="request" />

<c:set var="resultTemplateItems" value="${resultsDisplayService.getResultsPageStructure('health')}" scope="request"  />

<%--TODO: turn this on and off either in a settings file or in the database --%>
<c:set var="showReducedHoursMessage" value="false" />

<%-- Call centre numbers --%>
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>
<c:set var="callCentreHelpNumber" scope="request"><content:get key="callCentreHelpNumber"/></c:set>

<c:set var="openingHoursHeader" scope="request" ><content:getOpeningHours/></c:set>
<c:set var="callCentreHoursModal" scope="request"><content:getOpeningHoursModal /></c:set>

<c:set var="isHealthV2" value="${true}" scope="request" />

<%-- HTML --%>
<layout_new_layout:journey_engine_page title="Health Quote">

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
                  <h1><a class="needsclick callCentreNumberClick" href="tel:${callCentreNumber}">Call <span class="noWrap callCentreNumber">${callCentreNumber}</span></a></h1>
                    ${openingHoursHeader }
                </div>
                <div class="navbar-text hidden-xs" data-livechat="target">
                  <h4>Call us on</h4>
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

    <jsp:attribute name="navbar_save_quote">
        <agg_new:save_quote includeCallMeback="true" />
    </jsp:attribute>
    <jsp:attribute name="navbar_additional_options">
        <li class="dropdown dropdown-interactive slide-feature-filters" id="filters-dropdown">
            <a class="activator btn-dropdown dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"><span class="icon icon-filter"></span> <span>Filter</span><span class="hidden-sm"> Results</span> <b class="caret"></b></a>
            <div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
                <health:filters />
            </div>
        </li>
        <li class="dropdown dropdown-interactive slide-feature-benefits" id="benefits-dropdown">
            <a class="activator btn-dropdown dropdown-toggle" data-toggle="dropdown" href="javascript:void(0);"><span class="icon icon-cog"></span> <span>Customise</span><span class="hidden-sm"> Cover</span> <b class="caret"></b></a>
            <div class="dropdown-menu dropdown-menu-large" role="menu" aria-labelledby="dLabel">
                <health:benefits />
            </div>
        </li>
        <li class="navbar-text-block">
            <form_new:reference_number />
        </li>
        <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav navbar-right slide-feature-pagination" data-results-pagination-pages-cell="true"></ul>
        </div>
    </jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>
							
	<jsp:attribute name="footer">
		<health:footer />
	</jsp:attribute>
							
	<jsp:attribute name="vertical_settings">
		<health:settings />
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
    <health:product_title_search />
    <core:application_date />

    <%-- Product summary header for mobile --%>
    <div class="row productSummary-parent visible-xs">
      <div class="productSummary-affix affix-top visible-xs">
        <health:policySummary />
      </div>
    </div>

    <health:choices xpathBenefits="${pageSettings.getVerticalCode()}/benefits" xpathSituation="${pageSettings.getVerticalCode()}/situation" />

    <%-- generate the benefit fields (hidden) for form selection. --%>
    <div class="hiddenFields">
      <c:forEach items="${resultTemplateItems}" var="selectedValue">
        <health_new:benefitsHiddenItem item="${selectedValue}" />
      </c:forEach>

      <field:hidden xpath="health/renderingMode" />
      <field:hidden xpath="health/rebate" />
      <field:hidden xpath="health/rebateChangeover" />
      <field:hidden xpath="health/loading" />
      <field:hidden xpath="health/primaryCAE" />
      <field:hidden xpath="health/partnerCAE" />

      <form:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid" />
      <core:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
      <core_new:authToken authToken="${param['authToken']}"/>
    </div>

    <%-- Slides --%>
    <health_new_layout:slide_all_about_you />
    <health_new_layout:slide_benefits />
    <health_new_layout:slide_your_contact />
    <health_layout:slide_results />
    <health_new_layout:slide_application_details />
    <health_new_layout:slide_payment_details />

    <health_new:health_cover_details xpath="${pageSettings.getVerticalCode()}/healthCover" />

    <field:hidden xpath="environmentOverride" />
    <input type="hidden" name="transcheck" id="transcheck" value="1" />
  </jsp:body>
</layout_new_layout:journey_engine_page>

<%-- START JOURNEY OVERRIDE - Part 2 of 2) --%>
  </c:otherwise>
</c:choose>
<%-- END JOURNEY OVERRIDE - Part 2 of 2) --%>
