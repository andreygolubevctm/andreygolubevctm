<%@ tag description="" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="dropdown">
    <a type="button" id="moreFiltersDropdownBtn" class="more-filters-dropdown-btn"
       data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        Filters<i class="icon icon-angle-down"></i>
    </a>
    <div class="dropdown-menu dropdown-menu-more-filters" aria-labelledby="moreFiltersDropdownBtn">
        <div class="row hidden-xs">
            <div class="col-sm-12 text-left more-filters-header">Customise Results</div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-2 text-left filter-section">
                <div class="dropdown-item range-filter">
                    <b>Reset filters</b>
                    <field_v2:help_icon helpId="583" tooltipClassName=""/>
                </div>
                <div class="reset-travel-filters"></div>
            </div>
            <div class="col-xs-12 col-sm-3 text-left filter-section">
                <div class="dropdown-item range-filter">
                    <b>Minimum luggage cover</b>
                    <field_v2:help_icon helpId="580" tooltipClassName=""/>
                </div>
                <travel_results_filters:minimum_luggage/>
                <div class="dropdown-item range-filter">
                    <b>Minimum cancellation cover</b>
                    <field_v2:help_icon helpId="581" tooltipClassName=""/>
                </div>
                <travel_results_filters:minimum_cancellation/>
                <div class="dropdown-item range-filter">
                    <b>Minimum overseas medical cover</b>
                    <field_v2:help_icon helpId="582" tooltipClassName=""/>
                </div>
                <travel_results_filters:minimum_overseas_medical/>
            </div>
            <div class="col-xs-12 col-sm-7 text-left filter-section">
                <div class="hidden-xs">
                    <div class="row">
                        <div class="col-sm-12 no-padding">
                            <span><b>Brands</b></span>
                            <span class="brands-select-toggle" data-brands-toggle="none">Select none</span>
                        </div>
                    </div>
                    <div class="filter-brands-container">
                        <travel_results_filters:brands />
                    </div>
                </div>
                <div class="visible-xs hidden-sm">
                    <div class="row">
                        <div class="col-xs-6">
                            <span class="filter-brands-toggle">
                                <b>Filter brands</b> <i class="icon-brand icon-angle-down"></i>
                            </span>
                        </div>
                        <div class="col-xs-6 text-right">
                            <span class="brands-select-toggle" data-brands-toggle="none">Select none</span>
                        </div>
                    </div>
                    <div class="filter-brands-container hide">
                        <travel_results_filters:brands />
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-9">&nbsp;</div>
            <div class="col-sm-2 text-center more-filters-results-btn">See Results</div>
        </div>
    </div>
</div>