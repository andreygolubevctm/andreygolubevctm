<%@ tag description="Simples Confirm all data is correct - confirm your details"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="payment-confirm-details-your-details-section payment-confirm-details-section">
    <health_v2_confirmation:edit_details_btn />

    {{ obj.primary.forEach(function(field) { }}
        <form_v2:row label="{{= field.label }}">
            {{= field.value }}
        </form_v2:row>
    {{ }); }}

    <span class="payment-confirm-warning-text">Check start date of policy still falls within fund promo dates</span>

    <hr />

    {{ if (obj.showRebateData === 'Y') { }}
        <form_v2:row label="{{= obj.rebate.label }}" className="rebate-tier">
            {{= obj.rebate.value }}
        </form_v2:row>
        <hr />
    {{ } }}

</div>