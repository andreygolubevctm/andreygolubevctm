<%@ tag description="Layout for a results page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%--
    This is a core template for results to use along with results_v4 LESS.
    It can be customised with the number of columns etc, a sidebar, compare mode, error messages etc.
--%>
<%-- Attributes --%>
<%@ attribute required="false" name="resultsContainerClassName" description="Optional class names for the resultsContainer" %>
<%@ attribute required="false" name="xsResultsColumns" %>
<%@ attribute required="false" name="smResultsColumns" %>
<%@ attribute required="false" name="mdResultsColumns" %>
<%@ attribute required="false" name="lgResultsColumns" %>
<c:if test="${empty xsResultsColumns}">
    <c:set var="xsResultsColumns" value="1"/>
</c:if>
<c:if test="${empty smResultsColumns}">
    <c:set var="smResultsColumns" value="3"/>
</c:if>
<c:if test="${empty mdResultsColumns}">
    <c:set var="mdResultsColumns" value="3"/>
</c:if>
<c:if test="${empty lgResultsColumns}">
    <c:set var="lgResultsColumns" value="3"/>
</c:if>

<%-- Fragments --%>
<%@ attribute fragment="true" required="false" name="preResultsRow" %>
<%@ attribute fragment="true" required="false" name="sidebarColumnLeft" %>
<%@ attribute fragment="true" required="false" name="sidebarColumnRight" %>
<%@ attribute fragment="true" required="false" name="zeroResultsFoundMessage" %>
<%@ attribute fragment="true" required="false" name="additionalPagination" %>
<%@ attribute fragment="true" required="false" name="resultsErrorMessage" %>
<%@ attribute fragment="true" required="false" name="hiddenInputs" description="Any hidden " %>
<%@ attribute fragment="true" required="false" name="quoterefTemplate" description="A template customisable to display the quote reference number" %>
<%@ attribute fragment="true" required="true" name="logoTemplate"
              description="A template just for the logo. Logos tend to be displayed in different places independent of price, so should be a different template." %>
<%@ attribute fragment="true" required="false" name="productTitleTemplate" description="A template customisable to display the product title" %>
<%@ attribute fragment="true" required="true" name="priceTemplate" description="A template customisable to display price based on frequency etc, must exclude logo" %>
<%@ attribute fragment="true" required="false" name="compareTemplate" description="A template for compare mode" %>
<%@ attribute fragment="true" required="true" name="resultsContainerTemplate" description="A template from the result-row wrapper" %>
<%@ attribute fragment="true" required="true" name="resultsHeaderTemplate" description="A template from the result header section" %>

<%-- So we can test --%>
<c:set var="preResultsRow">
    <jsp:invoke fragment="preResultsRow"/>
</c:set>
<c:set var="sidebarColumnLeft">
    <jsp:invoke fragment="sidebarColumnLeft"/>
</c:set>
<c:set var="sidebarColumnRight">
    <ad_containers:sidebar_top />
    <jsp:invoke fragment="sidebarColumnRight"/>
    <ad_containers:sidebar_bottom />
</c:set>
<c:set var="resultsErrorMessage">
    <jsp:invoke fragment="resultsErrorMessage"/>
</c:set>
<c:set var="zeroResultsFoundMessage">
    <jsp:invoke fragment="zeroResultsFoundMessage"/>
</c:set>
<c:set var="quoterefTemplate">
    <jsp:invoke fragment="quoterefTemplate"/>
</c:set>
<c:set var="resultsColsSm" value="8"/>
<c:set var="resultsColsMd" value="9" />
<c:if test="${empty sidebarColumnLeft and empty sidebarColumnRight}">
    <c:set var="resultsColsSm" value="12"/>
    <c:set var="resultsColsMd" value="12" />
</c:if>

<div class="row" id="resultsPage">

    <c:if test="${not empty preResultsRow}">
        ${preResultsRow}
    </c:if>

    <%-- Currently applied on Health V2 --%>
    <c:if test="${not empty sidebarColumnLeft}">
        <div class="hidden-xs col-sm-4 col-md-3" id="results-sidebar">
                ${sidebarColumnLeft}
        </div>
    </c:if>

    <div class="col-md-${resultsColsMd} results-column-container">
        <div class="${resultsContainerClassName} resultsContainer featuresMode results-columns-xs-${xsResultsColumns} results-columns-sm-${smResultsColumns} results-columns-md-${mdResultsColumns} results-columns-lg-${lgResultsColumns}">
            <jsp:invoke fragment="additionalPagination"/>
            <div class="resultsOverflow notScrolling">

                <div class="results-table"></div>

                <div class="resultsFetchError displayNone">
                    <c:choose>
                        <c:when test="${not empty resultsErrorMessage}">
                            ${resultsErrorMessage}
                        </c:when>
                        <c:otherwise>
                            Oops, something seems to have gone wrong. Sorry about that! Please <a href="javascript:void(0);" data-slide-control="start" title='Revise your details'>try again later.</a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="noResults displayNone alert alert-warning">
                    <c:choose>
                        <c:when test="${not empty zeroResultsFoundMessage}">
                            ${zeroResultsFoundMessage}
                        </c:when>
                        <c:otherwise>
                            No results found, please alter your filters and selections to find a match.
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </div>
    </div>
    <%-- Currently applied on Health V4 --%>
    <c:if test="${not empty sidebarColumnRight}">
        <div class="col-md-3" id="results-sidebar">
                ${sidebarColumnRight}
        </div>
    </c:if>

    <div class="clearfix"></div>

    <jsp:doBody/>

    <jsp:invoke fragment="hiddenInputs"/>

</div>
<%-- Temp div to hold the snapshot and complance text until new desgin can figure our where to put this --%>
<div id="temp-health-snapshot" class="visible-xs"><p>Please download the policy brochures for the full policy limits, inclusions and exclusions.</p></div>
<%-- Dump out the templates --%>
<c:if test="${not empty quoterefTemplate}"><core_v1:js_template id="quoteref-template"><jsp:invoke fragment="quoterefTemplate"/></core_v1:js_template></c:if>
<core_v1:js_template id="logo-template"><jsp:invoke fragment="logoTemplate"/></core_v1:js_template>
<core_v1:js_template id="product-title-template"><jsp:invoke fragment="productTitleTemplate"/></core_v1:js_template>
<core_v1:js_template id="price-template"><jsp:invoke fragment="priceTemplate"/></core_v1:js_template>
<core_v1:js_template id="result-template"><jsp:invoke fragment="resultsContainerTemplate"/></core_v1:js_template>
<core_v1:js_template id="result-header-template"><jsp:invoke fragment="resultsHeaderTemplate"/></core_v1:js_template>
<jsp:invoke fragment="compareTemplate"/>