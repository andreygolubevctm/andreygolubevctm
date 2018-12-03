<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="results-sidebar-inner results-legend grey-border">
    <div class="results-page-sidebar-header smaller-text hidden-mobile">Legend</div>
    <div class="results-legend-row smaller-text dark-grey-text">
        <span class="icon icon-tick"></span> Covered
    </div>

    <div class="results-legend-row smaller-text dark-grey-text">
        <span class="icon icon-cross"></span> Not covered
    </div>

    <div class="results-legend-row smaller-text dark-grey-text">
        <span class="icon icon-restricted"></span> Restricted Benefits
    </div>
    <div class="results-legend-restricted-help smaller-text dark-grey-text"><content:get key="ResultsPageLegendRestricted" /></div>
</div>