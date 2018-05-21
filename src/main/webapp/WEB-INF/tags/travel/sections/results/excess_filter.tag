<%@ tag description="" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="col-xs-12 col-md-12 text-left selected-excess-value drop-down-filter">
    <div class="dropdown">
        <a type="button" id="excessFilterDropdownBtn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <span class="filter-excess-value">Excess up to $200</span>
            <i class="icon icon-angle-down"></i>
        </a>
        <div class="dropdown-menu dropdown-menu-excess-filter" aria-labelledby="excessFilterDropdownBtn">
            <travel_results_filters:excess />
        </div>
    </div>
</div>