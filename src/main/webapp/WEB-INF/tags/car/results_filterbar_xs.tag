<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- VARIABLES --%>
<c:set var="xpath" value="xsFilterBar" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Dialog wrapper --%>
<core:js_template id="car-${name}-template">

	<form_new:fieldset legend="" id="${name}FieldSet">

		<form_new:row label="Compare by" id="${name}SortRow" className="initial">
			<field_new:array_radio xpath="${xpath}/sort" required="true"
				className="" items="price=Price,features=Features" title="List results by price or by features" />
		</form_new:row>

		<form_new:row label="Repayments" id="${name}FreqRow">
			<field_new:array_radio xpath="${xpath}/freq" required="true"
				items="monthly=Monthly,annual=Annual" title="" />
		</form_new:row>

		<form_new:row label="Excess" id="${name}ExcessRow">
			<field_new:slider useDefaultOutputField="true" type="price" value="{{= startingValue}}" range="400,2000" markers="4" step="100" legend="$400,$1000,$1500,$2000" xpath="${xpath}/excess" />
		</form_new:row>

	</form_new:fieldset>

</core:js_template>