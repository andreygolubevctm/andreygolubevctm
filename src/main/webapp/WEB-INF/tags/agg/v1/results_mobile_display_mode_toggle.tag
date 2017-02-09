<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="nav button" quoteChar="\"" /></c:set>

<div class="results-mobile-display-mode-toggle hidden hidden-sm" data-display-mode="price">
    <div class="results-mobile-display-mode-text">
        We've found <span class="results-mobile-display-mode-count">xxx</span> products matching your needs
    </div>
    <div class="results-mobile-display-mode-button">
        <span class="results-mobile-display-mode-feature" ${analyticsAttr}>Switch to Feature Comparison View</span>
        <span class="results-mobile-display-mode-price" ${analyticsAttr}>Switch to Price Comparison View</span>
    </div>
</div>