<%@ tag description="The Health Cover Selections Filter" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="filter-rebate-template">
    <div class="filter" data-filter-serverside="true">
        <div class="checkbox">
            <input type="checkbox" name="{{= model.rebate.name }}" id="{{= model.rebate.name }}" class="checkbox-custom checkbox" value="Y" />
            <label for="{{= model.rebate.name }}">Apply the Australian Government Rebate to lower my upfront premium</label>
        </div>
    </div>
</core_v1:js_template>