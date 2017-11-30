<%@ tag description="" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="col-xs-12 col-md-5 text-right hidden-xs"><b>Excess</b></div>
<div class="col-xs-12 col-md-6 text-left selected-excess-value">
    <div class="dropdown">
        <a type="button" id="excessFilterDropdownBtn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <span class="filter-excess-value">up to $200</span>
            <i class="icon icon-angle-down"></i>
        </a>
        <div class="dropdown-menu dropdown-menu-excess-filter" aria-labelledby="excessFilterDropdownBtn">
            <travel_results_filters:excess />
        </div>
    </div>
</div>