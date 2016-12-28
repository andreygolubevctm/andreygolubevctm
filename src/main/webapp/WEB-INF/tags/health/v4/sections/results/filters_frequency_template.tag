<%@ tag description="The Health Frequency Filter" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<core_v1:js_template id="filter-results-frequency-template">
    <div class="filter-frequency">
        <div class="btn-group btn-group-justified " data-toggle="radio">
            {{ _.each(model.frequency.values, function(object) { }}
            {{ var checked = object.selected ? ' checked="checked"' : ''; }}
            {{ var active = object.selected ? ' active' : ''; }}
            <label class="btn btn-form-inverse {{= active }}" <field_v1:analytics_attr analVal="filter payment freq" quoteChar="\"" />>
                <input type="radio" name="{{= model.frequency.name }}" id="{{= model.frequency.name }}_{{= object.value }}" value="{{= object.value }}" {{=checked }}
                       title="{{= object.label }}" /> {{= object.label }}</label>
            {{ }) }}
        </div>
    </div>
</core_v1:js_template>