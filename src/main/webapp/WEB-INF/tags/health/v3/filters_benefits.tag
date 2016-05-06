<%@ tag description="The Health Cover Selections Filter" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-benefits-template">
    <div class="sidebar-title">Cover Selections</div>

    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a class="filters-remove-extras">remove <span class="icon icon-cross"></span></a></span>
                <span class="heading-text">Hospital cover</span>
            </div>
            <div class="benefitsHospital" data-filter-type="checkbox">
                {{ _.each(model.benefitsHospital.values, function(object) { }}
                {{ var checked = object.selected ? ' checked="checked"' : ''; }}
                {{ var active = object.selected ? ' active' : ''; }}
                <div class="checkbox-none {{=object.class }}">
                    <input type="checkbox" name="health_filterBar_benefitsHospital" id="health_filterBar_benefits_{{= object.value }}" value="{{= object.value }}" {{=checked }}
                           title="{{= object.label }}"/> <label for="health_filterBar_benefits_{{= object.value }}">{{= object.label }}</label>
                    <a href="javascript:void(0);" class="help-icon icon-info" data-content="helpid:{{= object.helpId }}" data-toggle="popover" tabindex="-1"><span
                            class="text-hide">Need Help?</span></a>
                </div>
                {{ }) }}
            </div>
            <a>show all <span class="icon icon-angle-down"></span></a>
        </div>
    </div>

    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a class="filters-remove-extras">remove <span class="icon icon-cross"></span></a></span>
                <span class="heading-text">Extras cover</span>
            </div>
            <div class="benefitsExtras" data-filter-type="checkbox">
                {{ _.each(model.benefitsExtras.values, function(object) { }}
                {{ var checked = object.selected ? ' checked="checked"' : ''; }}
                {{ var active = object.selected ? ' active' : ''; }}
                <div class="checkbox-none {{=object.class }}">
                    <input type="checkbox" name="health_filterBar_benefitsExtras" id="health_filterBar_benefits_{{= object.value }}" value="{{= object.value }}" {{=checked }}
                           title="{{= object.label }}"/> <label for="health_filterBar_benefits_{{= object.value }}">{{= object.label }}</label>
                    <a href="javascript:void(0);" class="help-icon icon-info" data-content="helpid:{{= object.helpId }}" data-toggle="popover" tabindex="-1"><span
                            class="text-hide">Need Help?</span></a>
                </div>
                {{ }) }}
            </div>
            <a>show all <span class="icon icon-angle-down"></span></a>
        </div>
    </div>
</core_v1:js_template>