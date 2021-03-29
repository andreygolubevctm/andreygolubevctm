<%@ tag description="Australian Government Rebate confirm your details"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="agr-your-details-section agr-details-section">
    <h3>Please confirm your details</h3>
    <health_v4_agr:edit_details_btn />

    {{ obj.primary.forEach(function(field) { }}
        <form_v4:row label="{{= field.label }}">
            <span className="data-hj-suppress">{{= field.value }}</span>
        </form_v4:row>
    {{ }); }}

    <hr />

    <form_v4:row label="{{= obj.rebate.label }}" className="rebate-tier">
        {{= obj.rebate.value }}
        <a href="javascript:;" class="view-rebate-table-btn">
            <span class="view-hide-text">View</span> rebate table <span class="icon icon-angle-down"></span>
        </a>
    </form_v4:row>
    <health_v4_agr:rebate_tier_table />
    <hr />

    {{ obj.medicareDetails.forEach(function(field) { }}
        {{ var subLabel = ''; }}
        {{ if (field.label === 'Full name') { }}
            {{ subLabel = '(as it appears on your medicare card)'; }}
        {{ } }}
        <form_v4:row label="{{= field.label }}" subLabel="{{= subLabel }}">
            <span className="data-hj-suppress">{{= field.value }}</span>
        </form_v4:row>
    {{ }); }}

    <hr />

    {{ obj.fund.forEach(function(field) { }}
        <form_v4:row label="{{= field.label }}">
            <span className="data-hj-suppress">{{= field.value }}</span>
        </form_v4:row>
    {{ }); }}

    <hr />
</div>