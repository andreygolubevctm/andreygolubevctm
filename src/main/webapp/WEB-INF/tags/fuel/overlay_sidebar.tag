<%@ tag description="Fuel Sidebar" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="xpath" value="${pageSettings.getVerticalCode()}"/>

<div class="row">
    <div class="hidden-xs col-sm-4 col-md-3 col-lg-2" id="results-sidebar">
        <div class="row">
            <div class="col-sm-12 sidebar-widget sidebar-widget-contained sidebar-widget-padded sidebar-widget-dropshadow">
                <field_v2:lookup_suburb_postcode xpath="${xpath}/location" placeholder="Postcode / Suburb" required="true"
                                                 extraDataAttributes=" data-rule-validateLocation='true' data-msg-validateLocation='Please select a valid postcode to compare fuel'"/>
                <field_v2:array_select xpath="${xpath}/type" required="true" title="Fuel type" items="=Please choose...,2=Unleaded,3=Diesel,4=LPG,5=Premium Unleaded 95,7=Premium Unleaded 98,6=E10,8=Bio-Diesel 20,9=Premium Diesel"/>
            </div>

            <div class="col-sm-12 sidebar-widget sidebar-widget-contained sidebar-widget-padded sidebar-widget-dropshadow">
                <p>Price bands based on <strong id="fuel-map-location">Brisbane</strong> prices</p>
                <div class="fuel-band">
                    <span class="circle"><span class="icon icon-vert-fuel"></span> </span>
                    <span class="fuel-price">< 124.0</span>
                </div>
                <div class="fuel-band fuel-band-1">
                    <span class="circle"><span class="icon icon-vert-fuel"></span> </span>
                    <span class="fuel-price">< 124.0</span>
                </div>
                <div class="fuel-band fuel-band-2">
                    <span class="circle"><span class="icon icon-vert-fuel"></span> </span>
                    <span class="fuel-price">< 124.0</span>
                </div>
                <div class="fuel-band fuel-band-3">
                    <span class="circle"><span class="icon icon-vert-fuel"></span> </span>
                    <span class="fuel-price">< 124.0</span>
                </div>
                <div class="fuel-band fuel-band-4">
                    <span class="circle"><span class="icon icon-vert-fuel"></span> </span>
                    <span class="fuel-price">< 124.0</span>
                </div>
                <div class="fuel-band fuel-band-5">
                    <span class="circle"><span class="icon icon-vert-fuel"></span> </span>
                    <span class="fuel-price">< 124.0</span>
                </div>
                <div class="fuel-band fuel-band-unavailable">
                    <span class="circle"><span class="icon icon-vert-fuel"></span> </span>
                    <span class="fuel-price">price unavailable</span>
                </div>
            </div>

            <div class="col-sm-12 sidebar-widget sidebar-widget-contained cross-sell-widget">
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