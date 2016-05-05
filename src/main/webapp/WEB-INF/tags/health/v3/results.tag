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


<layout_v1:results_template includeCompareTemplates="true" xsResultsColumns="2" resultsContainerClassName=" affixOnScroll sessioncamignorechanges ">

    <jsp:attribute name="preResultsRow">
        <h3>Hi Sergei,</h3> <%-- Delete this once template rendering --%>
        <p>We found 12 Combined Hospital and Extras products for your family</p>
        <core_v1:js_template id="preResultsRowContentTemplate">
            <h3>Hi Sergei,</h3> <%-- Helper functions to retrieve snapshot details? --%>
            <p>We found 12 Combined Hospital and Extras products for your family</p>
        </core_v1:js_template>
    </jsp:attribute>

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

    <jsp:attribute name="resultsHeaderTemplate">
        <div class="result">
            <div class="resultInsert">
                <div class="result-header-utility-bar">
                    {{ if( info.restrictedFund === 'Y' ) { }}
                    <div class="restrictedFund" data-title="This is a Restricted Fund" data-toggle="popover" data-adjust-y="5" data-trigger="mouseenter click" data-my="top center"
                         data-at="bottom center" data-content="#restrictedFundText" data-class="restrictedTooltips">Restricted Fund (?)
                    </div>
                    {{ } else { }}
                    <div class="utility-bar-blank">&nbsp;</div>
                    {{ } }}
                    <div class="filter-component remove-result hidden-xs">
                        <span class="icon icon-cross" title="Remove this product"></span>
                    </div>
                </div>
                <div class="results-header-inner-container">
                    <div class="productSummary vertical results">
                        {{ var logoTemplate = meerkat.modules.sharedResults.getTemplate($("#logo-template")); }}
                        {{ var priceTemplate = meerkat.modules.sharedResults.getTemplate($("#price-template")); }}
                        {{ obj._selectedFrequency = Results.getFrequency(); obj.showAltPremium = false; }}
                        {{= logoTemplate(obj) }}
                        {{= priceTemplate(obj) }}
                    </div>

                    <a class="btn btn-cta btn-block btn-more-info more-info-showapply" href="javascript:;" data-productId="{{= productId }}">
                        <div class="more-info-text">More Info</div>
                    </a>
                    {{ var brochureTemplate = meerkat.modules.sharedResults.getTemplate($("#brochure-download-template")); }}
                    {{= brochureTemplate(obj) }}

                    {{ var specialOffer = Features.getPageStructure()[0]; }}
                    {{ var pathValue = Object.byString( obj, specialOffer.resultPath ); }}
                    {{ var displayValue = Features.parseFeatureValue( pathValue, true ); }}

                    <fieldset class="hide-on-affix result-special-offer {{ if (!pathValue) { }}invisible{{ } }}">
                        <legend>Special Offer</legend>
                        {{= displayValue }}
                    </fieldset>
                </div>
            </div>
        </div>
    </jsp:attribute>

    <jsp:attribute name="resultsContainerTemplate">
        {{ var headerTemplate = meerkat.modules.sharedResults.getTemplate($('#result-header-template')); }}
        {{ headerHtml = headerTemplate(obj); }}
        <div class="result-row result_{{= productId }}" data-productId="{{= productId }}">
            {{= headerHtml }}
            <div class="featuresList featuresElements">

            </div>

        </div>
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