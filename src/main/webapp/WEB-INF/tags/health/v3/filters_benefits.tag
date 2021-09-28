<%@ tag description="The Health Cover Selections Filter" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-benefits-template">

    {{ var coverType = meerkat.modules.health.getCoverType(); }}
    {{ var hiddenHospital = coverType === 'E' ? ' hidden' : ''; }}
    {{ var hiddenClinical = ' hidden'; }}
    {{ var hiddenExtras = coverType === 'H' ? ' hidden' : ''; }}
    {{ var hiddenOnCombined = coverType === 'C' ? ' hidden' : ''; }}

    <div class="sidebar-title hidden-xs">Cover Selections</div>

    <div class="row filter" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text">
                    <a class="filter-remove hospital need-hospital {{=hiddenHospital }} {{=hiddenExtras }} btn btn-xs btn-danger" <field_v1:analytics_attr analVal="filter remove hospital" quoteChar="\"" />>Remove <span class="icon icon-cross"></span></a>
                    <a class="filter-add hospital need-no-hospital {{=hiddenExtras }} {{=hiddenOnCombined }} btn btn-xs btn-add" <field_v1:analytics_attr analVal="filter add hospital" quoteChar="\"" />>Add hospital <span class="icon icon-plus"></span></a>
                </span>
                <span class="heading-text">Hospital selections</span>
            </div>
            <div class="sidebar-intro-text need-no-hospital {{=hiddenExtras }} {{=hiddenOnCombined }}">
                <p>Hospital cover enables you to choose your own doctor at the fund's partner hospitals, allowing you to avoid public hospital waiting lists</p>
            </div>
            <div class="benefits-list benefitsHospital need-hospital expanded {{=hiddenHospital }}">
                {{ _.each(model.benefitsHospital.values, function(object) { }}
                {{ var checked = object.selected ? ' checked="checked"' : ''; }}
                <div class="checkbox {{=object.class }}">
                    <input type="checkbox" name="health_filterBar_benefitsHospital" id="health_filterBar_benefits_{{= object.value }}" data-group="{{= object.dataGroup }}" value="{{= object.value }}" {{=checked }} title="{{= object.label }}" />
                    <label for="health_filterBar_benefits_{{= object.value }}" <field_v1:analytics_attr analVal="filter hospital" quoteChar="\"" />><a href="javascript:void(0);" class="help-icon icon-info" data-content="helpid:{{= object.helpId }}" data-toggle="popover" tabindex="-1" <field_v1:analytics_attr analVal="filter qtip {{= object.value }}" quoteChar="\"" />><span class="text-hide">Need Help?</span></a>{{= object.label }}</label>
                </div>
                {{ }) }}
                <a href="javascript:void(0);" class="filter-toggle-all"><span class="text"<field_v1:analytics_attr analVal="filter hospital" quoteChar="\"" />>Show less</span> <span class="icon icon-angle-up"></span></a>
            </div>

        </div>
    </div>

    <div class="row filter need-hospital {{=hiddenHospital }}" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="heading-text">Clinical categories</span>
            </div>
            <div class="benefits-list benefitsClinical">
                {{ _.each(model.benefitsClinical.values, function(object) { }}
                {{ var checked = object.selected ? ' checked="checked"' : ''; }}
                <div class="checkbox hidden">
                    <input type="checkbox" name="health_filterBar_benefitsClinical" id="health_filterBar_benefits_{{= object.value }}" data-groups="{{= object.dataGroups }}" value="{{= object.value }}" {{=checked }} title="{{= object.label }}" />
                    <label for="health_filterBar_benefits_{{= object.value }}" <field_v1:analytics_attr analVal="filter clinical" quoteChar="\"" />><a href="javascript:void(0);" class="help-icon icon-info" data-content="helpid:{{= object.helpId }}" data-toggle="popover" tabindex="-1" <field_v1:analytics_attr analVal="filter qtip {{= object.value }}" quoteChar="\"" />><span class="text-hide">Need Help?</span></a>{{= object.label }}</label>
                </div>
                {{ }) }}
                <a href="javascript:void(0);" class="filter-toggle-all-clinical"><span class="text"<field_v1:analytics_attr analVal="filter clinical" quoteChar="\"" />>View Clinical categories</span> <span class="icon icon-angle-down"></span></a>
            </div>
        </div>
    </div>

    <div class="row filter" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text">
                    <a class="filter-remove extras need-extras {{=hiddenHospital }} {{=hiddenExtras }} btn btn-xs btn-danger" <field_v1:analytics_attr analVal="filter remove extras" quoteChar="\"" />>Remove <span class="icon icon-cross"></span></a>
                    <a class="filter-add extras need-no-extras {{=hiddenHospital }} {{=hiddenOnCombined }} btn btn-xs btn-add" <field_v1:analytics_attr analVal="filter add extras" quoteChar="\"" />>Add extras <span class="icon icon-plus"></span></a>
                </span>
                <span class="heading-text">Extras selections</span>
            </div>
            <div class="sidebar-intro-text need-no-extras {{=hiddenHospital }} {{=hiddenOnCombined }} ">
                <p>Extras cover gives you money back for day to day services like dental, optical and physiotherapy.</p>
            </div>
            <div class="benefits-list benefitsExtras need-extras expanded {{=hiddenExtras }}">
                {{ _.each(model.benefitsExtras.values, function(object) { }}
                {{ var checked = object.selected ? ' checked="checked"' : ''; }}
                <div class="checkbox {{=object.class }}">
                    <input type="checkbox" name="health_filterBar_benefitsExtras" id="health_filterBar_benefits_{{= object.value }}" value="{{= object.value }}" {{=checked }} title="{{= object.label }}" />
                    <label for="health_filterBar_benefits_{{= object.value }}" <field_v1:analytics_attr analVal="filter extras" quoteChar="\"" />><a href="javascript:void(0);" class="help-icon icon-info" data-content="helpid:{{= object.helpId }}" data-toggle="popover" tabindex="-1" <field_v1:analytics_attr analVal="filter qtip {{= object.value }}" quoteChar="\"" />><span class="text-hide">Need Help?</span></a>{{= object.label }}</label>
                </div>
                {{ }) }}
                <a href="javascript:void(0);" class="filter-toggle-all"><span class="text" <field_v1:analytics_attr analVal="filter extras" quoteChar="\"" />>Show less</span> <span class="icon icon-angle-up"></span></a>
            </div>
        </div>
    </div>

    <c:set var="aacLabel" value="ambulanceAccidentCover" />
    <div class="row filter" data-filter-serverside="false">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="heading-text">Cover the Customer has Mentioned</span>
            </div>
            <div class="benefits-list expanded health_filterBar_${aacLabel}_container">
                {{ _.each(model.${aacLabel}.values, function(object) { }}
                {{ var checked = object.selected ? ' checked="checked"' : ''; }}
                <div class="checkbox">
                    <input type="checkbox" name="health_filterBar_${aacLabel}_{{= object.value }}" id="health_filterBar_${aacLabel}_{{= object.value }}" value="{{= object.value }}" {{=checked }} title="{{= object.label }}" />
                    <label for="health_filterBar_${aacLabel}_{{= object.value }}" >
                        {{ if(object.helpId) { }}
                        <a href="javascript:void(0);" class="help-icon icon-info" data-content="helpid:{{= object.helpId }}" data-toggle="popover" tabindex="-1"><span class="text-hide">Need Help?</span></a>
                        {{ } }}
                        {{= object.label }}</label>
                </div>
                {{ }) }}
            </div>
        </div>
    </div>
</core_v1:js_template>