<%@ tag description="Simples Confirm all data is correct - confirm your details"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="payment-confirm-details-your-details-section payment-confirm-details-section">
    <h3>Just before I submit your application, I want to check I have all of your information in correctly</h3>
    <health_v2_confirmation:edit_details_btn />

    {{ obj.primary.forEach(function(field) { }}
        <form_v4:row label="{{= field.label }}">
            {{= field.value }}
        </form_v4:row>
    {{ }); }}

    <hr />

    <form_v4:row label="{{= obj.rebate.label }}" className="rebate-tier">
        {{= obj.rebate.value }}
    </form_v4:row>
    <hr />
</div>