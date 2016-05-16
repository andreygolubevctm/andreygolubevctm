<%@ tag description="The Health Cover Selections Filter" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-benefits-template">

    {{ var coverType = meerkat.modules.health.getCoverType(); }}
    {{ var hiddenHospital = coverType === 'E' ? ' hidden' : ''; }}
    {{ var hiddenExtras = coverType === 'H' ? ' hidden' : ''; }}
    {{ var hiddenOnCombined = coverType === 'C' ? ' hidden' : ''; }}

    <div class="sidebar-title hidden-xs">Cover Selections</div>

    <div class="row filter" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text">
                    <a class="filter-remove hospital need-hospital {{=hiddenHospital }} {{=hiddenExtras }} btn btn-xs btn-danger">remove <span class="icon icon-cross"></span></a>
                    <a class="filter-add hospital need-no-hospital {=hiddenExtras }} {{=hiddenOnCombined }} btn btn-xs btn-add">add hospital <span class="icon icon-plus"></span></a>
                </span>
                <span class="heading-text">Hospital cover</span>
            </div>
            <div class="sidebar-intro-text need-no-hospital {{=hiddenExtras }} {{=hiddenOnCombined }}">
                <p>Extras cover gives you money back for day to day services like <strong>dental, optical</strong> and <strong>physiotherapy</strong>.</p>
                <p>These services are not covered by Medicare.</p>
            </div>
            <div class="benefits-list benefitsHospital need-hospital {{=hiddenHospital }}">
                {{ _.each(model.benefitsHospital.values, function(object) { }}
                {{ var checked = object.selected ? ' checked="checked"' : ''; }}
                {{ var hidden = !object.selected ? ' hidden' : ''; }}
                <div class="checkbox {{=object.class }} {{=hidden }}">
                    <input type="checkbox" name="health_filterBar_benefitsHospital" id="health_filterBar_benefits_{{= object.value }}" value="{{= object.value }}" {{=checked }} title="{{= object.label }}" /> <label for="health_filterBar_benefits_{{= object.value }}">{{= object.label }}</label>
                    <a href="javascript:void(0);" class="help-icon icon-info" data-content="helpid:{{= object.helpId }}" data-toggle="popover" tabindex="-1"><span class="text-hide">Need Help?</span></a>
                </div>
                {{ }) }}
                <a href="javascript:void(0);" class="filter-toggle-all"><span class="text">add more selections</span> <span class="icon icon-angle-down"></span></a>
            </div>

        </div>
    </div>

    <div class="row filter" data-filter-serverside="true">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text">
                    <a class="filter-remove extras need-extras {{=hiddenHospital }} {{=hiddenExtras }} btn btn-xs btn-danger">remove <span class="icon icon-cross"></span></a>
                    <a class="filter-add extras need-no-extras {{=hiddenHospital }} {{=hiddenOnCombined }} btn btn-xs btn-add">add extras <span class="icon icon-plus"></span></a>
                </span>
                <span class="heading-text">Extras cover</span>
            </div>
            <div class="sidebar-intro-text need-no-extras {{=hiddenHospital }} {{=hiddenOnCombined }} ">
                <p>Extras cover gives you money back for day to day services like <strong>dental, optical</strong> and <strong>physiotherapy</strong>.</p>
                <p>These services are not covered by Medicare.</p>
            </div>
            <div class="benefits-list benefitsExtras need-extras {{=hiddenExtras }}">
                {{ _.each(model.benefitsExtras.values, function(object) { }}
                {{ var checked = object.selected ? ' checked="checked"' : ''; }}
                {{ var hidden = !object.selected ? ' hidden' : ''; }}
                <div class="checkbox {{=object.class }} {{=hidden }}">
                    <input type="checkbox" name="health_filterBar_benefitsExtras" id="health_filterBar_benefits_{{= object.value }}" value="{{= object.value }}" {{=checked }} title="{{= object.label }}" /> <label for="health_filterBar_benefits_{{= object.value }}">{{= object.label }}</label>
                    <a href="javascript:void(0);" class="help-icon icon-info" data-content="helpid:{{= object.helpId }}" data-toggle="popover" tabindex="-1"><span class="text-hide">Need Help?</span></a>
                </div>
                {{ }) }}
                <a href="javascript:void(0);" class="filter-toggle-all"><span class="text">add more selections</span> <span class="icon icon-angle-down"></span></a>
            </div>
        </div>
    </div>
</core_v1:js_template>