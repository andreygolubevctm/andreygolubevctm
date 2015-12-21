<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- VARIABLES --%>
<c:set var="xpath" value="xsFilterBar" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Dialog wrapper --%>
<core_v1:js_template id="home-${name}-template">

	<form_v2:fieldset legend="" id="${name}FieldSet">

		<form_v2:row label="Compare by" id="${name}SortRow" className="initial">
			<field_v2:array_radio xpath="${xpath}/sort" required="true"
				className="" items="price=Price,features=Features" title="List results by price or by features" />
		</form_v2:row>

		<form_v2:row label="Repayments" id="${name}FreqRow">
			<field_v2:array_radio xpath="${xpath}/freq" required="true"
				items="monthly=Monthly,annual=Annual" title="" />
		</form_v2:row>

		<form_v2:row label="Home Excess" id="${name}HomeExcessRow">
			<field_v2:array_radio xpath="${xpath}/homeExcess"
				required="true"
				items="100=$100,200=$200,300=$300,400=$400,500=$500,750=$750,1000=$1000" title="" />
<%-- 			<field_v2:slider useDefaultOutputField="true" type="price" value="{{= homeStartingValue}}" range="100,1000" markers="5" step="100" legend="$100,$200,$300,$400,$500,$750,$1000" xpath="${xpath}/homeExcess" /> --%>
		</form_v2:row>

		<form_v2:row label="Contents Excess" id="${name}ContentsExcessRow">
			<field_v2:array_radio xpath="${xpath}/contentsexcess"
				required="true"
				items="100=$100,200=$200,300=$300,400=$400,500=$500,750=$750,1000=$1000" title="" />
<%-- 			<field_v2:slider useDefaultOutputField="true" type="price" value="{{= contentsStartingValue}}" range="100,1000" markers="5" step="100" legend="$100,$200,$300,$400,$500,$750,$1000" xpath="${xpath}/contentsexcess" /> --%>
		</form_v2:row>

	</form_v2:fieldset>

</core_v1:js_template>