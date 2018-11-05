<%@ tag description="The Health Results" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />
<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />
<jsp:useBean id="touchService" class="com.ctm.web.core.services.AccessTouchService" scope="page" />

<layout_v1:results_template xsResultsColumns="2" resultsContainerClassName=" affixOnScroll sessioncamignorechanges ">

    <jsp:attribute name="preResultsRow">
        <health_v4_results:filters_frequency_template />
        <health_v4_results:filters_hidden_products_template />
    </jsp:attribute>

    <jsp:attribute name="sidebarColumnRight">
        <div class="hidden-xs hidden-sm results-sidebar-inner grey-border">
            <div class="results-page-sidebar-header smaller-text">Optional Filters</div>
            <div class="sidebar-widget sidebar-widget-padded results-filters-discount"></div>
            <div class="sidebar-widget sidebar-widget-padded results-filters-rebate"></div>
            <div class="sidebar-widget sidebar-widget-padded results-filters-awards-scheme"></div>
        </div>

        <div class="clearfix"></div>

        <div class="hidden-xs hidden-sm results-sidebar-inner grey-border">
            <div class="results-page-sidebar-header smaller-text">Filter my preferences</div>
            <div class="sidebar-widget sidebar-widget-padded results-filters-benefits"></div>
            <div class="sidebar-widget sidebar-widget-padded results-filters"></div>
        </div>

        <div class="clearfix"></div>

        <health_v4_results:results_legend />
        <health_v4_results:filters_discount />
        <health_v4_results:filters_rebate />
        <health_v4_results:filters_awards_scheme />
        <health_v4_results:filters_benefits />
        <health_v4_results:filters_template />
        <health_v4_results:filters_update_widget_template />

        <div class="hidden-xs hidden-sm">
            <coupon:promo_tile />
        </div>
    </jsp:attribute>

    <jsp:attribute name="resultsErrorMessage">
            Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);" data-slide-control="start" title='Revise your details'>try again later.</a>
    </jsp:attribute>
    <jsp:attribute name="zeroResultsFoundMessage">
            No results match your filters.
    </jsp:attribute>

    <jsp:attribute name="quoterefTemplate">
        <health_v4_results:quoteref_template />
    </jsp:attribute>

    <jsp:attribute name="logoTemplate">
        <health_v4_results:logo_template />
    </jsp:attribute>

    <jsp:attribute name="priceTemplate">
        <health_v4_results:price_template />
    </jsp:attribute>

    <jsp:attribute name="resultsHeaderTemplate">
        <health_v4_results:product_header_template />
    </jsp:attribute>

    <jsp:attribute name="resultsContainerTemplate">
        {{ var headerTemplate = meerkat.modules.templateCache.getTemplate($('#result-header-template')); }}
        {{ var specialFeaturesTemplate = meerkat.modules.templateCache.getTemplate($('#results-product-special-features-template')); }}
        {{ var coverType = meerkat.modules.healthChoices.getCoverType(); }}
        {{ var headerHtml = headerTemplate(obj); var specialFeaturesHtml = specialFeaturesTemplate(obj); }}
        <div class="result-row result_{{= productId }} not-pinned" data-productId="{{= productId }}">
            {{= headerHtml }}
            <div class="featuresList featuresElements">{{ if(coverType == 'H' || coverType == 'C') { }}
                {{= specialFeaturesHtml }}
                <div class="hospitalCoverSection">
                    <div class="clearfix">
                        <h2>Hospital</h2>
                        <c:if test="${not empty resultsBrochuresSplitTest and resultsBrochuresSplitTest eq true}">
                            <a class="results-download-brochure" href="${pageSettings.getBaseUrl()}{{= promo.hospitalPDF }}" target="_blank" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />><span class="icon icon-download"></span> View <span class="hidden-xs">hospital </span>brochure</a>
                        </c:if>
                    </div>
                    <div class="hospitalSelectionsExcessContainer">
                        <div class="hospitalExcessSectionBorder">
                            <div class="featuresListExcess" data-feature-template="#results-features-excess-template" data-feature-index="1" data-feature-type="excess"></div>
                        </div>
                        {{ if(info.situationFilter == 'Y') { }}
                        <div class="featuresListHospitalSelections"><health_v4_results:limited_cover_label /></div>
                        {{ } }}
                    </div>
                    <div class="benefits-click-text visible-xs">Click below for cover limits</div>
                    <div class="featuresListHospitalOtherList" data-feature-index="4" data-feature-type="hospital"></div>
                </div>
                {{ } if(coverType == 'E' || coverType == 'C') { }}
                <div class="extrasCoverSection">
                    <div class="clearfix">
                        <h2>Extras</h2>
                        <c:if test="${not empty resultsBrochuresSplitTest and resultsBrochuresSplitTest eq true}">
                            <a class="results-download-brochure" href="${pageSettings.getBaseUrl()}{{= promo.extrasPDF }}" target="_blank" <field_v1:analytics_attr analVal="dl brochure" quoteChar="\"" />><span class="icon icon-download"></span> View <span class="hidden-xs">extras </span>brochure</a>
                        </c:if>
                    </div>
                    <div class="benefits-click-text visible-xs">Click below for cover limits</div>
                    <div class="featuresListExtrasOtherList" data-feature-index="5" data-feature-type="extras"></div>
                </div>
                {{ } }}
                <div class="ambulanceCoverSection">
                    <h2>Ambulance</h2>
                    <div class="featuresListAmbulance" data-feature-index="6" data-feature-type="ambulance"></div>
                </div>
            </div>
        </div>
    </jsp:attribute>

    <jsp:attribute name="hiddenInputs">
        <%-- Hidden fields necessary for Results page --%>
        <input type="hidden" name="health_popularProducts" value="N" />
        <input type="hidden" name="health_popularProducts_purchased" value="0" />
        <input type="hidden" name="health_applyDiscounts" value="Y" />
        <input type="hidden" name="health_rewardsSchemeFirst" value="N" />
        <input type="hidden" name="health_showAll" value="Y" />
        <input type="hidden" name="health_onResultsPage" value="Y" />
        <input type="hidden" name="health_incrementTransactionId" value="Y" />

        <c:if test="${!callCentre && data['health/journey/stage'] == 'results'}">
            <c:choose>
                <c:when test="${param.action == 'load' && not empty param.productId && not empty param.productTitle}">
                    <input type="hidden" name="health_directApplication" value="Y" />
                </c:when>
                <c:when test="${param.action == 'load' || param.action == 'amend'}">
                    <input type="hidden" name="health_retrieve_savedResults" value="Y" />
                    <input type="hidden" name="health_retrieve_transactionId" value="<c:out value='${param.transactionId}' escapeXml="true" />" />
                </c:when>
                 <c:when test="${param.action == 'remember' && not empty param.transactionId}">
                     <c:set var="touchResponse">${touchService.recordTouch(data['current/transactionId'], "RememberMe", "ONLINE")}</c:set>
                     <input type="hidden" name="health_previous_transactionId" value="<c:out value='${param.transactionId}' escapeXml="true" />" />
                </c:when>
            </c:choose>
        </c:if>

        <%-- The following are hidden fields set by filters --%>
        <field_v1:hidden xpath="health/excess" defaultValue="4" />
        <field_v1:hidden xpath="health/filter/providerExclude" />
        <field_v1:hidden xpath="health/filter/priceMin" defaultValue="0" />
        <field_v1:hidden xpath="health/filter/frequency" defaultValue="M" />
        <field_v1:hidden xpath="health/fundData/hospitalPDF" defaultValue="" />
        <field_v1:hidden xpath="health/fundData/extrasPDF" defaultValue="" />
        <field_v1:hidden xpath="health/fundData/providerPhoneNumber" defaultValue="" />
        <c:if test="${callCentre}">
            <field_v1:hidden xpath="health/filter/tierHospital" />
            <field_v1:hidden xpath="health/filter/tierExtras" />
        </c:if>
    </jsp:attribute>

    <jsp:body>
        <div class="col-xs-12 moreInfoDropdown"></div>
        <jsp:useBean id="resultsDisplayService" class="com.ctm.web.core.results.services.ResultsDisplayService" scope="request" />
        <c:set var="jsonString" value="${resultsDisplayService.getResultItemsAsJsonString('health_v4', 'category')}" scope="request" />
        <script>
            var resultLabels = ${jsonString};
        </script>

        <%-- FEATURE TEMPLATE --%>
        <div id="restrictedFundText" class="hidden">
            <p>Restricted funds provide private health insurance cover to members of a specific industry or group.</p>
            <p>In some cases, family members and extended family are also eligible.</p>
        </div>

        <%-- FEATURE TEMPLATE --%>
        <health_v4_results:resultsItemTemplate />
        <health_v4_results:brochure_template />
        <health_v4_results:excess_template />
        <health_v4_results:product_special_features_template />
        <health_v4_results:extras_list_template />
        <health_v4_results:credit_card_template />
        <health_v4_refine_results:refine_results />
        <health_v4_results:popular_products />

    </jsp:body>


</layout_v1:results_template>