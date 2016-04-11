<%@ tag description="The Health Results" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<layout_v3:results_v4 includeCompareTemplates="true">

    <jsp:attribute name="sidebarColumn">

        <%-- FILTERS Module will be for standard filters, health filters etc.
        Style is: Boxed border, standard row gutter
        Uses semibold h3 and h4 for titles
        Buttons all caps 12px or 13px?
        --%>
        <div class="col-xs-12 sidebar-filters">

            <h3>Filter your stuff</h3>
            <div class="row filter">
                <div class="col-xs-12">
                    <h4>Payment Frequency</h4>
                    <div id="filter-frequency" data-filter-type="radio">
                        <field_v2:array_radio xpath="health/show-price" title="Repayments" items="F=Fortnightly,M=Monthly,A=Annually" required="false"/>
                    </div>
                </div>
            </div>

            <div class="row filter">
                <div class="col-xs-12">
                    <h4>Excess</h4>
                    <div id="filter-excess" data-filter-type="slider" data-filter-serverside="true">
                        <health_v1:filter_excess/>
                    </div>
                </div>
            </div>

        </div>

        <div class="col-xs-12 sidebar-filters">

        </div>
    </jsp:attribute>


    <jsp:attribute name="resultsErrorMessage">
            Custom message resultsErrorMessage
    </jsp:attribute>
    <jsp:attribute name="zeroResultsFoundMessage">
            Custom message zeroResultsFoundMessage
    </jsp:attribute>

</layout_v3:results_v4>