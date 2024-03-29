<%@ tag description="The Health Cover Selections Filter" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-benefits-template">

    <health_v4:benefits_switch_off_message />

    <div class="separator-container bottom-separator">
        <div class="filter filter-hospital-benefits" data-filter-serverside="true">
            <div class="filter-sub-heading black-text">Hospital</div>
            <field_v2:switch xpath="${pageSettings.getVerticalCode()}/benefits/filters/HospitalSwitch" value="Y" className="benefits-switch switch-small" onText="Yes" offText="No" />
            <div class="filter-by-container">
                <div class="filter-by-hospital-benefits small"></div>
                <a href="#health-filter-hospital-benefits-items" data-toggle="collapse" class="filter-toggle small full-width " data-filter="hospital-benefits" <field_v1:analytics_attr analVal="hospital benefits filter" quoteChar="\"" />>Change</a>
            </div>
            <div id="health-filter-hospital-benefits-items" class="collapse">
                <div class="tab-content health-filter-hospital-benefits">
                    <div id="hospitalBenefits" class="tab-pane fade active in">

                        <div class="benefits-list">
                            {{ _.each(model.benefitsHospital.values, function(object) { }}
                            {{ var checked = object.selected ? ' checked="checked"' : ''; }}
                            <div class="checkbox {{=object.class }}">
                                <input type="checkbox" data-attach="true" name="health_filterBar_benefitsHospital" id="health_filterBar_benefits_{{= object.id }}" value="{{= object.id }}" {{=checked }} title="{{= object.label }}" data-benefit-code="{{= object.code }}" /> <label for="health_filterBar_benefits_{{= object.id }}" <field_v1:analytics_attr analVal="filter hospital" quoteChar="\"" />>{{= object.label }}</label>
                            </div>
                            {{ }) }}
                        </div>
                    </div>
                    <div id="limitedHospital" class="tab-pane fade">
                        <p class="small">Limited Hospital Cover provides the most basic level of hospital cover and is generally the cheapest. It is also sufficient for you to avoid paying the Medicare Levy Surcharge. However, it excludes a large number of benefits that other hospital policies cover as standard, and in some instances, provides cover only where you need treatment as a result of an accident. To compare policies that provide a better level of cover, select comprehensive cover.</p>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <div class="separator-container bottom-separator bottom-separator-widget-padding">
        <div class="filter filter-extras-benefits" data-filter-serverside="true">
            <div class="filter-sub-heading black-text">Extras</div>
            <field_v2:switch xpath="${pageSettings.getVerticalCode()}/benefits/filters/ExtrasSwitch" value="Y" className="benefits-switch switch-small" onText="Yes" offText="No" />
            <health_v4:benefits_switch_extras_message />
            <div class="filter-by-container">
                <span class="filter-by-extras-benefits small"></span>
                <a href="#health-filter-extras-benefits-items" data-toggle="collapse" class="filter-toggle small full-width counter-header-margin" data-filter="extras-benefits" <field_v1:analytics_attr analVal="extras benefits filter" quoteChar="\"" />>Change</a>
            </div>
            <div id="health-filter-extras-benefits-items" class="collapse">
                <div class="benefits-list health-filter-extras-benefits">
                    {{ _.each(model.benefitsExtras.values, function(object) { }}
                    {{ var checked = object.selected ? ' checked="checked"' : ''; }}
                    <div class="checkbox {{=object.class }}">
                        <input type="checkbox" data-attach="true" name="health_filterBar_benefitsExtras" id="health_filterBar_benefits_{{= object.id }}" value="{{= object.id }}" {{=checked }} title="{{= object.label }}" /> <label for="health_filterBar_benefits_{{= object.id }}" <field_v1:analytics_attr analVal="filter extras" quoteChar="\"" />>{{= object.label }}</label>
                    </div>
                    {{ }) }}
                </div>
            </div>
        </div>
    </div>
</core_v1:js_template>