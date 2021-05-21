<%@ tag description="Button Tile Dropdown Selector template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="buttonTileDropdownSelectorTemplate">
    {{ var $buttonTileTemplate = $('#buttonTileTemplate'); }}
    {{ var buttonTileTemplate = _.template($buttonTileTemplate.html()); }}
    {{ var $dropDownTmpl = $('#dropDownTemplate'); }}
    {{ var dropDownTmpl = _.template($dropDownTmpl.html()); }}

    <div class="errorField"></div>

    <div class="button-tile-dropdown-selector">
        <%--render tile buttons--%>
        {{= buttonTileTemplate(obj) }}

        <%--render other options--%>
        {{ if (obj.items.length > obj.maxRadioItems) { }}
            {{= dropDownTmpl(obj) }}
        {{ } }}
    </div>
</core_v1:js_template>

<core_v1:js_template id="buttonTileTemplate">
    <div class="btn-group btn-group-justified radioIcons" data-toggle="radio">
        {{ for (var i = 0; i < obj.maxRadioItems; i++) { }}
            {{ var name = obj.items[i].name; }}
            {{ var value = obj.items[i].value; }}
            <label class="btn btn-form-inverse button-tile-selector-label">
                <input type="radio" class="button-tile-selector" name="{{= obj.id }}_{{= name }}" value="{{= value }}" data-ignore="true">
                <span>{{= name }}</span>
            </label>
        {{ } }}
    </div>
</core_v1:js_template>

<core_v1:js_template id="dropDownTemplate">
    <div class="text-center">
        <a href="javascript:;" class="button-tile-dropdown-selector-other">other?</a>
    </div>

    <div class="select">
        <span class=" input-group-addon">
            <i class="icon-angle-down"></i>
        </span>
        <select class="form-control array_select drop-down-selector" name="{{= obj.id }}_drop-down-selector" data-ignore="true">
            <option>Please select</option>
            {{ for (var i = obj.maxRadioItems; i < obj.items.length; i++) { }}
                {{ var name = obj.items[i].name; }}
                {{ var value = obj.items[i].value; }}
                <option value="{{= value }}">{{= name }}</option>
            {{ } }}
        </select>
    </div>
</core_v1:js_template>