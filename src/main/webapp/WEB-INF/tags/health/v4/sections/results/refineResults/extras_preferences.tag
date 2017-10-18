<%@ tag description="Extras preferences template for refine results menu for mobile"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<section data-panel-id="extras" class="health-refine-results-extras-benefits">
    <div class="refine-results-checkbox-list">
        {{ _.each(benefitsExtras, function(object) { }}
        <div class="checkbox {{= object.class }}">
            <input type="checkbox" data-attach="true" name="health_refineResults_benefitsExtras" id="health_refineResults_benefits_{{= object.id }}" value="{{= object.id }}" title="{{= object.label }}" data-benefit-code="{{= object.code }}" />
            <label for="health_refineResults_benefits_{{= object.id }}" <field_v1:analytics_attr analVal="filter extras" quoteChar="\"" />>{{= object.label }}</label>
        </div>
        {{ }) }}
    </div>
</section>