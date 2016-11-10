<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- VARIABLES --%>
<c:set var="xpath" value="xsFilterBar" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- Dialog wrapper --%>
<core_v1:js_template id="home-${name}-template">

	<form_v2:fieldset legend="" id="${name}FieldSet">

		<form_v2:row label="Home Excess" id="${name}HomeExcessRow">
			<div class="select">
				<span class="input-group-addon"><i class="icon-sort"></i></span>
				<field_v1:additional_excess
					defaultVal="500"
					increment="100"
					minVal="100"
					xpath="${xpath}/homeExcess"
					maxCount="5"
					title=""
					required=""
					omitPleaseChoose="Y"
					className="form-control"
					additionalValues="750,1000,1500,2000,3000,4000,5000"/>
			</div>
		</form_v2:row>

		<form_v2:row label="Contents Excess" id="${name}ContentsExcessRow">
			<div class="select">
				<span class="input-group-addon"><i class="icon-sort"></i></span>
				<field_v1:additional_excess
						defaultVal="500"
						increment="100"
						minVal="100"
						xpath="${xpath}/contentsexcess"
						maxCount="5"
						title=""
						required=""
						omitPleaseChoose="Y"
						className="form-control"
						additionalValues="750,1000,1500,2000,3000,4000,5000"/>
			</div>
		</form_v2:row>

	</form_v2:fieldset>

</core_v1:js_template>