<%@ tag description="Hospital preferences template for refine results menu for mobile"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<section data-panel-id="hospital" class="health-refine-results-hospital-benefits">
    <ul class="nav nav-tabs health-refineResults-hospital-benefits">
        <li class="active"><a data-toggle="tab" href="#refineResultsHospitalBenefits" <field_v1:analytics_attr analVal="hospital cover type" quoteChar="\"" />>Private Hospital</a></li>
        <li><a data-toggle="tab" href="#refineResultsLimitedHospital" <field_v1:analytics_attr analVal="hospital cover type" quoteChar="\"" />>Limited Hospital</a></li>
    </ul>

    <div class="tab-content">
        <div id="refineResultsHospitalBenefits" class="refine-results-checkbox-list tab-pane fade active in">
            {{ _.each(benefitsHospital, function(object) { }}
            <div class="checkbox {{= object.class }}">
                <input type="checkbox" data-attach="true" name="health_refineResults_benefitsHospital" id="health_refineResults_benefits_{{= object.id }}" value="{{= object.id }}" title="{{= object.label }}" data-benefit-code="{{= object.code }}" />
                <label for="health_refineResults_benefits_{{= object.id }}" <field_v1:analytics_attr analVal="filter hospital" quoteChar="\"" />>{{= object.label }}</label>
            </div>
            {{ }) }}
        </div>

        <div id="refineResultsLimitedHospital" class="tab-pane fade">
            <p class="small">Limited Hospital Cover provides the most basic level of hospital cover and is generally the cheapest. It is also sufficient for you to avoid paying the Medicare Levy Surcharge. However, it excludes a large number of benefits that other hospital policies cover as standard, and in some instances, provides cover only where you need treatment as a result of an accident. To compare policies that provide a better level of cover, select comprehensive cover.</p>
        </div>
    </div>
</section>