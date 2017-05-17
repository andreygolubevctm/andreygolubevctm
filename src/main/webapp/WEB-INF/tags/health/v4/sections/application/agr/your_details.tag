<%@ tag description="Australian Government Rebate confirm your details"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="agr-your-details-section agr-details-section">
    <h3>Please confirm your details</h3>
    <health_v4_agr:edit_details_btn />

    {{ obj.primary.forEach(function(field) { }}
        <form_v4:row label="{{= field.label }}">
            {{= field.value }}
        </form_v4:row>
    {{ }); }}

    <hr />

    <form_v4:row label="{{= obj.rebate.label }}" className="rebate-tier">
        {{= obj.rebate.value }}
        <a href="javascript:;" class="view-rebate-table-btn">View rebate table <span class="icon icon-angle-down"></span></a>
    </form_v4:row>

    <hr />

    {{ obj.medicareDetails.forEach(function(field) { }}
        <form_v4:row label="{{= field.label }}">
            {{= field.value }}
        </form_v4:row>
    {{ }); }}

    <hr />

    {{ if (obj.previousFund) { }}
        {{ obj.previousFund.forEach(function(field) { }}
            <form_v4:row label="{{= field.label }}">
                {{= field.value }}
            </form_v4:row>
        {{ }); }}

        <hr />
    {{ } }}
</div>