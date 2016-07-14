<%@ tag description="Fuel Sidebar" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}"/>

<div class="row">
    <div class="col-xs-12 col-sm-4 col-md-3 col-lg-2" id="results-sidebar">
        <div class="row">
            <div class="col-sm-12 sidebar-widget sidebar-widget-contained sidebar-widget-padded sidebar-widget-dropshadow">
                <div class="row fieldrow hidden-xs">
                    <field_v2:input xpath="${xpath}/location" title="search location" required="true" placeHolder="Postcode / Location"/>
                </div>
                <div class="row fieldrow">
                    <field_v2:array_select xpath="${xpath}/type/id" required="true" title="Fuel type" items="2=Unleaded,3=Diesel,4=LPG,5=Premium Unleaded 95,8=Premium Unleaded 98,12=e10,14=Premium Diesel,999=e10/Unleaded,1000=Diesel/Premium Diesel"/>
                </div>
            </div>

            <div id="price-band-container" class="price-bands col-sm-12 sidebar-widget sidebar-widget-contained sidebar-widget-padded sidebar-widget-dropshadow hidden-xs">
                <fuel:price_bands_template />
            </div>

            <div class="col-sm-12 sidebar-widget sidebar-widget-contained cross-sell-widget hidden-xs">
                <div class="text-center cross-sell-text">
                    <span class="icon icon-vert-car"></span>
                    <p>Are you looking for Comprehensive Car Insurance?</p>
                    <a href="/${pageSettings.getContextFolder()}car_quote.jsp" class="btn btn-block btn-secondary">Compare Now</a>
                </div>
            </div>
        </div>
        <div class="resultsContainer hidden"></div>
        <%-- Needed to work with Results.js --%>
    </div>
</div>
<field_v1:hidden xpath="fuel/map/northWest" />
<field_v1:hidden xpath="fuel/map/southEast" />
<field_v1:hidden xpath="fuel/canSave" defaultValue="1" />