<%@ tag description="The Health Results" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="healthPriceDetailService" class="com.ctm.web.health.services.HealthPriceDetailService" scope="page" />
<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />

<layout_v1:results_template xsResultsColumns="2" resultsContainerClassName=" affixOnScroll sessioncamignorechanges ">

    <jsp:attribute name="preResultsRow">
        <health_v3:pre_results_row_content_template />
        <div class="col-xs-12 results-prologue-row">
            <div class="preResultsContainer hidden-xs"></div>
        </div>
        <div class="hidden-xs col-sm-5 col-sm-offset-7 col-lg-4 col-lg-offset-8 results-prologue-row results-pagination wider">
            <div class="collapse navbar-collapse">
                <span class="pagination-text-label">See more results</span>
                <ul class="nav navbar-nav navbar-right slide-feature-pagination" data-results-pagination-pages-cell="true"></ul>
            </div>
        </div>
        <div class="clearfix"></div>
    </jsp:attribute>

    <jsp:attribute name="sidebarColumnLeft">
        <c:if test="${empty callCentre}">
            <form_v3:save_results_button />
        </c:if>
        <coupon:promo_tile />
        <div class="col-sm-12 sidebar-widget sidebar-widget-contained sidebar-widget-padded results-filters">
        </div>
        <div class="col-xs-12 sidebar-widget sidebar-widget-attached sidebar-widget-padded filters-update-container" style="display: none">
            <!-- update button placeholder-->
        </div>
        <div class="col-xs-12 sidebar-widget sidebar-widget-contained sidebar-widget-padded results-filters-benefits">
        </div>
        <div class="col-xs-12 sidebar-widget sidebar-widget-attached sidebar-widget-padded filters-update-container" style="display: none">
            <!-- update button placeholder-->
        </div>
        <health_v3:filters_benefits />
        <health_v3:filters_template />
        <health_v3:filters_update_widget_template />
    </jsp:attribute>

    <jsp:attribute name="resultsErrorMessage">
            Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);" data-slide-control="start" title='Revise your details'>try again later.</a>
    </jsp:attribute>
    <jsp:attribute name="zeroResultsFoundMessage">
            No results match your filters. Please try resetting your results by <a href="javascript;" class="reset-filters">clicking here</a>.
    </jsp:attribute>

    <jsp:attribute name="quoterefTemplate">
        <health_v3:quoteref_template />
    </jsp:attribute>

    <jsp:attribute name="additionalPagination">
        <agg_v1:results_pagination_floated_arrows />
    </jsp:attribute>

    <jsp:attribute name="logoTemplate">
        <health_v3:logo_template />
    </jsp:attribute>

    <jsp:attribute name="productTitleTemplate">
        <health_v3:product_title_template/>
    </jsp:attribute>

    <jsp:attribute name="priceTemplate">
        <health_v3:price_template />
    </jsp:attribute>

    <jsp:attribute name="resultsHeaderTemplate">
            <health_v3:product_header_template />
    </jsp:attribute>

    <jsp:attribute name="resultsContainerTemplate">
        {{ var headerTemplate = meerkat.modules.templateCache.getTemplate($('#result-header-template')); }}
        {{ var coverType = meerkat.modules.health.getCoverType(); headerHtml = headerTemplate(obj); }}
        <div class="result-row result_{{= productId }}" data-productId="{{= productId }}">
            {{= headerHtml }}
            <div class="featuresList featuresElements">{{ if(coverType == 'H' || coverType == 'C') { }}
                <div class="hospitalCoverSection">
                    <h3><span class="health-icon HLTicon-hospital"></span> Hospital Cover</h3>
                    <div class="hospitalSelectionsExcessContainer">
                        <div class="hospitalExcessSectionBorder">
                            <h5>Hospital excess</h5>
                            <div class="featuresListExcess" data-feature-template="#results-features-excess-template" data-feature-index="1"></div>
                            <div class="yourSelectionsHospital">
                                <h5>Your selected benefits</h5>
                            </div>
                        </div>
                        {{ if(info.situationFilter == 'Y') { }}
                        <div class="featuresListHospitalSelections"><health_v3:limited_cover_label /></div>
                        {{ } else { }}
                        <div class="featuresListHospitalSelections" data-feature-index="2"></div>
                        {{ } }}
                    </div>
                    <h5>Other hospital benefits</h5>
                    <div class="featuresListHospitalOther" data-feature-index="4"></div>
                </div>
                {{ } if(coverType == 'E' || coverType == 'C') { }}
                <div class="extrasCoverSection">
                    <h3 class="noStyles"><span class="health-icon HLTicon-extras"></span> Extras Cover</h3>
                    <div class="featuresListExtrasSelections" data-feature-index="3"></div>
                    <h5>Other extras services</h5>
                    <div class="featuresListExtrasOtherList" data-feature-template="#results-features-extras-template" data-feature-index="5"></div>
                    <div class="featuresListExtrasFullList" data-feature-index="5"></div>
                </div>
                {{ } }}
                <div class="ambulanceCoverSection">
                    <h3><span class="health-icon HLTicon-ambulance"></span> Ambulance Cover</h3>
                    <div class="featuresListAmbulance" data-feature-index="6"></div>
                </div>
            </div>
        </div>
    </jsp:attribute>

    <jsp:attribute name="hiddenInputs">
        <%-- Hidden fields necessary for Results page --%>
        <input type="hidden" name="health_applyDiscounts" value="Y" />
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
                    <input type="hidden" name="health_retrieve_transactionId" value="${data['current/previousTransactionId']}" />
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
        <c:set var="jsonString" value="${resultsDisplayService.getResultItemsAsJsonString('health', 'category')}" scope="request" />
        <script>
            var resultLabels = ${jsonString};
        </script>

        <%-- FEATURE TEMPLATE --%>
        <div id="restrictedFundText" class="hidden">
            <p>Restricted funds provide private health insurance cover to members of a specific industry or group.</p>
            <p>In some cases, family members and extended family are also eligible.</p>
        </div>

        <%-- FEATURE TEMPLATE --%>
        <health_v3:resultsItemTemplate />
        <health_v3:brochure_template />
        <health_v3:excess_template />
        <health_v3:extras_list_template />
        <health_v3:credit_card_template />
        <health_v1:logo_price_template />

    </jsp:body>


</layout_v1:results_template>