<%@ tag description="The Health Cover Selections Filter" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-abd-template">
    <div class="filter" data-filter-serverside="true">
        <div class="checkbox">
            <input type="checkbox" name="{{= model.abd.name }}" id="{{= model.abd.name }}" class="checkbox-custom checkbox" value="N" />
            <label for="{{= model.abd.name }}">Only show me policies that include or retain an Age-Based Discount</label>
        </div>
    </div>
</core_v1:js_template>