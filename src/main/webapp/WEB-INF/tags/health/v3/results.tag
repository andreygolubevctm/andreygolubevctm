<%@ tag description="The Health Results" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page"/>
<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page"/>

<%-- Setup variables needed for dual pricing --%>
<c:set var="healthAlternatePricingActive" value="${healthPriceDetailService.isAlternatePriceActive(pageContext.getRequest())}"/>
<c:if test="${healthAlternatePricingActive eq true}">
    <c:set var="healthAlternatePricingMonth" value="${healthPriceDetailService.getAlternatePriceMonth(pageContext.getRequest())}"/>
</c:if>


<layout_v1:results_template xsResultsColumns="2" resultsContainerClassName=" affixOnScroll sessioncamignorechanges ">

    <jsp:attribute name="preResultsRow"><health_v3:pre_results_row_content_template/></jsp:attribute>

    <jsp:attribute name="sidebarColumn">

        <%-- FILTERS Module will be for standard filters, health filters etc.
        Style is: Boxed border, standard row gutter
        Uses semibold h3 and h4 for titles
        Buttons all caps 12px or 13px?
        --%>
        <div class="col-xs-12 sidebar-widget sidebar-widget-contained sidebar-widget-padded results-filters">

            <div class="title">Filter results</div>
            <div class="row filter">
                <div class="col-xs-12">
                    <div class="sub-title">Payment frequency</div>
                    <div id="filter-frequency" data-filter-type="radio">
                        <field_v2:array_radio xpath="health/show-price" title="Repayments" items="F=Fortnightly,M=Monthly,A=Annually" required="false"/>
                    </div>
                </div>
            </div>

            <div class="row filter">
                <div class="col-xs-12">
                    <div class="sub-title">Excess</div>
                    <div id="filter-excess" data-filter-type="slider" data-filter-serverside="true">
                        <health_v1:filter_excess/>
                    </div>
                </div>
            </div>

        </div>

        <div class="col-xs-12 sidebar-widget sidebar-widget-contained sidebar-widget-padded results-filters">

        </div>

        <div class="col-xs-12 sidebar-widget sidebar-widget-uncontained">

        </div>

        <div class="col-xs-12 sidebar-widget sidebar-widget-uncontained sidebar-widget-padded">
            testimonial thing
        </div>

    </jsp:attribute>

    <jsp:attribute name="resultsErrorMessage">
            Custom message resultsErrorMessage
    </jsp:attribute>
    <jsp:attribute name="zeroResultsFoundMessage">
            Custom message zeroResultsFoundMessage
    </jsp:attribute>

    <jsp:attribute name="logoTemplate">
        <health_v3:logo_template/>
    </jsp:attribute>

    <jsp:attribute name="priceTemplate">
        <health_v3:price_template/>
    </jsp:attribute>

    <jsp:attribute name="resultsHeaderTemplate">
            <health_v3:product_header_template/>
    </jsp:attribute>

    <jsp:attribute name="resultsContainerTemplate">
        {{ var headerTemplate = meerkat.modules.templateCache.getTemplate($('#result-header-template')); }}
        {{ headerHtml = headerTemplate(obj); }}
        <div class="result-row result_{{= productId }}" data-productId="{{= productId }}">
            {{= headerHtml }}
            <div class="featuresList featuresElements">
            </div>
        </div>
    </jsp:attribute>

    <jsp:attribute name="hiddenInputs">
        <%-- Hidden fields necessary for Results page --%>
        <input type="hidden" name="health_showAll" value="Y"/>
        <input type="hidden" name="health_onResultsPage" value="Y"/>
        <input type="hidden" name="health_incrementTransactionId" value="Y"/>

        <c:if test="${!callCentre && data['health/journey/stage'] == 'results'}">
            <c:choose>
                <c:when test="${param.action == 'load' && not empty param.productId && not empty param.productTitle}">
                    <input type="hidden" name="health_directApplication" value="Y"/>
                </c:when>
                <c:when test="${param.action == 'load' || param.action == 'amend'}">
                    <input type="hidden" name="health_retrieve_savedResults" value="Y"/>
                    <input type="hidden" name="health_retrieve_transactionId" value="${data['current/previousTransactionId']}"/>
                </c:when>
            </c:choose>
        </c:if>

        <%-- The following are hidden fields set by filters --%>
        <field_v1:hidden xpath="health/excess" defaultValue="4"/>
        <field_v1:hidden xpath="health/filter/providerExclude"/>
        <field_v1:hidden xpath="health/filter/priceMin" defaultValue="0"/>
        <field_v1:hidden xpath="health/filter/frequency" defaultValue="M"/>
        <field_v1:hidden xpath="health/fundData/hospitalPDF" defaultValue=""/>
        <field_v1:hidden xpath="health/fundData/extrasPDF" defaultValue=""/>
        <field_v1:hidden xpath="health/fundData/providerPhoneNumber" defaultValue=""/>
        <c:if test="${callCentre}">
            <field_v1:hidden xpath="health/filter/tierHospital"/>
            <field_v1:hidden xpath="health/filter/tierExtras"/>
        </c:if>
    </jsp:attribute>

    <jsp:body>
        <div class="col-xs-12 moreInfoDropdown"></div>
        <jsp:useBean id="resultsDisplayService" class="com.ctm.web.core.results.services.ResultsDisplayService" scope="request"/>
        <c:set var="jsonString" value="${resultsDisplayService.getResultItemsAsJsonString('health', 'category')}" scope="request"/>
        <script>
            var resultLabels = ${jsonString};
        </script>

        <%-- FEATURE TEMPLATE --%>
        <div id="restrictedFundText" class="hidden">
            <p>Restricted funds provide private health insurance cover to members of a specific industry or group.</p>
            <p>In some cases, family members and extended family are also eligible.</p>
        </div>

        <%-- FEATURE TEMPLATE --%>
        <features:resultsItemTemplate/>
        <health_v3:brochure_template/>

    </jsp:body>


</layout_v1:results_template>