<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- VARIABLES --%>
<c:set var="xpath" value="xsFilterBar" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Dialog wrapper --%>
<core:js_template id="home-${name}-template">

	<form_new:fieldset legend="" id="${name}FieldSet">

		<form_new:row label="Compare by" id="${name}SortRow" className="initial">
			<field_new:array_radio xpath="${xpath}/sort" required="true"
				className="" items="price=Price,features=Features" title="List results by price or by features" />
		</form_new:row>

		<form_new:row label="Repayments" id="${name}FreqRow">
			<field_new:array_radio xpath="${xpath}/freq" required="true"
				items="monthly=Monthly,annual=Annual" title="" />
		</form_new:row>

		<form_new:row label="Home Excess" id="${name}HomeExcessRow">
			<field_new:array_radio xpath="${xpath}/homeExcess"
				required="true"
				items="100=$100,200=$200,300=$300,400=$400,500=$500,750=$750,1000=$1000" title="" />
<%-- 			<field_new:slider useDefaultOutputField="true" type="price" value="{{= homeStartingValue}}" range="100,1000" markers="5" step="100" legend="$100,$200,$300,$400,$500,$750,$1000" xpath="${xpath}/homeExcess" /> --%>
		</form_new:row>

		<form_new:row label="Contents Excess" id="${name}ContentsExcessRow">
			<field_new:array_radio xpath="${xpath}/contentsexcess"
				required="true"
				items="100=$100,200=$200,300=$300,400=$400,500=$500,750=$750,1000=$1000" title="" />
<%-- 			<field_new:slider useDefaultOutputField="true" type="price" value="{{= contentsStartingValue}}" range="100,1000" markers="5" step="100" legend="$100,$200,$300,$400,$500,$750,$1000" xpath="${xpath}/contentsexcess" /> --%>
		</form_new:row>

	</form_new:fieldset>

</core:js_template>