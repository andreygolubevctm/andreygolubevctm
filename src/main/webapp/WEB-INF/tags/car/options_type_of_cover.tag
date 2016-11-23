<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for type of cover options"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>

<form_v2:row label="What level of car insurance cover are you looking for?" id="${name}FieldRow">
    <field_v2:import_select xpath="${xpath}"
                            url="/WEB-INF/option_data/car_type_of_cover.html"
                            title="what level of car insurance cover are you looking for" className="type_of_cover"
                            required="true" />
</form_v2:row>

<core_v1:js_template id="ctp-message-template">
    <content:get key="ctpMessageCopy"/>
</core_v1:js_template>