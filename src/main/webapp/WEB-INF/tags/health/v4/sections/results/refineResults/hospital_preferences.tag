<%@ tag description="Hospital preferences template for refine results menu for mobile"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<section data-panel="Hospital preferences">
    <p>Hospital preferences items go here</p>

    {{ console.log('benefitsHospital', benefitsHospital); }}

    {{ _.each(benefitsHospital, function(object) { }}

    {{ console.log('object', object); }}

    {{ var checked = object.selected ? ' checked="checked"' : ''; }}
    <div class="checkbox {{=object.class }}">
        <input type="checkbox" data-attach="true" name="health_refineResults_benefitsHospital" id="health_refineResults_benefits_{{= object.id }}" value="{{= object.id }}" {{=checked }} title="{{= object.label }}" data-benefit-code="{{= object.code }}" />
        <label for="health_refineResults_benefits_{{= object.id }}" <field_v1:analytics_attr analVal="filter hospital" quoteChar="\"" />>{{= object.label }}</label>
    </div>
    {{ }) }}
</section>